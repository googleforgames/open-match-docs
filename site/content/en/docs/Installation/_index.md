---
title: "Installation"
linkTitle: "Installation"
weight: 2
description: >
  Follow this guide to setup Open Match in your Kubernetes cluster.
---

In this quickstart, we'll create a Kubernetes cluster and install Open Match.

## Setup Kubernetes Cluster

This guide is for users that do not have a Kubernetes cluster. If you already have one that you can install Open Match into, skip this section and see [how to install Open Match into your cluster]({{< relref "./yaml.md#install-core-open-match" >}}).

### Setup a GKE Cluster

(*this may involve extra charges unless you are on the free tier*)

Below are the steps to create a GKE cluster in the Google Cloud Platform.

* Create a GCP project via the [Google Cloud Console](https://console.cloud.google.com/).
* Billing must be enabled. If you're a new customer you can get some [free credits](https://cloud.google.com/free/).
* When you create a project you'll need to set a Project ID, if you forget it you can see it here, https://console.cloud.google.com/iam-admin/settings/project.
* Install [Google Cloud SDK](https://cloud.google.com/sdk/) which is the command-line tool to work against your project.

Here are the next steps using the gcloud tool.

```bash
# Login to your Google Account for GCP
gcloud auth login
gcloud config set project $YOUR_GCP_PROJECT_ID

# Enable necessary GCP services
gcloud services enable containerregistry.googleapis.com
gcloud services enable container.googleapis.com

# Test that everything is good, this command should work.
gcloud compute zones list

# Create a GKE Cluster in this project
gcloud container clusters create --machine-type n1-standard-2 open-match-cluster --zone us-west1-a --tags open-match

# Get kubectl credentials against GKE
gcloud container clusters get-credentials open-match-cluster --zone us-west1-a
```

### Setup a Minikube Cluster

Minikube is a tool that allows you to run Kubernetes locally. It deploys a single-node cluster inside a VM for local development purpose. Please see the Kubernetes doc below for tutorials in detailed.

[Set up a Local Minikube cluster](https://kubernetes.io/docs/setup/minikube/)

## What Next?

Follow the Installation guide to install Open Match using Helm or YAML.
