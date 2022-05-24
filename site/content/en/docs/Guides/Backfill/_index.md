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

1. Player 1 creates a Ticket (`T1`).
2. Director calls `Backend.FetchMatches` with a MatchProfile.
3. MMF runs `QueryBackfills` and `QueryTickets` using the MatchProfile. It returns `T1`.
4. MMF constructs a new Backfill (`B1`) and returns a `Match` containing ticket `T1` and Backfill `B1`. The Backfill should be created with field `AllocateGameServer` set to `true`, so the game server orchestrator (e.g.: [Agones](https://agones.dev/site/)) knows it has to create a new Game Server. The Director handles making calls to create the Game Server.
5. Director starts allocating a Game Server with Backfill `B1` information.
6. Player 2 creates a Ticket (`T2`).
7. Director calls `Backend.FetchMatches`.
8. MMF runs `QueryBackfills` and `QueryTickets` using the MatchProfile. They return `B1` and `T2` accordingly.
9. MMF determines `B1` could be used based on data set on `B1` by the last run of the MMF (e.g. a number of open slots). `T2` and `B1` form a new Match.
10. When the Game Server has started, it begins polling Open Match to acknowledge the backfill with `Frontend.AcknowledgeBackfill` using the backfill's ID (`B1.ID`) and supplies connection information for the server, to be returned as the `Assignment` data of the tickets `T1` and `T2`. The Game Server also receives the ticket data of the tickets that were assigned so that any data supplied on the ticket (e.g. player IDs) may be used by the game server.

## Considerations

In order to use Backfill you need to customize your MMF and your Game Servers. Backfill IDs should be propagated to each Game Server during Game Server allocation to be used in `AcknowledgeBackfill` requests to define Backfill which is tied to the Game Server.

If Backfill is not being used, no changes are required since the Backfill API doesn't change the behavior of the current Open Match API state.

### Acknowledging Backfills

`AcknowledgeBackfill` is a request made to the Open Match Frontend that serves to notify Open Match that server still interested in the backfill, and to confirm the assignment of the tickets associated with this backfill in the same manner as `Backend.AssignTickets`. The Game Server receives the current Backfill status as well as a list of new tickets that were just acknowledged by the request as a response. The list is not idempotent, but can be appended to prior lists received from `AcknowledgeBackfill`.

GameServers must run `AcknowledgeBackfill` within `backfillTTL` seconds after the Backfill is created and within `backfillTTL` of the last `AcknowledgeBackfill` call after that, where `backfillTTL` is 80% of the pendingReleaseTimeout configuration value.

**Note:** You must keep acknowledging a backfill until it is no longer needed, and if it expires the Backfill object must be recreated and the new ID communicated to the Game Server to begin the `AcknowledgeBackfill` process anew.

### Cleaning up Backfills

This process deletes expired Backfill objects from the state store. Backfills become expired if they are not acknowledged in the `backfillTTL` period.
