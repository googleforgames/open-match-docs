---
title: "How to build a basic Matchmaker"
linkTitle: "Build a basic Matchmaker"
weight: 1
description: >
  This tutorial teaches how to build a basic game mode based Matchmaker.
---

## Objectives

- Understand how to use Open Match for Matchmaking.
- Learn to author a simple Match Function, Game Frontend and Director.
- Build an E2E Matchmaker by connecting all these components to an Open Match deployment.
- Run the Matchmaker with fake data to generate matches.

## Prerequisites

### Cluster Setup

Setup a Kubernetes Cluster using these [Setup Instructions]({{< relref "../../Installation/_index.md#setup-kubernetes-cluster" >}}). Once the Cluster is setup, please install and configure kubectl to connect to this cluster. Some basic understanding of kubectl is required to effeciently completely this tutorial.

### Open Match Installation

Lets setup Open Match next by running the steps in [Install Open Match Core]({{< relref "../../Installation/_index.md#install-core-open-match" >}}).

**Note:** As stated in the installation guide, after installing Open Match Core, the pods for core Open Match servies stay in CreatingContainer state. This is expected and is because Open Match requires a ConfigMap that has the configuration for your tutorial. We will update this ConfigMap during the last step of the tutorial when we deploy all the custom components for the tutorial.

### Set up Image Registry

Please setup an Image registry(such as [Docker Hub](https://hub.docker.com/) or [GC Container Registry](https://cloud.google.com/container-registry/)) to store the Docker Images that will be generated in this tutorial. Once you have set this up, here are the instructions to set up a shell variable that points to your registry:

```
REGISTRY=[YOUR_REGISTRY_URL]
```

If using GKE, the below command can be used to populate the image registry:

```
REGISTRY=gcr.io/$(gcloud config list --format 'value(core.project)')
```
### Get the Code

Make a local copy of the Open Match repository. Use <SRCROOT>/tutorials/matchmaker as your working copy for all the instructions in this tutorial.

Once you have the pre-requsisites ready, please proceed with the below steps:

### Reference Reading

It is highly recommended to read through the Matchmaking Guide as the Matchmaker in this tutorial is modeled around the components introduced there. Also, keep the [API Reference]({{< relref "../../reference/api.md" >}}) handy to look up Open Match specific terminology used in this document.

## Overview

This tutorial targets a basic game mode based Matchmaker where there are fixed set of game modes and each Player intends to find a match for a specific game mode.

To implement this, at a high-level, the Game Frontend creates tickets that has specify a game mode and the Game Backend requests for matches for a specific game mode. The Match Function queries for Tickets from the current pool that match this constraint and groups available Tickets into match proposals. The backend then assigns fake assignments to these matches which get returned back to the Game Frontend.

Also note taht the the current version of the tutorial uses Pod logs as output mechanism and so watching these logs will be critical to track progress, debug issues at a later stage when running the Matchmaker.

For the rest of this tutorial, we will refer to [SRCROOT]/tutorials/matchmaker as [TUTORIALROOT]

**A complete solution for this tutorial can be found at [TUTORIALROOT]/tutorials/matchmaker101. To use the solution directly, please perform the "Build and Push" step in each of the sections and then go to [Deploy and Run]({{< relref "./deploy.md" >}})**

## Next Steps

{{< pagelist >}}

## For the curious mind

Open Match enables the user to plug in a custom component called the Evaluator. The Evaluator is responsible for deduplicating any concurrently generated proposals, discarding or promoting the proposals as result Matches. This tutorial is designed not to generate concurrent conflicting proposals and so does not need an Evaluator. However, disabling evaluation although possible is not recommended and so this tutorial comes packaged with a default Evaluator. The deployment step deploys this evaluator in the tutorial namespace and configures this in Open Match but going into the details of using it is out of scope for this tutorial. (Advanced tutorial to follow)
