---
title: "Getting Started Guide"
linkTitle: "Getting Started"
weight: 3
description: >
  This guide walks through how to deploy a Demo Matchmaker and create your first match.
---

[TODO: Please update with latest demo steps]

## Objectives

- Deploy and run an Open Match based Demo Matchmaker to generate matches.
- Get an overview of the basic concepts and components in an E2E matchmaking setup.

## Prerequisites

This demo assumes that you already have run these steps:

- [Setup a Kubernetes cluster]({{< relref "../Installation/_index.md#setup-kubernetes-cluster" >}}).
- [Install Open Match Core]({{< relref "../Installation/_index.md#install-core-open-match" >}}).

## Concepts for the Demo

Here are some of the Open Match concepts that you will encounter as you run the demo. Concrete examples for these are included in linked code samples in demo components.

* **Ticket**: A basic matchmaking request in Open Match. Typically, it represents a player (or group of players) requesting a match.
* **Assignment**:  Contains the information passed back from Open Match to a Ticket creator. Typically it contains connection information to a Game Server.
* **Match**: A collection of Tickets and some Match metadata.

Here are the components external to core Open Match that are implemented as a part of the demo:

* **Match Function(MMF)**: The core matchmaking logic implemented as a service. It is invoked by Open Match to generate matches. It takes lists of tickets (which meet certain constraints) as input and returns any number of matches. For this basic demo, the Match Function simply pairs any two players into a Match.
* **Director**: A component that requests Open Match for matches and then sets assignments on the Tickets in the matches found.

Here is a sequence diagram of Open Match matching two players.

![Demo Match Sequence Diagram](../../../images/demo-match-sequence.png)

## Install the Demo

This demo deploys the following kubernetes resources.

Under `open-match` namespace:

- A default Evaluator. User could optionally choose to [customize it]({{ relref "../guides/evaluator.md "}}).
- A configmap om-configmap-override that mounts a `matchmaker_config_override.yaml` to boot up Open Match core services.
 
Under `open-match-demo` namespace:

- A MMF (Matchmaking function).  
- The demo itself, which emulates a director and clients connecting to
Open Match.

```bash
# Install the MMF and the demo
kubectl create namespace open-match-demo
kubectl apply --namespace open-match-demo \
  -f https://open-match.dev/install/v{{< param release_version >}}/yaml/02-open-match-demo.yaml

# Install the configmap and the evaluator
kubectl apply --namespace open-match \
  -f https://open-match.dev/install/v{{< param release_version >}}/yaml/06-open-match-override-configmap.yaml \
  -f https://open-match.dev/install/v{{< param release_version >}}/yaml/07-open-match-default-evaluator.yaml
```

Run this command to make the Demo’s service available locally:
```bash
kubectl port-forward --namespace open-match-demo service/om-demo 51507:51507
```

The live working demo is now available at: **[localhost:51507](http://localhost:51507)**.

## Demo Components

This demo shows the current status of several different concurrent processes driving the demo. There are three top-level fields in this demo, which are covered in the following sections.

### Uptime

[Source Code](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/examples/demo/components/uptime/uptime.go)

This simply counts up every second, to show how long the demo has been running.

### Clients

[Source Code](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/examples/demo/components/clients/clients.go)

This emulates requests coming from players wanting to be matched. Each fake player takes these steps:

- Sleeps to emulate a player on the main menu of the game before searching for a match.
- Creates a ticket and sends the request to Open Match.
- Waits to be given an assignment.
- Sleeps to emulate playing a game connected to the given assignment.

### Director

[Source code](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/examples/demo/components/director/director.go)

This emulates the component that tells Open Match what kind of matches to find and gives found matches assignments. The steps it takes:

- Request Open Match to fetch matches from Tickets belonging to the specified pool. The Director does not specify any constraints for the Pool so all the currently searching tickets are considered.
- For each match found, assign the Tickets in that match to a random IP address.  In a normal system, this would be asking a dedicated game server host (such as [Agones](https://agones.dev/site/)) for an IP of a game server instance.
- Sleeps for a bit before restarting.

### Delete the Demo

The demo is installed in its own namespace. Run the below command to delete the demo and reuse the Open Match installation for the next steps:

```bash
kubectl delete namespace open-match-demo
```

### What's Next

Now that you have seen Open Match in action, its time to build your own Open Match based Matchmaker. Here are the recommended next steps:

* [Matchmaking Guide]({{< relref "../Guides/Matchmaker/_index.md" >}}): Deep dive into using Open Match to build your own Matchmaker.
* [Matchmaker Tutorial]({{< relref "../Tutorials/Matchmaker101/_index.md" >}}): Step by step tutorial to authoring your first Open Match based Matchmaker.
