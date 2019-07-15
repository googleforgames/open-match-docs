---
title: "Understand Open Match"
linkTitle: "Basic Concepts"
weight: 10
description: Overview of Open Match core concepts.
---

## Concepts

Here are some of the key concepts introduced by Open Match:

- _Tickets_: a basic matchmaking entity in Open Match that could be used to represent an individual or players in a group.
- _Assignment_: an object represents the game server that a Ticket binds with.
- _Filter_: a condition object used to query the Tickets Pool to filter Tickets meeting that condition.
- _Pool_: a labelled collection of filters used to identify a category of Tickets.
- _Roster_: a named mapping of Ticket IDs used to represent a team/substeam in a Match.
- _MatchProfile_: an object that defines the shape (template) of a Match.
- _Match_: an object abstraction of an actual Match.

For detailed representation of these objects in Open Match, see [Protobuf Definitions](https://github.com/googleforgames/open-match/blob/master/api/messages.proto)

## Core Components

Open Match comprises of the following core services hosted in a Kubernetes cluster:

- _Frontend_: a service that manages Tickets in Open Match.
- _Backend_: a service that generates matches and sets Ticket assignments in Open Match.
- _Mmlogic_: a gateway service that supports data querying in Open Match.
- _Synchronizer_: an internal service that synchronizes evaluation of concurrent Match proposals.
- _StateStorage_: The storage layer used by Open Match to store the matchmaking state.

See detailed explanation of the Core Components and their interactions in [Open Match Internals]({{< relref "../Reference/deep_dive.md" >}}).

## Custom Components

Open Match requires the game developer to provide the following services that are invoked when generating a Match:

- _Matchfunction_: a service where your custom match making logic lives in. This service implements a method that takes a Match Profile as input and returns Match proposals.
- _Evaluator_: a service where your custom evaluation logic lives in. This service implements a method that takes a list of Match proposals as input and returns a list of result Matches.

## Life of a Match

The below are the high level steps involved in generating a Match in a matchmaker built using the Open Match:

![Life of a Match](../../../images/lifeofamatch.jpeg)

### External Components

Here are the external components that the described matchmaking flow assumes to be present in the Online Game Service architecture that uses an Open Match based matchmaker:

- _GameClient_: The actual client (eg. Console) where the request to play a Match originates.
- _GameFrontend_: The service(s) that accepts the request, validates player data etc. and understand game specific requirements for matchmaking (group, backfill)
- _PlatformServices_: Services offered by First Party Platforms (Xbox, PS) that the Game Frontend may need to integrate with.
- _Director_: The Game Backend that can request Open Match for a match and set assignments to Tickets (This could be one or more services and Open Match itself is not authoritative about the details here)
- _GameServers_: The Game Servers hosting the game, which need to be allocated to Tickets during matchmaking.

### Matchmaking flow

1. A Game Client connects to the Game Frontend requesting for a Game Server assignment.
2. The Game Frontend validates the player, fetches its properties from the platform services and calls Open Match Frontend to create a Ticket for this player.
3. After successful Ticket creation, the GameFrontend requests Open Match Frontend to watch the Ticket and stream any Assignment changes back.
4. The Director calls FetchMatches on Open Match Backend to generate Matches for a Match Profile providing details of the Match Function to invoke.
5. Open Match Backend triggers concurrent Match Function executions (one match function call per Match Profile).
6. The Match Function fetches all the Tickets from the Ticket Pools in the Match Profile and generates Match proposals.
7. The Open Match Backend requests the Synchronizer to Evaluate these Proposals.
8. The Synchronizer triggers the Evaluation at the end of a Synchronization cycle.
9. The Evaluator decolides, compares all proposals submitted and returns results.
10. The Open Match Backend returns the FetchMatches results back to the Director.
11. The Director requests the Game Backend for a Game Server allocation for this Match.
12. The Director then sets an Assignment for all the Tickets in the Match to the Game Server that was returned.
13. The Open Match Frontend returns the Assignment set on this Ticket to the GetAssignments call from the Game Frontend that was waiting for assignments.
