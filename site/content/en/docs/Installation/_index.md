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

# Install the core Open Match services.
kubectl apply -f https://open-match.dev/install/v{{< param release_version >}}/yaml/01-open-match-core.yaml --namespace open-match
```

The `01-open-match-core.yaml` file contains:

  - A Redis deployment as Open Match's state storage system.
  - ServiceAccounts, Roles and RoleBindings to define Open Match deployments' IAMs. 
  - Several Services for Open Match endpoints. 
  - HorizontalAutoScalars to auto-scale Open Match based on pods' average CPU utilization. 

## Install ConfigMap `om-configmap-override`
If you wait a minute then do `kubectl get -n open-match pod`, you should be able to see something similar below:
```
yufanfei@yufanfei:~/go/src/open-match.dev/open-match$ kubectl get -n open-match pod
NAME                                READY   STATUS              RESTARTS   AGE
om-backend-76d8d76c96-fmhmn         0/1     ContainerCreating   0          3m53s
om-frontend-57fc9f6b66-86hxj        0/1     ContainerCreating   0          3m53s
om-mmlogic-799d8549d4-5qpgx         0/1     ContainerCreating   0          3m53s
om-swaggerui-867d79b885-m9q6x       0/1     ContainerCreating   0          3m54s
om-synchronizer-7f48f84dfd-j8swx    0/1     ContainerCreating   0          3m54s
```

Open Match as a match making framework requires a configmap `om-configmap-override` that mounts a `matchmaker_config_override.yaml` file to components before all components will start. If you are proceeding to [Getting Started]({{< relref "../Getting Started/_index.md" >}}), or following a [Tutorial]({{< relref "../Tutorials/_index.md" >}}), it will contain the commands to apply the required configuration.

For writing your own, a yaml which is useful as a starting point for further edits is available at [here](https://open-match.dev/install/v{{< param release_version >}}/yaml/06-open-match-override-configmap.yaml). Try running `kubectl apply -f https://open-match.dev/install/v{{< param release_version >}}/yaml/06-open-match-override-configmap.yaml --namespace open-match`, wait for a few seconds, and you should be able to see Open Match start up as expected.

The configmap contains two important configurations to initialize Open Match:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: om-configmap-override
  namespace: open-match
data:
  matchmaker_config_override.yaml: |-
    # Specifies the hostname and port of the evaluator that Open Match should talk to.
    api:
      evaluator:
        hostname: "om-evaluator"
        grpcport: "50508"
        httpport: "51508"
    # Specifies if we should turn on/off the synchronizer.
    #   - If on, specifies the registrationInterval and proposalCollectionInterval in milliseconds.
    synchronizer:
      enabled: true
      registrationIntervalMs: 3000ms
      proposalCollectionIntervalMs: 2000ms
```

To configure Open Match outside of a tutorial, download this file, prepare your edits, and run `kubectl apply -f <filename_here>`.

## Delete Open Match

To delete Open Match and the corresponding sample components from this cluster, simply run:

```bash
kubectl delete psp,clusterrole,clusterrolebinding --selector=release=open-match
kubectl delete namespace open-match
```

## What Next?

Use Open Match as a match maker by installing a match making function and evaluator:

 - Follow the [Getting Started]({{< ref "/docs/Getting Started" >}}) guide to see Open Match in action.