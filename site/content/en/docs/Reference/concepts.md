---
title: "Concepts"
linkTitle: "Concepts"
weight: 1
description: >
  Open Match uses a lot of Cloud native tools. Here's what they mean.
---

## Concepts

- _Tickets_: a basic matchmaking entity in Open Match that could be used to represent an individual  or players in a group.
- _Assignment_: an object represents the game server that a ticket binds with.
- _Filter_: an object used to query tickets that meets certain filtering criteria.
- _Pool_: an object consists of different filters and an unique ID.
- _Roster_: a named collection of ticket IDs. It is used to represent a team/substeam in a match.
- _MatchProfile_: an object that defines the shape of a match.
- _Match_: an object abstraction of an actual match.
- _Frontend_: a service that manages tickets in open-match.
- _Backend_: a service that generats matches and host assignments in open-match.
- _Mmlogic_: a gateway service that supports data querying in open-match.
- _Matchfunction_: a service where your custom match making logic lives in.
