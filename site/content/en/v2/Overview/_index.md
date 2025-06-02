---
title: "Open Match 2 Overview"
linkTitle: "Overview"
weight: 1
type: docs
menu:
  main:
    name: "Open Match 2"
    weight: 10
---

Open Match 2 is a data layer that helps your matchmaker run matching logic at scale. In technical terms, it is a player data cache with a data-retrieving gRPC proxy.

**Github Repository: https://github.com/googleforgames/open-match2**

## Core Responsibilities

It is responsible for:

- **Receiving match requests**: It acts as the central point where game clients or other services submit requests for matches.
- **Managing tickets**: Each match request creates a "ticket" representing a player or group of players seeking a match. OM2 core tracks these tickets.
- **Invoking matchmaking functions**: It uses your configured matchmaking function (MMF) to evaluate tickets and determine suitable matches.
- **Returning matches**: When the MMF finds a suitable match, OM2 core returns the match information to the requesting client or service.