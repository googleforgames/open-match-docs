---
title: "Director"
linkTitle: "Director"
weight: 2
description:
  What is the Director? How does it interact with Open Match?
---

## Overview

The Director fetches Matches from Open Match for a set of MatchProfiles. For these matches, it fetches Game Server from a DGS allocation system. It can then communicate the assignments back to the Game Frontend.

## Open Match Interactions

Here are the key interactions the Director has with Open Match:

### Fetching Matches

The Director can fetch matches for one or more MatchProfiles using the following API on Open Match Backend:

```
rpc FetchMatches(FetchMatchesRequest) returns (stream FetchMatchesResponse) {
  option (google.api.http) = {
    post: "/v1/backend/matches:fetch"
    body: "*"
  };
}
```

The request to fetch matches provides a FunctionConfig and one or more MatchProfile.

#### FunctionConfig

For every FetchMatches call, the Director can specify the details of which Match Function to trigger. It can do so by providing the configuration for the Match function, giving the host, port and the type of function endpoint to call.

```
message FunctionConfig {
  string host = 1;
  int32 port = 2;
  Type type = 3;
  enum Type {
    GRPC = 0;
    REST = 1;
  }
}
```

#### MatchProfile

MatchProfile is a representation of a Match specification. It bears the following information:

- Profile name that is then specified in the generated matches to identify which profile a Match belongs to.
- Pools of Tickets to be considered for the Match (each pool has the search criteria to filter players belonging to that Pool)
- Roster (Optional) specifies a named grouping of Ticket Ids, primarily used in Backfill scenarios.

Here is a sample MatchProfile that specifies two different Pools of Tickets with tank and dps roles for a CTF game mode. The director could query concurrently for another MatchProfile that specifies the same roles but for a battle-royale game mode.

```
MatchProfile{
  Name:  "test_profile_name",
  Pools: {
    {
      Name: "pool_ctf_tank",
      TagPresentFilters: []*pb.TagPresentFilter{{Tag: "mode.ctf"}},
      StringEqualsFilters: []*pb.StringEqualsFilter{{
        StringArg: "attributes.role",
        Value:     "tank",
      }}
    },
    {
      Name: "pool_ctf_dps",
      TagPresentFilters: []*pb.TagPresentFilter{{Tag: "mode.ctf"}},
      StringEqualsFilters: []*pb.StringEqualsFilter{{
        StringArg: "attributes.role",
        Value:     "dps",
      }}
    },
  }
}
```

### Assigning Tickets

Once a Match is generated, the Director can fetch a Game Server for this Match from the DGS (Dedicated Game Server) allocation system and then set that as an assignment on all the Tickets of this Match. Here is the API on Open Match Backend to do this:

```
rpc AssignTickets(AssignTicketsRequest) returns (AssignTicketsResponse) {
  option (google.api.http) = {
    post: "/v1/backend/tickets:assign"
    body: "*"
};
```

The API takes a list of TicketIDs to make the assignment and an assignment object.

#### Assignment

Here is the proto for the assignment:

```
message Assignment {
  string connection = 1;
  google.rpc.Status error = 3;
  map<string, google.protobuf.Any> extensions = 4;
}
```

It comprises of the connection string, any error that the user wants to pass through to on the assignment and a set of extension blobs that Open Match passes through.
