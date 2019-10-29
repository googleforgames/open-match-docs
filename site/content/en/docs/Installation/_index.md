---
title: "Installation"
linkTitle: "Installation"
weight: 2
description: >
  Follow this guide to setup Open Match in your Kubernetes cluster.
---

In this quickstart, we'll create a Kubernetes cluster and install Open Match.

## Setup Kubernetes Cluster

This guide is for users that do not have a Kubernetes cluster. If you already have one that you can install Open Match into, skip this section and see [how to install Open Match into your cluster]({{< ref "#install-core-open-match" >}}).

### Setup a GKE Cluster

(*this may involve extra charges unless you are on free tier*)

Below are the steps to create a GKE cluster in Google Cloud Platform.

* Create a GCP project via [Google Cloud Console](https://console.cloud.google.com/).
* Billing must be enabled. If you're a new customer you can get some [free credits](https://cloud.google.com/free/).
* When you create a project you'll need to set a Project ID, if you forget it you can see it here, https://console.cloud.google.com/iam-admin/settings/project.
* Install [Google Cloud SDK](https://cloud.google.com/sdk/) which is the command line tool to work against your project.

Here are the next steps using the gcloud tool.

```bash
# Login to your Google Account for GCP
gcloud auth login
gcloud config set project $YOUR_GCP_PROJECT_ID

# Enable necessary GCP services
gcloud services enable containerregistry.googleapis.com
gcloud services enable container.googleapis.com

# Enable optional GCP services for security hardening
gcloud services enable containeranalysis.googleapis.com
gcloud services enable binaryauthorization.googleapis.com

# Test that everything is good, this command should work.
gcloud compute zones list

# Create a GKE Cluster in this project
gcloud container clusters create --machine-type n1-standard-2 open-match-dev-cluster --zone us-west1-a --tags open-match
```

### Setup a Minikube Cluster
Minikube is a tool that allows you to run Kubernetes locally. It deploy a single-node cluster inside a VM for local development purpose. Pleae see Kubernetes doc below for tutorials in detailed.

[Set up a Local Minikube cluster](https://kubernetes.io/docs/setup/minikube/)

## Install Core Open Match

Open Match comprises of a set of services that enable core functionality such as Ticket Management and Filtering etc. It also includes a
state storage to persist state needed for its functioning.

The simplest way to install Open Match is to use the install.yaml files for the latest release.
This installs Open Match with the default configuration.

```bash
# Create a cluster role binding (if using gcloud on Linux or OSX)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user `gcloud config get-value account`

# Create a cluster role binding (if using gcloud on Windows)
for /F %i in ('gcloud config get-value account') do kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user %i

# Create a cluster role binding (if using minikube)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Install the core Open Match services and monitoring services.
kubectl apply -f https://open-match.dev/install/v{{< param release_version >}}/yaml/install.yaml --namespace open-match
```

You should be able to see the output below from your console. The `01-open-match-core.yaml` file contains:

  - A Redis deployment as Open Match's state storage system.
  - ServiceAccounts, Roles and RoleBindings to define Open Match deployments' IAMs. 
  - Several Services for Open Match endpoints. 
  - HorizontalAutoScalars to auto-scale Open Match based on pods' average CPU utilization. 

## Delete Open Match

To delete Open Match and the corresponding sample components from this cluster, simply run:

```bash
kubectl delete namespace open-match
```

## What Next?

Use Open Match as a match maker by installing a match making function and evaluator:

 - Follow the [Getting Started]({{< ref "/docs/Getting Started" >}}) guide to see Open Match in action.