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

Open Match comprises of a set of core services hosted in a Kubernetes cluster. The simplest way to install Open Match core is to use the 01-open-match-core.yaml for the latest release. This installs Open Match with the default configuration.

The `01-open-match-core.yaml` contains:

* Core Open Match service deployments.
* A Redis deployment as Open Match's state storage system.
* ServiceAccounts, Roles and RoleBindings to define Open Match deployments' IAMs.
* HorizontalAutoScalars to auto-scale Open Match based on pods' average CPU utilization.

Here are the commands to install the Open Match core in your cluster:

```bash
# Create a cluster role binding (if using gcloud on Linux or OSX)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user `gcloud config get-value account`

# Create a cluster role binding (if using gcloud on Windows)
for /F %i in ('gcloud config get-value account') do kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user %i

# Create a cluster role binding (if using minikube)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Install the core Open Match services.
kubectl apply -f https://open-match.dev/install/v{{< param release_version >}}/yaml/01-open-match-core.yaml --namespace open-match
```

After installing Open Match core services, here is the expected state for the pods for these services:

```
kubectl get -n open-match pod

Output:

NAME                                READY   STATUS              RESTARTS   AGE
om-backend-76d8d76c96-fmhmn         0/1     ContainerCreating   0          3m53s
om-frontend-57fc9f6b66-86hxj        0/1     ContainerCreating   0          3m53s
om-mmlogic-799d8549d4-5qpgx         0/1     ContainerCreating   0          3m53s
om-swaggerui-867d79b885-m9q6x       0/1     ContainerCreating   0          3m54s
om-synchronizer-7f48f84dfd-j8swx    0/1     ContainerCreating   0          3m54s
```

Open Match needs to be customized to your Matchmaker. This custom configuration is provided to the Open Match components via a ConfigMap (`om-configmap-override`). Thus, starting the core service pods waits on this config map being available.

If you are proceeding with the [Getting Started]({{< relref "../Getting Started/_index.md" >}}), or following a [Tutorial]({{< relref "../Tutorials/_index.md" >}}), these guides have steps to deploy their custom configuration and the Open Match is installed and ready to proceed.

If you are building a matchmaker outside of these guides, use the [Customization Guide]({{< relref "../Guides/custom.md" >}}) for steps to customize your Open Match installation.

## Delete Open Match

To delete Open Match and the corresponding sample components from this cluster, simply run:

```bash
kubectl delete psp,clusterrole,clusterrolebinding --selector=release=open-match
kubectl delete namespace open-match
```

## What Next?

Follow the [Getting Started]({{< ref "/docs/Getting Started" >}}) guide to see Open Match in action.
