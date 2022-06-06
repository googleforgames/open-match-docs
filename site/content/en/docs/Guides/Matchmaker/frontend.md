---
title: "Game Frontend"
linkTitle: "Game Frontend"
weight: 1
description:
  What is a Game Frontend? How does it interact with Open Match?
---

## Overview

The Game Frontend receives the matchmaking request from the Player's Game Client. It can authenticate the player and fetch the player data from some backend storage (or Platform Services if required). It submits the matchmaking request to Open Match by creating a Ticket. Once an Assignment is set for this Ticket, the Game Frontend communicates the Assignment back to the Game Client. Game Frontend may handle creating lobbies, groups, etc.

## Open Match Interactions

Here are the key interactions the Game Frontend has with Open Match:

### Creating a Ticket

The Game Frontend adds a new matchmaking request to Open Match by creating a Ticket using the following API on Open Match Frontend:

```proto
rpc CreateTicket(CreateTicketRequest) returns (Ticket) {
  option (google.api.http) = {
    post: "/v1/frontendservice/tickets"
    body: "*"
  };
}
```

#### Ticket

A Ticket represents a single matchmaking request in Open Match. It can represent a single Player or a group of Players. Here is a proto for the Ticket:

```proto
message Ticket {
  // Id represents an auto-generated Id issued by Open Match.
  string id = 1;

  // An Assignment represents a game server assignment associated with a Ticket.
  // Open Match does not require or inspect any fields on Assignment.
  Assignment assignment = 3;

  // Search fields are the fields which Open Match is aware of, and can be used
  // when specifying filters.
  SearchFields search_fields = 4;

  // Customized information not inspected by Open Match, to be used by the match
  // making function, evaluator, and components making calls to Open Match.
  // Optional, depending on the requirements of the connected systems.
  map<string, google.protobuf.Any> extensions = 5;

  // Create time represents the time at which this Ticket was created. It is
  // populated by Open Match at the time of Ticket creation.
  google.protobuf.Timestamp create_time = 6;
}
```

#### SearchFields

When creating a Ticket, the Open Match frontend populates SearchFields which specify the properties for the Ticket that can be used for filtering the Tickets. SearchFields can be of different types (double, string, tag) and an appropriate one should be chosen based on the nature of the property and filtering requirements. Here is a sample SearchField specifying the MMR, role and game mode.

```golang
SearchFields: &pb.SearchFields{
  DoubleArgs: map[string]float64{"attribute.mmr": 50},
  StringArgs: map[string]string{"attribute.role": "warrior"},
  Tags: []string{"mode.demo"},
}
```

### Fetching the Assignment

The Game Frontend can get the current Ticket from Open Match and check if the Ticket has Assignment information populated. Here are the APIs to get a Ticket and to get Assignment information respectively :

```proto
rpc GetTicket(GetTicketRequest) returns (Ticket) {
  option (google.api.http) = {
    get: "/v1/frontendservice/tickets/{ticket_id}"
  };
}
```

```proto
rpc WatchAssignments(WatchAssignmentsRequest)
    returns (stream WatchAssignmentsResponse) {
  option (google.api.http) = {
    get: "/v1/frontendservice/tickets/{ticket_id}/assignments"
  };
}
```

{{% alert title="Note" color="info" %}}
Open Match does not guarantee persistent storage and hence should not be used as the authoritative source for Game Client Assignment information. Once the Assignment for a Ticket is fetched, the Game Frontent should (if necessary) persist this information in its own persistent storage for future lookup.
{{% /alert %}}

### Deleting a Ticket

Once the player Assignment has been stored & communicated to the Game Client, the Game Frontend may delete the Ticket from Open Match. Here is the API exposed on Open Match Frontend to delete a Ticket:

```proto
rpc DeleteTicket(DeleteTicketRequest) returns (google.protobuf.Empty) {
  option (google.api.http) = {
    delete: "/v1/frontendservice/tickets/{ticket_id}"
  };
}
```
