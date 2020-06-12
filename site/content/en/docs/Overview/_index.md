---
title: "Overview"
linkTitle: "Overview"
weight: 1
description: >
  Open Match is an open-source matchmaking framework that simplifies building your game matchmaker.
---

## What is Open Match

Open Match is an open-source game matchmaking framework that simplifies building a scalable and extensible Matchmaker.
It is designed to give the game developer full control over how to make matches while removing the burden of dealing
with the challenges of running a production service at scale.

## Why Open Match

Building your Matchmaker is hard! Along with implementing the core logic to generate quality matches, it also involves solving
challenging problems such as handling massive player populations, effectively searching through them and concurrently
processing match generation logic at scale. Open Match framework provides core services that solve these problems so that the
game developers can focus on the matchmaking logic to match players into great games.

In comparison to off-the-shelf config based Matchmaking solutions, Open Match enables game developers to easily build a customized
Matchmaker that can account for the unique requirements of the game.

## Code of Conduct

Participation in this project comes under the [Contributor Covenant Code of Conduct](https://github.com/googleforgames/open-match/blob/master/code-of-conduct.md)

## What's Next

Here are the recommended next steps to explore Open Match:

* [Installation Guide]({{< relref "../Installation/_index.md" >}}): Set up your Kubernetes cluster and install Open Match in it.
* [Quickstart Guide]({{< relref "../Getting Started/_index.md" >}}): Install a demo application to see E2E Matchmaking using Open Match.
* [Matchmaking Guide]({{< relref "../Guides/Matchmaker/_index.md" >}}): Deep dive into using Open Match to build your Matchmaker.
* [Matchmaker Tutorial]({{< relref "../Tutorials/Matchmaker101/_index.md" >}}): Step by step tutorial to authoring your first Open Match based Matchmaker.
