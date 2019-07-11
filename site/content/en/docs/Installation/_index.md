---
title: "Installation"
linkTitle: "Installation"
weight: 3
description: >
  Follow this guide to setup Open Match in your Kubernetes cluster.
---

In this quickstart, we'll create a Kubernetes cluster, install Open Match, and create matches with the example tools.

## Setup Kubernetes Cluster

This guide is for users that do not have a Kubernetes cluster. If you already have one that you can install Open Match into, skip this section.

* [Set up a Google Cloud Kubernetes Cluster]({{< relref "./setup_gke.md" >}}) (*this may involve extra charges unless you are on free tier*)
* [Set up a Local Minikube cluster](https://kubernetes.io/docs/setup/minikube/)

## Install Core Open Match

Once the cluster is set up, the next step is to install core Open Match services in the kubernetes cluster. To do this, please follow the instructions in the
[Install Open Match Core]({{< relref "./install_om.md" >}}) guide.

### Install Custom Components

Open Match requires the game developer to provide a Match Function and an Evaluator service.
[Install Example Components]({{< relref "./install_components.md" >}}) guide provides details for configuring these components and steps to set up an example Match Function and Evaluator in the kubernetes cluster.

### Generate Matches

After setting up Open Match, the Match Function and Evaluator, Open Match is now ready to accept Tickets and requests to generate Matches. Note that Open Match should be configured with a list of indices that will map to the Ticket properties that Open Match will index Tickets on. Here are the high level instructions to generate matches:

* Implement a Frontend Client that will interact with Open Match Frontend to create new Tickets, wait for Ticket Assignemnts and Delete Tickets.
* Implement a Backend Client that will request Open Match for Matches, passing in different Match Profiles to describe the desired Matches.

The installation of sample components in the previous step also sets up a demo example that preforms the tasks of a Frontend, Backend client triggering generation of sample Tickets, requesting for Matches and setting (fake) assignments on these Matches.

You can modify the example MMF, Evaluator and Demo client application to your game specifications to set up a prototype matchmaker for your service.

### Delete Open Match

To delete Open Match and the corresponding sample components from this cluster, simply run:

```bash
kubectl delete namespace open-match
```
