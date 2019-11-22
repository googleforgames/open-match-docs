---
title: "Add new matchmaking criteria"
linkTitle: "Add new matchmaking criteria"
weight: 2
description: >
  A tutorial on how to add new matchmaking criteria to the basic Matchmaker.
---

## Objectives

- Adds new search criteria to Open Match
- Write a MatchFunction to get Tickets from multiple Pools and generate Team-based Matches.

## Prerequisites

### Basic Matchmaker Tutorial

It is highly recommended that you run the [Basic Matchmaker tutorial]({{< relref "../Matchmaker101/_index.md" >}}) as it introduces the core concepts that this tutorial builds upon. After completion, please remember to [cleanup the basic tutorial]({{< relref "../Matchmaker101/deploy.md#cleanup" >}}) before proceeding.

### Set up Image Registry

Please setup an Image registry(such as [Docker Hub](https://hub.docker.com/) or [Google Cloud Container Registry](https://cloud.google.com/container-registry/)) to store the Docker Images used in this tutorial. Once you have set this up, here are the instructions to set up a shell variable that points to your registry:

```bash
REGISTRY=[YOUR_REGISTRY_URL]
```

If using GKE, you can populate the image registry using the command below:

```bash
REGISTRY=gcr.io/$(gcloud config list --format 'value(core.project)')
```

If using Minikube, please run the command below to instruct Minikube to [use local Docker images](https://kubernetes.io/docs/setup/learning-environment/minikube/#use-local-images-by-re-using-the-docker-daemon):
```bash
eval $(minikube docker-env)
```

### Get the Tutorial template

Make a local copy of the [Tutorials Folder](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/matchmaker102). Use `tutorials/matchmaker102` as a working copy for all the instructions in this tutorial.

For convenience, set the following variable:

```bash
TUTORIALROOT=[SRCROOT]/tutorials/matchmaker102
```

### Create the Tutorial namespace

Run this command to create a namespace mm102-tutorial in which all the components for this Tutorial will be deployed.

```bash
kubectl create namespace mm102-tutorial
```

## References

Please read through the [Matchmaking Guide]({{< relref "../../Guides/Matchmaker/_index.md" >}}) as the Matchmaker in this tutorial is modeled around the components introduced in the Guide. Also, keep the [API Reference]({{< relref "../../reference/api.md" >}}) handy to look up Open Match specific terminology used in this document.

A complete [solution](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/matchmaker102/solution) for this tutorial is in the folder `tutorials/matchmaker102/solution`.

## Changes to Components

### Overview

For this tutorial, let's consider a game where each Player will choose to play the Match with a specific role (one of DPS, support or tank). Assume that a Match (for each game-mode) will comprise of one Player of each role. Here are the high-level changes to the Game Frontend, the Director and the MatchFunction to achieve this:

- The Game Frontend will specify the role on a new SearchField on each Ticket.
- The Director will specify multiple Pools in each MatchProfile, one per role.
- The MatchFunction will query for Tickets for each Pool and generate Matches with a Ticket of each role.

The below sections cover the changes to be made to the key components to achieving this.

### Game Frontend

This tutorial provides a Game Frontend scaffold (`$TUTORIALROOT/frontend`) that generates a Ticket with the game mode specified (as implemented for the basic Matchmaker). The mock Ticket generation is implemented in `makeTicket()` in `$TUTORIALROOT/frontend/ticket.go`.

We need to add a new SearchField to the Ticket to represent the role property for this Player. The below code snippet picks a random role and sets it as a StringArg SearchField for the fake Ticket.

```golang
func makeTicket() *pb.Ticket {
  ticket := &pb.Ticket{
    SearchFields: &pb.SearchFields{
      Tags: []string{
        gameMode(),
      },
      StringArgs: map[string]string{
        "attributes.role": role(),
      },
    },
  }

  return ticket
}

func role() string {
  roles := []string{"role.dps", "role.support", "role.tank"}
  return roles[rand.Intn(len(roles))]
}
```

Please update the Ticket creation logic in `$TUTORIALROOT/frontend/ticket.go` with the above snippet and make your own tweaks.

### Director

This tutorial provides a Director scaffold (`$TUTORIALROOT/director`) that generates a MatchProfile per game-mode and then calls FetchMatches for each MatchProfile. The MatchProfile generation is implemented in `generateProfiles()` in `$TUTORIALROOT/director/profile.go`

In the basic Matchmaker, each MatchProfile had a single Pool specifying the game-mode filter. For this tutorial, we will have a Pool per role that filters the role along with the filter for the mode. Thus, the `generateProfiles()` will generate a MatchProfile for each game-mode, each of which will have a Pool per role. Below is a sample snippet to achieve this:

```golang
func generateProfiles() []*pb.MatchProfile {
  var profiles []*pb.MatchProfile
  modes := []string{"mode.demo", "mode.ctf", "mode.battleroyale"}
  roles := []string{"role.dps", "role.support", "role.tank"}
  for _, mode := range modes {
    var pools []*pb.Pool
    for _, role := range roles {
      pools = append(pools, &pb.Pool{
        Name: fmt.Sprintf("pool_%s_%s", mode, role),
        TagPresentFilters: []*pb.TagPresentFilter{{Tag: mode}},
        StringEqualsFilters: []*pb.StringEqualsFilter{
          {
            StringArg: "attributes.role",
            Value:     role,
          },
        },
      })
    }

    profiles = append(profiles, &pb.MatchProfile{
      Name:  "profile_" + mode,
      Pools: pools,
    })
  }

  return profiles
}

```

Please update the MatchProfile creation logic in `$TUTORIALROOT/director/profiles.go` with the above snippet and make your own tweaks.

### MatchFunction

This tutorial provides a MatchFunction scaffold (`$TUTORIALROOT/matchfunction`) that generates Match proposals for the MatchProfile that gets passed in. The core matchmaking logic is implemented in `makeMatches()` in `$TUTORIALROOT/matchfunction/mmf/matchfunction.go`.

The `QueryPools` helper from the `matchfunction` library already provides the ability to query Tickets for all the Pools in the MatchProfile. Also, the basic Matchmaker implementation already picks players from each Pool into the Match - hence just by the MatchProfile having one Pool per role, the existing MatchFunction will generate Match proposals with Tickets of each role.

Although no changes are needed to the core matchmaking logic, you may add some logging or tweak the number of players from each role in a team, etc., to observe the change in matchmaking behavior.

## Build, Deploy, Run

### Build and Push Container images

Now that you have customized these components, please run the below commands from `$TUTORIALROOT` to build new images and push them to your configured image registry.

```bash
docker build -t $REGISTRY/mm102-tutorial-frontend frontend/
docker push $REGISTRY/mm102-tutorial-frontend
docker build -t $REGISTRY/mm102-tutorial-director director/
docker push $REGISTRY/mm102-tutorial-director
docker build -t $REGISTRY/mm102-tutorial-matchfunction matchfunction/
docker push $REGISTRY/mm102-tutorial-matchfunction
```

### Deploy and Run

Run the below command in the `$TUTORIALROOT` path to deploy the MatchFunction, Game Frontend and the Director to the `mm102-tutorial` namespace:

```bash
sed "s|REGISTRY_PLACEHOLDER|$REGISTRY|g" matchmaker.yaml | kubectl apply -f -
```

### Output

All the components in this tutorial simply log their progress to stdout. Thus to see the progress, run the below commands:

```bash
kubectl logs -n mm102-tutorial pod/mm102-tutorial-frontend
kubectl logs -n mm102-tutorial pod/mm102-tutorial-director
kubectl logs -n mm102-tutorial pod/mm102-tutorial-matchfunction
```

## Cleanup

Run the command below to remove all the components of this tutorial:

```bash
kubectl delete namespace mm102-tutorial
```

This will delete all the components deployed in this tutorial. Open Match core in open-match namespace can then be reused for other exercises but you will need to re-customize it.

## What Next

Given that a Ticket can only pick one game-mode, the Matchmaker implemented so far generate Matches from completely partitioned Tickets, where a Ticket is only considered for a game-mode. Next, we can learn how to [use the default evaluator]({{< relref "../DefaultEvaluator/_index.md" >}}) to handle scenarios where a Ticket may specify multiple game mode preferences and hence may be picked by more than one MatchFunction.
