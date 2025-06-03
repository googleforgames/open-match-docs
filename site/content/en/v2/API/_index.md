---
title: "API"
linkTitle: "API"
weight: 20
type: docs
description: >
   Open Match 2 API
---

**Github Repository: https://github.com/googleforgames/open-match2**

# OpenMatchService gRPC API

The OpenMatchService is a gRPC-based API designed for managing matchmaking tickets, invoking matchmaking functions, and handling ticket assignments in a matchmaking system. The service provides several remote methods (RPCs) to interact with the matchmaking system, including creating tickets, activating/deactivating tickets, and invoking matchmaking functions.

## API Methods

The OpenMatchService API exposes the following methods:

- **CreateTicket**: Creates a new matchmaking ticket and returns its ID.
- **DeactivateTickets**: Deactivates a list of tickets, removing them from matchmaking.
- **ActivateTickets**: Activates a list of tickets, making them eligible for matchmaking.
- **InvokeMatchmakingFunctions**: Invokes external matchmaking functions and processes the results.
- **CreateAssignments (Deprecated)**: Creates assignments for a list of tickets.
- **WatchAssignments (Deprecated)**: Streams the assignment status for requested tickets.

## CreateTicket

**RPC Name**: CreateTicket  
**Request**: CreateTicketRequest  
**Response**: CreateTicketResponse

**Description**: Creates a new ticket in the system, marking it as "inactive" at creation. This ticket is placed in state storage and will expire after the configured OM_TICKET_TTL_SECS time-to-live. Tickets initially do not appear in matchmaking pools until they are activated using the ActivateTickets RPC.

### Example

**Request**:
```json
{
 "ticket": {
   "player_id": "player_id",
   "metadata": {
     "skill_level": "beginner",
     "region": "NA"
   }
 }
}
```
**Response**:
```json
{ "ticket_id": "abcdef12345" }
```

## ActivateTickets

**RPC Name**: ActivateTickets 
**Request**: ActivateTicketsRequest  
**Response**: Empty

**Description**: Activates a list of ticket IDs, making them eligible to be placed in matchmaking pools.

### Example

**Request**:
```json
{ "ticket_ids": ["abcdef12345", "ghijk67890"] }
```

## DeactivateTickets

**RPC Name**: DeactivateTickets 
**Request**: DeactivateTicketsRequest  
**Response**: Empty

**Description**: Activates a list of ticket IDs, making them eligible to be placed in matchmaking pools.

### Example

**Request**:
```json
{ "ticket_ids": ["abcdef12345", "ghijk67890"] }
```

## InvokeMatchmakingFunctions

**RPC Name**: InvokeMatchmakingFunctions 
**Request**: MmfRequest  
**Response**: stream StreamedMmfResponse

**Description**: This RPC is the core of matchmaking. It takes a match profile, processes the tickets
based on pool filters, and invokes external matchmaking functions to return valid matchmaking results.

### Example

**Request**:
```json
{
  "profile": {
    "name": "1v1",
    "pools": {
      "all": {
        "name": "everyone"
      }
    }
  },
  "mmfs": [
    {
      "host": "http://mmf.default.svc.cluster.local",
      "port": 50502,
      "type": "GRPC"
    }
  ]
}
```
**Response**:
```json
[
  {
    "match": {
      "id": "profile-1v1-time-2025-06-03T20:06:57.10-num-0",
      "rosters": {
        "everyone": {
          "name": "1v1",
          "tickets": [
            {
              "id": "1748981212557-0",
              "expirationTime": "2025-06-03T20:16:52.440304094Z",
              "attributes": {
                "creationTime": "2025-06-03T20:06:52.440303651Z"
              }
            },
            {
              "id": "1748981214061-0",
              "expirationTime": "2025-06-03T20:16:53.995424380Z",
              "attributes": {
                "creationTime": "2025-06-03T20:06:53.995424041Z"
              }
            }
          ]
        }
      }
    }
  }
]
```

## WatchAssignments (Deprecated)

**RPC Name**: WatchAssignments
**Request**: WatchAssignmentsRequest
**Response**: stream StreamedWatchAssignmentsResponse

**Description**: Streams assignments for each ticket ID requested, as long as they exist before the
specified timeout. This RPC is designed for situations where clients need to continuously monitor
the status of assignments for tickets, such as when you want to know when a player has been assigned
to a server or a match.

### Example

**Request**:
```json
{
  "ticket_ids": ["abcdef12345", "ghijk67890"]
}
```
**Response**:
```json
[
  {
    "ticket_id": "abcdef12345",
    "assignment_details": {
      "server_id": "server_1",
      "match_id": "match_12345"
    }
  },
  {
    "ticket_id": "ghijk67890",
    "assignment_details": {
      "server_id": "server_2",
      "match_id": "match_12346"
    }
  }
]
```

## CreateAssignments (Deprecated)

**RPC Name**: CreateAssignments
**Request**: CreateAssignmentsRequest
**Response**: Empty

**Description**: Creates assignments that contain match information for tickets with matches assigned.

### Example

**Request**:
```json
{
  "assignment_roster": [
    {
      "ticket_id": "abcdef12345",
      "assignment_details": {
        "server_id": "server_1",
        "match_id": "match_12345"
      }
    }
  ]
}