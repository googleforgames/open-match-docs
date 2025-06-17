---
title: "Migration"
linkTitle: "Migration"
weight: 30
type: docs
description: >
  Migration guide from Open Match 1 to Open Match 2
---

**Github Repository: https://github.com/googleforgames/open-match2**

## **Migrating Your Open Match Matchmaker from v1 to v2**

This section explains how to update your matchmaking logic to work with the new, more powerful APIs in Open Match 2 (OM2). It covers the evolution from OM1's gRPC-based FetchMatches/AssignTickets pattern to the new InvokeMatchmakingFunctions streaming API in OM2, which is accessible via a gRPC-Gateway.

First, a note on terminology: going forward, we will refer to the developer-written service that orchestrates matchmaking as a **"matchmaker."** The "director" pattern, which periodically fetches matches, is just one of many ways to build a matchmaker.

#### **1\. Shifting from Pure gRPC to a gRPC-Gateway (HTTP) Client**

The most significant infrastructural change for your matchmaker is the move from a direct gRPC connection to an HTTP-based one that leverages gRPC-Gateway for transcoding.

* **In OM1 (director.go),** your matchmaker connected directly to the om-backend service using a pure gRPC client.

```go
// OM1: Direct gRPC connection
conn, err := grpc.Dial("om-backend.open-match.svc.cluster.local:50505", ...)
be := pb.NewBackendClient(conn)
```

* **In OM2 (omclient.go & gsdirector.go),** the recommended pattern is to use a standard HTTP client to communicate with om-core's RESTful endpoint. This endpoint is a **gRPC-Gateway**, which translates the incoming HTTP/JSON requests into gRPC calls on the server side. The omclient.go file provides a reference implementation for this, handling details like authentication and marshaling protobufs to JSON.

* **Why the change?** This was done to simplify client-side infrastructure. While gRPC is highly performant, client-side load balancing can be complex to implement correctly. By offering an HTTP interface, OM2 allows you to use robust, industry-standard, server-side HTTP load balancers from cloud providers, simplifying your deployment and improving reliability.

#### **2\. From FetchMatches to the InvokeMatchmakingFunctions Stream**

The core matchmaking RPC has evolved from a simple request-stream to a more powerful bi-directional stream, enabling more dynamic and continuous matchmaking logic.

* **OM1 Flow:** The FetchMatches RPC involved sending a single request containing all match profiles and then entering a simple loop to drain the response stream of all resulting matches.

* **OM2 Flow:** The new InvokeMatchmakingFunctions RPC is a long-lived, **bi-directional stream**. This allows a matchmaker to send new or updated profiles and receive completed matches concurrently on the same stream without having to initiate new requests.

#### **3\. The New Assignment Flow: AssignTickets is Deprecated**

A critical simplification in OM2 is the removal of the explicit AssignTickets step from the matchmaker's workflow.

* **In OM1,** after receiving matches from FetchMatches, the director had to make a separate AssignTickets RPC call to associate game server connection details with the tickets in each match.

* **In OM2,** this two-step process is eliminated. Your matchmaker receives this match from the InvokeMatchmakingFunctions stream and no longer needs to make a separate call to OM2 to make an assignment; **instead it is responsible for sending the assignment to your online services suite's client notification mechanism directly**. The AssignTickets RPC is now **deprecated**.

While OM2 provides legacy assignment endpoints on the om-core service to ease the initial migration burden, these are intended only as a temporary compatibility layer. You should plan to move away from them as soon as is convenient.

### **Migrating Your Matchmaking Function (MMF) from v1 to v2**

This guide explains how to update your Matchmaking Function (MMF) from the Open Match 1 (OM1) API to the new, more powerful streaming API in Open Match 2 (OM2). The role of the MMF has been elevated in OM2 from a simple "proposal generator" to the core engine that creates final, assignable matches.

#### **1\. Changes to the MMF Service Definition**

