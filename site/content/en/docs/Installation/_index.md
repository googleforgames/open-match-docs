---
title: "Installation"
linkTitle: "Installation"
weight: 2
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

## Install Components and Configure Open Match

In order to run Open Match, it must be configured by:

- Installing a match making function and evaluator.
- Updating the configmap with the correct indexes.

[Getting Started]({{< ref "/docs/Getting Started" >}}) contains an example which covers this.

### Delete Open Match

To delete Open Match and the corresponding sample components from this cluster, simply run:

```bash
kubectl delete namespace open-match
```
