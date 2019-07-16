---
title: "Create Your First Match"
linkTitle: "First Match"
weight: 1
description: >
  This guide covers how you can deploy the Demo matchmaker and create your first match.
---

# Concepts for first match

A rough description of some important concepts.  Concrete examples are
included in linked code samples in demo components.

- **Ticket**: A ticket represents a player (or group of players) requesting a
match.
- **Assignment**:  Info passed back from Open Match to a ticket creator.
Typically contains connection information to a game server.
- **Match**: A collection of tickets.
- **Match Making Function**: A server that takes lists of tickets (which meet
specified constraints) as input, and returns any number of matches as ouput.
Often abriviated as MMF.  In this demo, the MMF simply pairs two players (With
no consideration for skill, latency, etc.)
- **Director**: A server not part of Open Match which asks Open Match to find
matches, and then gives assignments to tickets in the matches found.

Here is a sequence diagram of Open Match matching two players.

![Demo Match Sequence Diagram](../../../images/demo-match-sequence.png)

# Install Demo

This demo has the following kubernetes deployments (with services and some other
housekeeping):

- Matchmaking function.
- Evaluator, a piece of Open Match which can be customized, but isn't in this
demo.
- The demo itself, which emulates a director and clients connecting to
Open Match.

Run this command to install:
```bash
kubectl apply -f https://open-match.dev/install/v{{< param release_version >}}/yaml/install-demo.yaml --namespace open-match
```

Now run this command to make the demo’s service available locally:
```bash
kubectl port-forward --namespace open-match service/om-demo 51507:51507
```

The live working demo is now available at
[localhost:51507](http://localhost:51507).

# Demo Components

This demo shows the current status of several different concurrent processes
driving the demo. There are three top level fields in this demo, which are
covered in the following sections.

## Uptime
[Source Code](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/examples/demo/components/uptime/uptime.go)

This simply counts up every second, to show how long the demo has been running.

## Clients
[Source Code](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/examples/demo/components/clients/clients.go)

This emulates requests coming from players wanting to be matched. Each fake
player takes these steps:

- Sleeps to emulate a player on the main menu of the game before searching for a
match.
- Creates a ticket and sends the request to open match.  In the properties of
this ticket it sets the player name, and a dummy value for mode.demo (which
matches an index in the open match configuration, and currently indexes are
required when querying for tickets.)
- Waits to be given an assignment.
- Sleeps to emulate playing a game connected to the given assignment.

## Director
[Source code](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/examples/demo/components/director/director.go)

This emulates the component that tells Open Match what kind of matches to find
and gives found matches assignments. The steps it takes:

- Send request to open match to find matches out of tickets with the given pool.
Note that it requests tickets with mode.demo with a range that includes all of
the tickets created by clients.go. A limitation of the current version is that
these filters must be specified as indexes.
- For each match found, assigns the tickets in that match to a random IP
address.  In a normal system, this would be asking a dedicated game server host
(Such as Agones) for an IP of a game server instance.  
- Sleeps for a bit before restarting.