The fundamental gRPC contract for the MMF has evolved from a simple request-stream to a more flexible bi-directional stream. This requires changing the signature and core loop of your Run function.

* In OM1 (matchfunction.proto), the Run RPC was a request-response stream:
  rpc Run(RunRequest) returns (stream RunResponse)
  Your MMF received a single RunRequest and then streamed back one or more RunResponse messages containing match proposals.

* In OM2 (mmf.proto), the Run RPC is now a bi-directional stream:
  rpc Run(stream ChunkedMmfRunRequest) returns (stream StreamedMmfResponse)
  This means your MMF's Run function will now concurrently receive requests and send responses on the same stream, allowing for more efficient interaction with om-core.

#### **2\. How You Receive Tickets**

A major simplification is that the MMF is no longer responsible for fetching its own tickets. om-core now handles this and streams the tickets to you.

* **In OM1 (mmf.go),** your MMF had to actively query for tickets. The first step in your Run function was to call a helper like matchfunction.QueryPools, which made a separate RPC call to the Open Match Query Service to get the ticket pool.

* **In OM2 (fifo.go),** your MMF is now a **passive recipient of tickets**. om-core queries for tickets based on the profile sent by the matchmaker and streams them *to* your MMF. Your Run function's logic will now start with a loop that calls stream.Recv() to receive ChunkedMmfRunRequest messages and populate its local ticket pools before starting its matchmaking logic. This removes the need for your MMF to contain any ticket querying code.

#### **3\. Creating Final Matches (Not Proposals)**

The most critical conceptual change is that the MMF's role is no longer to suggest proposals but to create the final, authoritative matches.

* **In OM1,** the RunResponse message contained a Match object that was considered a proposal. This proposal was then sent to a separate Evaluator service to resolve conflicts and make the final decision.

* **In OM2,** with the removal of the Evaluator, the Match your MMF creates is **the final, definitive match**. This means your matchmaking logic must be robust enough to be the source of truth.

## Space Agon Migration Example
The Space Agon example underwent a migration from using Open Match 1 to Open Match 2.

**Migrate Space Agon Demo from using OM 1 to OM2 on Cloud Run:** 

- https://github.com/googleforgames/space-agon/pull/51

**Migrate Space Agon Demo from using OM 1 to OM2 on GKE:**

- https://github.com/googleforgames/space-agon/pull/52

### Notes
- Please check the code changes and descriptions of these 2 pull requests, as they have concrete examples how to migrate from OM1 to OM2.
- Although the migration using Cloud Run was successful, it was later revealed that OM2 on Cloud Run has some performance issues, as it can only handle about 10 ticket creations per second, which significantly limits how fast matches can be generated. Also, as you will see in the example pull request descriptions, the set up for running OM2 on Cloud Run can feel more complex. Therefore, it’s strongly recommended that you use OM2 on GKE, which can handle 500 ticket creations per second and generate 500 matches per second, and can also be deployed relatively easily.
- The Pull Requests involve a large number of file changes, but most of the file changes are in the vendor folder, which is automatically generated. The files that actually have the OM1 to OM2 migration logic are:
    - [director/director.go](https://github.com/googleforgames/space-agon/blob/main/director/director.go)
    - [frontend/frontend.go](https://github.com/googleforgames/space-agon/blob/main/frontend/frontend.go)
    - [mmf/mmf.go](https://github.com/googleforgames/space-agon/blob/main/mmf/mmf.go)
    - [install/helm/space-agon/templates](https://github.com/googleforgames/space-agon/tree/main/install/helm/space-agon/templates)
    - [install/helm/space-agon/values.yaml](https://github.com/googleforgames/space-agon/blob/main/install/helm/space-agon/values.yaml)
    - [omclient/omclient.go](https://github.com/googleforgames/space-agon/blob/main/omclient/omclient.go)
    - [logging/logging.go](https://github.com/googleforgames/space-agon/blob/main/logging/logging.go)
