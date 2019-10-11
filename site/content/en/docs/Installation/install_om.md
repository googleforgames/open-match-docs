---
title: "Install Open Match"
linkTitle: "Install Open Match"
weight: 2
description: >
  Steps to install Open Match in a kubernetes cluster.
---

Open Match comprises of a set of services that enable core functionality such as Ticket management, filtering, Match generation etc. It also includes a
state storage that Open Match uses to persist state needed for its functioning.

The simplest way to install Open Match is to use the static yaml files for the latest release.
This installs Open Match with the default configuration.

```bash
# Create a cluster role binding (if using gcloud on Linux or OSX)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user `gcloud config get-value account`

# Create a cluster role binding (if using gcloud on Windows)
for /F %i in ('gcloud config get-value account') do kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user %i

# Create a cluster role binding (if using minikube)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Create a namespace to place all the Open Match components in.
kubectl create namespace open-match

# Install the core Open Match services.
kubectl apply -f https://open-match.dev/install/v{{< param release_version >}}/yaml/01-open-match-core.yaml --namespace open-match
```
