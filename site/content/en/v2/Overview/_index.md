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

## Key Differences between OM1 and OM2

- OM2 doesn’t have an evaluator, and has only one binary - Open Match Core - that combines the Frontend, Backend and Query.
    - Open Match 1 Architecture
      ![OM1 Architecture](om1.png)
    - Open Match 2 Architecture
      ![OM2 Architecture](om2.png)
- Frontend and Director communicate with OM1 via gRPC, but use HTTP to communicate with OM2. For see the Space Agon example in the Examples and 
  Migration section for details on how the HTTP requests are made.
- Redis was previously deployed in Kubernetes via helm, but is now deployed in either of the ways below:
    - On Memorystore on Google Cloud Console.
    - Deployed via a yaml config, examples can be found both the Space Agon example or Open Match 2 Github repo. You are welcome to tweak the details
      on the Redis config to verify any performance differences.