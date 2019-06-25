---
title: "Overview"
linkTitle: "Overview"
weight: 1
description: >
  Open Match is an open source *game matchmaking framework* to build matchmakers for your game.
---

## Disclaimer

This software is currently [alpha](https://github.com/googleforgames/open-match/releases), and
subject to change. Not to be used in production systems.

## What is Open Match?

Open Match is an open source *game matchmaking framework* designed to give you full control
over how to make matches while removing the burden of dealing with the necessary details that
come with running a high-scale service.

## Why Open Match?

Open Match was created allow game creators to have more control over the matchmaker compared other products.
It respects the idea that your game has unique requirements and gives you room to express that.

## Major Features
 * Pluggable Match Making Function (MMF) - Use any language to create a function that produces matches.
 * Monitoring and Dashboards - Track service health and key metrics with Prometheus and Grafana.
 * Cloud on On-Prem - Runs anywhere Kubernetes runs.

## Code of Conduct

Participation in this project comes under the [Contributor Covenant Code of Conduct](https://github.com/googleforgames/open-match/blob/master/code-of-conduct.md)

## Kubernetes and Docker Explainers

Knowledge of Kubernetes and Docker are **NOT immediately required** to use Open Match. We'll guide you through
them when it's necessary. For more information about these tools see the [glossary]({{< relref "../Reference/glossary.md" >}}).

## What's Next?

 * [Install Open Match]({{< relref "../Getting Started/_index.md" >}}) in your Kubernetes cluster.
 * Make your first match with the [demo function]({{< relref "../Getting Started/first_match.md" >}}).
