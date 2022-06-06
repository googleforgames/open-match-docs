---
title: "Install with YAML"
linkTitle: "Install with YAML"
weight: 1
description: >
  This guide covers how you can deploy Open Match on a [Kubernetes](http://kubernetes.io) cluster using static Kubernetes YAML files.
---

## Prerequisites

- [Kubernetes](https://kubernetes.io) cluster, tested on Kubernetes version 1.13+

## Install Core Open Match

Open Match comprises of a set of core services hosted in a Kubernetes cluster. The simplest way to install Open Match core is to use the `01-open-match-core.yaml` for the latest release. This installs Open Match with the default configuration.

The `01-open-match-core.yaml` contains:

* Core Open Match service deployments.
* A Redis deployment as Open Match's state storage system.
* ServiceAccounts, Roles, and RoleBindings to define Open Match deployments' IAMs.
* HorizontalAutoScalars to auto-scale Open Match based on pods' average CPU utilization.

Here is the command to install the Open Match core in your cluster:

```bash
# Install the core Open Match services.
kubectl apply --namespace open-match \
  -f https://open-match.dev/install/v{{< param release_version >}}/yaml/01-open-match-core.yaml
```
{{% alert title="Note" color="info" %}}
The flag `--namespace open-match` is __**Required**__. Open Match may not work as expected without this flag.
{{% /alert %}}

After installing Open Match core services, here is the expected state for the pods for these services:

```bash
kubectl get -n open-match pod
```
```
Output:

NAME                                READY   STATUS              RESTARTS   AGE
om-backend-76d8d76c96-fmhmn         0/1     ContainerCreating   0          3m53s
om-frontend-57fc9f6b66-86hxj        0/1     ContainerCreating   0          3m53s
om-query-799d8549d4-5qpgx           0/1     ContainerCreating   0          3m53s
om-swaggerui-867d79b885-m9q6x       0/1     ContainerCreating   0          3m54s
om-synchronizer-7f48f84dfd-j8swx    0/1     ContainerCreating   0          3m54s
```

{{% alert title="Note" color="info" %}}
Open Match needs to be customized to run as a Matchmaker.
This custom configuration is provided to the Open Match components via a ConfigMap
(<code>om-configmap-override</code>).

Thus, starting the core service pods will remain in <code>ContainerCreating</code> until this config map is available.
{{% /alert %}}

- If you are proceeding with the [Getting Started]({{< relref "../Getting Started/_index.md" >}}), or following the [Tutorials]({{< relref "../Tutorials/_index.md" >}}), proceed with this guide to [install the default Evaluator]({{< ref "#install-the-default-evaluator" >}}) and configure Open Match to use it.

- If you finished reading the tutorials and are building your own custom matchmaker and need to deploy a custom evaluator, then skip the next step and instead use the [Customization Guide]({{< relref "../Guides/Custom/_index.md" >}}) for steps to customize your Open Match installation.

## Install the Default Evaluator

Run the below command to install the default Evaluator in the open-match namespace and to configure Open Match to use it.

```bash
kubectl apply --namespace open-match \
  -f https://open-match.dev/install/v{{< param release_version >}}/yaml/06-open-match-override-configmap.yaml \
  -f https://open-match.dev/install/v{{< param release_version >}}/yaml/07-open-match-default-evaluator.yaml
```

## Delete Open Match

To delete Open Match and the corresponding sample components from this cluster, simply run:

```bash
kubectl delete psp,clusterrole,clusterrolebinding --selector=release=open-match
kubectl delete namespace open-match
```

## What's Next

Follow the [Getting Started]({{< ref "/docs/Getting Started" >}}) guide to see Open Match in action.
