---
title: "How to build a basic Matchmaker"
linkTitle: "Build a basic Matchmaker"
weight: 1
description: >
  A step-by-step tutorial on how to build a basic game mode based Matchmaker in Golang.
---

## Objectives

- Understand how to use Open Match for Matchmaking.
- Author a simple Match Function, Game Frontend and Director in Golang.
- Build and run an E2E Matchmaker by connecting these components to an Open Match deployment.

## Prerequisites

### Set up a Kubernetes Cluster

Some basic understanding of Kubernetes, kubectl is required to efficiently completely this tutorial. Follow the instructions to [set up a Kubernetes cluster]({{< relref "../../Installation/_index.md#setup-kubernetes-cluster" >}}), install and configure kubectl to connect to this cluster.

### Install Open Match

Lets setup Open Match next by running the steps in [Install Open Match Core]({{< relref "../../Installation/_index.md#install-core-open-match" >}}). Please be sure to also [install the default Evaluator]({{< relref "../../Installation/_index.md#install-the-default-evaluator" >}}).

{{% alert title="Note" color="info" %}}
If you already installed Open Match for the [Getting Started Demo]({{< relref "../../Getting Started/_index.md" >}}), you can skip this step. Simply [delete the demo namespace]({{< relref "../../Getting Started/_index.md#delete-the-demo" >}}) and proceed.
{{% /alert %}}

### Set up Image Registry

Please setup an Image registry(such as [Docker Hub](https://hub.docker.com/) or [GC Container Registry](https://cloud.google.com/container-registry/)) to store the Docker Images that will be generated in this tutorial. Once you have set this up, here are the instructions to set up a shell variable that points to your registry:

```
REGISTRY=[YOUR_REGISTRY_URL]
```

If using GKE, the below command can be used to populate the image registry:

```
REGISTRY=gcr.io/$(gcloud config list --format 'value(core.project)')
```

### Get the Tutorial template

Make a local copy of the [Tutorials Folder](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/matchmaker101). Use `tutorials/matchmaker101` as a working copy for all the instructions in this tutorial.

For convenience, set the following variable:

```
TUTORIALROOT=[SRCROOT]/tutorials/matchmaker101
```

### Create the Tutorial namespace

Run this command to create a namespace mm101-tutorial in which all the components for this Tutorial will be deployed.

```
kubectl create namespace mm101-tutorial
```

### Reference Reading

Please read through the [Matchmaking Guide]({{< relref "../../Guides/Matchmaker/_index.md" >}}) as the Matchmaker in this tutorial is modeled around the components introduced in the Guide. Also, keep the [API Reference]({{< relref "../../reference/api.md" >}}) handy to look up Open Match specific terminology used in this document.

## Overview

The goal is to build a basic game mode based Matchmaker where there are a fixed set of game modes and each Player intends to find a match for a specific game mode.

The tutorial walks through building the Game Frontend, Director, Match Function and then deploys them together. Here is a high-level flow once all these components are set up:

- The Game Frontend creates Tickets that specified a game mode.
- The Director requests for matches for a specific game mode.
- The Match Function queries for Tickets from the current pool that match this constraint and groups available Tickets into match proposals.
- The Director receives the matches and sets fake Assignments for Tickets in these.
- The Game Frontend receives these Assignments and then deletes the Tickets.

**A complete [solution](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/matchmaker101/solution) for this tutorial can be found at `tutorials/matchmaker101/solution` To use the solution directly, just run the "Build and Push" step in each of the component sections and then go to [Deploy and Run]({{< relref "./deploy.md" >}})**

## Next Steps

{{< pagelist >}}

## For the curious mind

Open Match enables the user to plug in a custom component called the Evaluator. The Evaluator is responsible for deduplicating any concurrently generated proposals, discarding or promoting the proposals as result Matches. Open Match provides a default Evaluator that this tutorial uses. This tutorial is designed not to generate concurrent conflicting proposals so Evaluation is a no-op. The deployment step deploys the default Evaluator in the tutorial namespace and configures this in Open Match. See the [Evaluator Guide]({{< relref "../../Guides/evaluator.md" >}}) for details on proposal evaluation.
