---
title: "Match Function"
linkTitle: "Match Function"
weight: 3
description:
  What is a Match Function? What should it do?
---

## Overview

The Match Function is the component that implements the core matchmaking logic. A Match Function receives a MatchProfile as input should return matches for this MatchProfile.

## Details

A Match Function is a GRPC or HTTP service that implements the Match Function definition prescribed by Open Match.

### Definition

```
rpc Run(RunRequest) returns (stream RunResponse) {
  option (google.api.http) = {
    post: "/v1/matchfunction:run"
    body: "*"
  };
}

message RunRequest {
  MatchProfile profile = 1;
}

message RunResponse {
  Match proposal = 1;
}
```

This method is triggered at runtime whenever a FetchMatches call is received by Open Match Backend for a MatchProfile. At a high level, here is what a Match Function typically should do:

#### Query Tickets

The MatchProfile that the Match Function receives has a set of Pools specified. Typically, the Match Function will call into Open Match to fetch all the Tickets belonging to each of the pools in the Match function. This can be done using the following API exposed by the Open Match QueryService:

```
rpc QueryTickets(QueryTicketsRequest) returns (stream QueryTicketsResponse) {
  option (google.api.http) = {
    post: "/v1/queryservice/tickets:query"
    body: "*"
  };
}
```

Given that this functionality will be most commonly required for Match Functions, Open Match provides a golang library ("open-match.dev/open-match/pkg/matchfunction") to abstract this logic:

```
func QueryPools(ctx context.Context, mml pb.QueryServiceClient, pools []*pb.Pool) (map[string][]*pb.Ticket, error) {
}
```

#### Generate Match Proposals

Now that we have the Tickets belonging to each pool, the Match Function can group them into matches as per the game's requirements. Note that each Ticket with all its SearchFields and extensions are available to the Match Function. Once the proposals are generated, they are streamed back to Open Match.
