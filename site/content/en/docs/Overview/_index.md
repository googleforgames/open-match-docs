---
title: "Overview"
linkTitle: "Overview"
weight: 1
description: >
  Open Match is an open source *matchmaking framework* that simplifies building your own game matchmaker.
---

## Disclaimer

This software is currently [alpha](https://github.com/googleforgames/open-match/releases), and
subject to change. Not to be used in production systems.

## What is Open Match?

Open Match is an open source *game matchmaking framework* that simplifies building a scalable and extensible Matchmaker.
It is designed to give the game developer full control over how to make matches while removing the burden of dealing
with the challenges of running a production service at scale.

## Why Open Match?

Building your own Matchmaker is hard! Along with implementing the core logic to generate quality matches, it also involves solving
challenging problems such as such as handling massive player population, effectively searching through them and concurrently
processing match generation logic at scale. Open Match framework provides core services that solve these problems so that the
game developers can focus on the matchmaking logic to match players into great games.

In comparison to off-the-shelf config based Matchmaking solutions, Open Match enables game developers to easily buid a customized
Matchmaker that can account for the unique requirements of the game.

## Code of Conduct

Participation in this project comes under the [Contributor Covenant Code of Conduct](https://github.com/googleforgames/open-match/blob/master/code-of-conduct.md)

## What's Next?

 * [Get Started]({{< relref "../Getting Started/_index.md" >}}) with Open Match by understanding core concepts and setting up a demo.
 * [Install Open Match]({{< relref "../Installation/_index.md" >}}) in your Kubernetes cluster and build a simple prototype Matchmaker for your game.

## Kubernetes and Docker Explainers

Knowledge of Kubernetes and Docker is **NOT immediately required** to use Open Match. We'll guide you through
them when it's necessary. For more information about these tools see the [glossary]({{< relref "../Reference/glossary.md" >}}).
