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
**Response**: ActivateTicketsResponse

**Description**: Activates a list of ticket IDs, making them eligible to be placed in matchmaking pools.

### Example

**Request**:
```json
{ "ticket_ids": ["abcdef12345", "ghijk67890"] }
```
**Response**:
```json
{}
```

## DeactivateTickets

**RPC Name**: DeactivateTickets 
**Request**: DeactivateTicketsRequest  
**Response**: DeactivateTicketsResponse

**Description**: Activates a list of ticket IDs, making them eligible to be placed in matchmaking pools.

### Example

**Request**:
```json
{ "ticket_ids": ["abcdef12345", "ghijk67890"] }
```
**Response**:
```json
{}
```