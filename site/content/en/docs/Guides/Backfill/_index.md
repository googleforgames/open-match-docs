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

1. Player creates Ticket (__T1__).
2. Director calls Backend which calls MatchMaking Function (MMF) to build matches with the MatchProfile passed along. 
3. MMF finds __T1__, creates a new Backfill (__B1__*), assings __T1__ to __B1__ and sets __T1__ status as __Pending__. In the response to Director it is sent a Match with ticket __T1__ and backfill __B1__.
4. Director starts allocating GameServer.
5. Another player creates a Ticket (__T2__).
6. Director calls Backend which calls MMF to build matches.
7. MMF finds __T1__, __T2__ and __B1__. __T1__ is excluded since it has a __Pending__ state and __B1__ is used because it has open slots available. Also, __T2__ is assigned to __B1__ and __T2__ state is set to __Pending__.
8. When GameServer allocating ends, it starts pinging Open Match to acknowledge the backfill received in the match (__B1__) and deliver the address of the GameServer to __T1__ and __T2__.

*: The Backfill should be created with field `AllocateGameServer` set to `true`, so GameServer orchestrator (e.g.: [Agones](https://agones.dev/site/)) knows it has to create a new GameServer.

## Considerations

Since Backfill is a large feature, using it requires changes to many components inside Open Match.
If Backfill is not being used, no changes are required since the Backfill API doesn't change 
the behavior of the current Open Match API state.
