---
title: "Open Match Core Concepts"
linkTitle: "Core Concepts"
weight: 1
description: An overview of core Open Match concepts.
---
This page is Work in Progress - Please revisit later.

## Concepts

Here are some of the key concepts introduced by Open Match:

- **Ticket**: A basic matchmaking entity in Open Match that represents an individual or players in a group. A Ticket can have an assignment. At any point, the Tickets in Open Match represent the currently active matchmaking pool.
- **Assignment**: An entity representing the backend server assignment for a Ticket.
- **SearchCriteria**: A property specified on a Ticket that can be used for filtering Tickets.
- **Filter**: An object representing a constraint that can be used to query the Tickets to shortlist the ones that meet the constraint.
- **Pool**: a labelled collection of filters used to shortlist a set of Tickets from the currently active pool.
- **MatchProfile**: an object that defines the shape (template) of a Match. It contains one or more Pools to identify the Ticket sets to be considered when creating a match for this profile.
- **Roster**: An entity used to represent mapping of Ticket groups to
- **Match**: An entity that represents the Match comprising of a set of Tickets and an optional Roster specifying their groupings.

For detailed representation of these objects in Open Match, see [Protobuf Definitions](https://github.com/googleforgames/open-match/blob/master/api/messages.proto)

## Components

Here are the external components that the described matchmaking flow assumes to be present in the Online Game Service architecture that uses an Open Match based matchmaker:

- _GameFrontend_: The service(s) that accepts the request, validates player data etc. and understand game specific requirements for matchmaking (group, backfill)
- _Director_: The Game Backend that can request Open Match for a match and set assignments to Tickets (This could be one or more services and Open Match itself is not authoritative about the details here)
- _Matchfunction_: a service where your custom match making logic lives in. This service implements a method that takes a Match Profile as input and returns Match proposals.
- _Evaluator_: a service where your custom evaluation logic lives in. This service implements a method that takes a list of Match proposals as input and returns a list of result Matches.
