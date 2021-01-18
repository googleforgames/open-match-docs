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
* A large player count game (e.g.: battleroyal) will create a non-full match and allow players to connect to the game server prior to it being full. Players will wait in a lobby on the game server while new players are backfilled into the game until the server is fully populated.
* A social or world place in a game allows players to see others in the space, but other players are not strictly required. When players enter the game it is preferred to put players into an existing server, preventing players from joining low population servers. As existing servers reach capacity, the game server management service starts up new empty servers. The new empty servers request players to be backfilled into them, allowing more players to join world servers. Servers may be very long living, as new players replace the leaving players.
* A multiplayer game has a player(s), leave the game, and makes a request for new players to be backfilled into the game. One of the players in the game invites a friend to join using a social platform. The friend joins the game, and the game server cancels its backfill request.

## Main algorithm

1. Player creates Ticket (`T1`).
2. Director calls Backend which calls MatchMaking Function (MMF) to build matches with the MatchProfile passed along. 
3. MMF finds `T1`, creates a new Backfill (`B1`*) and sets `T1` status as `Pending`. Match is sent to Director containing ticket `T1` and Backfill `B1`.
4. Director starts allocating GameServer.
5. Another player creates a Ticket (`T2`).
6. Director calls Backend which calls MMF to build matches.
7. MMF finds `T2` and `B1`. `T1` is excluded since it has a `Pending` state and `B1` is used because it has open slots available. Also, `T2` state is set to `Pending`.
8. When GameServer allocating ends, it starts pinging Open Match to acknowledge the backfill received in the match (`B1`) and deliver the address of the GameServer to `T1` and `T2`.

*: The Backfill should be created with field `AllocateGameServer` set to `true`, so GameServer orchestrator (e.g.: [Agones](https://agones.dev/site/)) knows it has to create a new GameServer.

## Considerations

Since Backfill is a large feature, using it requires changes to many components inside Open Match.
If Backfill is not being used, no changes are required since the Backfill API doesn't change 
the behavior of the current Open Match API state.

## Configuration

```yaml
# Defines the default time for a backfill lock should live.
backfillLockTimeout: 1m
```