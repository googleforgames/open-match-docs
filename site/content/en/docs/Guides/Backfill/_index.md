---
title: "Backfill"
linkTitle: "Backfill"
weight: 5
description: >
  Details of Open Match Backfill.
---

## Background

Some scenarios that could happen when playing multiplayer games include:

* A multiplayer game has a player(s) leave the game. To keep the game interesting and fun, matchmaking will replace the missing player with someone new.
* A large player count game (e.g.: battle royale) will create a non-full match and allow players to connect to the game server prior to it being full. Players will wait in a lobby on the game server while new players are backfilled into the game until the server is fully populated.
* A social or world place in a game allows players to see others in the space, but other players are not strictly required. When players enter the game it is preferred to put players into an existing server, preventing players from joining low population servers. As existing servers reach capacity, the game server management service starts up new empty servers. The new empty servers request players to be backfilled into them, allowing more players to join world servers. Servers may be very long living, as new players replace the leaving players.
* A multiplayer game has a player(s), leave the game, and makes a request for new players to be backfilled into the game. One of the players in the game invites a friend to join using a social platform. The friend joins the game, and the game server cancels its backfill request.

## Main algorithm

A Match Function example using Backfill can be found [here](https://github.com/googleforgames/open-match/blob/master/examples/functions/golang/backfill/mmf/matchfunction.go).

1. Player creates Ticket (`T1`).
2. Director calls `Backend.FetchMatches` with a MatchProfile.
3. MMF runs `QueryBackfills` and `QueryTickets` using the MatchProfile. It returns `T1`.
4. MMF use `T1`, constructs a new Backfill (`B1`*) and returns a `Match` containing ticket `T1` and Backfill `B1`.
5. Director starts allocating GameServer with Backfill `B1` information.
6. Another player creates a Ticket (`T2`).
7. Director calls `Backend.FetchMatches`.
8. MMF runs `QueryBackfills` and `QueryTickets` using the MatchProfile. They return `B1` and `T2` accordingly.
9. MMF determines `B1` could be used because it has open slots available. `T2` and `B1` forms a new Match.
10. When GameServer allocating ends, it starts polling Open Match to acknowledge the backfill with `Frontend.AcknowledgeBackfill` by ID received in the Match (`B1.ID`) and in order to assign the address of the GameServer for `T1` and `T2`.

*: The Backfill should be created with field `AllocateGameServer` set to `true`, so GameServer orchestrator (e.g.: [Agones](https://agones.dev/site/)) knows it has to create a new GameServer.

## Considerations

Since Backfill is a large feature, using it requires changes to many components inside Open Match.
If Backfill is not being used, no changes are required since the Backfill API doesn't change 
the behavior of the current Open Match API state.

### Acknowledging Backfills

AcknowledgeBackfill is a request, that acts as a periodic ping, made to Open Match Frontend to set the assignment on the tickets associated with this backfill.
GameServer receives current Backfill status as a response.

GameServers would run AcknowledgeBackfill every N seconds, where N is, at most, `backfillTTL` represents 80% of pendingReleaseTimeout and this value MUST always be bigger than N (backfillTTL = 0.8 * pendingReleaseTimeout; N < backfillTTL, where N is AcknowledgeBackfill interval)

### Cleaning up Backfills

This process deletes expired Backfill objects from the state store. Backifll becomes expired if it is not acknowledged in `backfillTTL` period.

Note: you need to keep acknowledging a backfill and if it expires you need to recreate the Backfill object again.
