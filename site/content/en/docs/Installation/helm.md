---
title: "Install with Helm"
linkTitle: "Install with Helm"
weight: 2
description: >
  This guide covers how you can deploy Open Match on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.
---

## Prerequisites

- [Helm](https://docs.helm.sh/helm/) package manager, tested on version 3.12.3+
- [Kubernetes](https://kubernetes.io) cluster, tested on Kubernetes version 1.27+

## Install the Open Match helm chart

{{< alert title="Note" color="info">}}
If you don't have `Helm` installed, read the [Using Helm](https://helm.sh/docs/intro/) documentation to get started. The Open Match helm chart only installs the core services by default, please [override default helm configs]({{< relref "../Installation/helm.md#configuration" >}}) if you need to install telemetry support.
{{< /alert >}}

Open Match has various deployment options. Depending on your needs you can choose one of the available deployment options below:

  - [Install Open Match using stable Helm repository]({{< relref "../Installation/helm.md#install-open-match-using-stable-helm-repository" >}})
  - [Install Open Match using a specific version]({{< relref "../Installation/helm.md#install-open-match-using-a-specific-version" >}})
  - [Install Open Match with the Default Evaluator]({{< relref "../Installation/helm.md#install-open-match-with-the-default-evaluator" >}})

## Install Open Match using stable Helm repository
To install the chart with the release name `open-match` using our stable helm repository:

```bash
helm repo add open-match https://open-match.dev/chart/stable
helm install open-match --create-namespace --namespace open-match open-match/open-match
```

## Install Open Match using a specific version
Helm install the latest stable version of Open Match `v{{< param release_version >}}` by default. To view the available helm chart versions and install a specific Open Match version:

```bash
# View available Open Match helm chart versions
helm search repo --versions open-match/open-match
# Install a specific Open Match helm chart version
helm install open-match --create-namespace --namespace open-match open-match/open-match --version=CHART_VERSION
```

{{% alert title="Note" color="info" %}}
Open Match needs to be customized to run as a Matchmaker.
This custom configuration is provided to the Open Match components via a ConfigMap
(<code>om-configmap-override</code>).

Thus, starting the core service pods will remain in <code>ContainerCreating</code> until this config map is available.
{{% /alert %}}

## Install Open Match with the Default Evaluator

Run the command below to install the default Evaluator and configure Open Match to use it.

```bash
# Install the Default Evaluator
# Install ConfigMap `om-configmap-override`, this ConfigMap configures Open Match to talk to the Default Evaluator 
helm install open-match --create-namespace --namespace open-match open-match/open-match \
  --set open-match-customize.enabled=true \
  --set open-match-customize.evaluator.enabled=true \
  --set open-match-override.enabled=true 
```

To install Open Match with the Default Evaluator and another version of Open Match, you can run this command below

```bash
# Install the Default Evaluator with specific version of Open Match
# Install ConfigMap `om-configmap-override`, this ConfigMap configures Open Match to talk to the Default Evaluator 
helm install open-match --create-namespace --namespace open-match open-match/open-match --version=CHART_VERSION \
  --set open-match-customize.enabled=true \
  --set open-match-customize.evaluator.enabled=true \
  --set open-match-override.enabled=true 
```


## Uninstalling the Chart

To uninstall/delete the `open-match` deployment:

```bash
helm uninstall -n open-match open-match && \ 
kubectl delete namespace open-match
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install --name open-match --namespace open-match open-match/open-match \
  --set open-match-telemetry.enabled=true 
```

The above command sets the namespace where Open Match is deployed to `open-match`, and turns on the telemetry exporters along with installing Open Match core services.

The following tables lists the configurable parameters of the Open Match chart and their default values. Refer to the [Values.yaml] (https://github.com/googleforgames/open-match/blob/main/install/helm/open-match/values.yaml) file to customize your configs.

| Parameter                                           | Description                                                                                     | Default                |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ---------------------- |
| `query.portType` | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the QueryService | `ClusterIP` |
| `query.replicas` | Defines the number of pod replicas for QueryService's Kubernetes deployment | `3` |
| `frontend.portType` | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the FrontendService | `ClusterIP` |
| `frontend.replicas` | Defines the number of pod replicas for FrontendService's Kubernetes deployment | `3` |
| `backend.portType` | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the BackendService | `ClusterIP` |
| `backend.replicas` | Defines the number of pod replicas for BackendService's Kubernetes deployment | `3` |
| `image.pullPolicy` | Global `imagePullPolicy` for all Open Match service deployments | `Always` |
| `image.tag` | Global Docker image tag for all Open Match service deployments | `{{< param release_version >}}` |
| `open-match-core.enabled` | Turn on/off the installation of Open Match core services | `true` |
| `open-match-core.registrationInterval` | Duration of registration window for evaluation/synchronization cycle. | `250ms` |
| `open-match-core.proposalCollectionInterval` | Length of time after match function has started before it will be canceled. | `20s` |
| `open-match-core.pendingReleaseTimeout` | Defines the time before a ticket returns to the pool after it was fetched. | `1m` |
| `open-match-core.assignedDeleteTimeout` | Time after a ticket has been assigned before it is automatically deleted. | `10m` |
| `open-match-core.backfillLockTimeout` | Defines the time of keeping a lock on a single backfill. | `1m` |
| `open-match-override.enabled` | Turn on/off the installation of `om-override-configmap` | `false` |
| `open-match-telemetry.enabled` | Turn on/off the installation of Open Match telemetry services | `false` |
| `open-match-scale.enabled` | Turn on/off the installation of Open Match scale testing setups | `false` |
| `global.kubernetes.serviceAccount` | Service account name for the Open Match core services | `open-match-unprivileged-service` |
| `global.kubernetes.service.portType` |  Overrides the ServiceTypes for all Open Match core services  | `` |
| `global.gcpProjectId` | Overrides the default gcp project id for use with stackdriver | `replace_with_your_project_id` |
| `global.tls.enabled` | Turn on/off TLS encryption for all Open Match traffics | `false` |
| `global.tls.server.mountPath` | The VolumeMount path for TLS server | `/app/secrets/tls/server`  |
| `global.tls.rootca.mountPath`  | The VolumeMount path for TLS CA | `/app/secrets/tls/rootca`  |
| `global.logging.rpc.enabled`  | Turn on/off RPC payload logging for all Open Match core services | `false`  |
| `global.telemetry.zpages.enabled` | Turn on/off Open Match zPages instrument. | `true`  |
| `global.telemetry.prometheus.enabled` | Turn on/off Open Match Prometheus exporter. Also install Prometheus if `open-match-telemetry.enabled` is set to true | `false` |
| `global.telemetry.prometheus.endpoint` | Bind the Prometheus exporters to the specified endpoint handler, also configures the `prometheus.io/path` k8s scraping annotations  | `/metrics` |
| `global.telemetry.prometheus.serviceDiscovery` | If Prometheus is enabled and `serviceDiscover: true`, add the Prometheus scraping annotations to each Pod of the Open Match core services | `true` |
| `global.telemetry.stackdriverMetrics.enabled`  | Turn on/off Open Match Stackdriver Metrics exporter.  | `false`  |
| `global.telemetry.stackdriverMetrics.prefix`  | MetricPrefix overrides the prefix of a Stackdriver metric display names to help you better identifies your metrics  | `open_match`  |
| `global.telemetry.grafana.enabled` | Turn on/off Open Match Grafana exporter. Also install Grafana if `open-match-telemetry.enabled` is set to true | `false`  |
| `global.telemetry.reportingPeriod`  | Overrides the reporting periods of Open Match telemetry exporters | `1m` |
| `open-match-telemetry.grafana` | Inherits the values from [Grafana helm chart](https://github.com/helm/charts/tree/master/stable/grafana)  |  |
| `open-match-telemetry.prometheus`  | Inherits the values from [Prometheus helm chart](https://github.com/helm/charts/tree/master/stable/prometheus) |  |
| `redis` | Inherits the values from the [Bitnami Redis Helm chart](https://github.com/bitnami/charts/tree/master/bitnami/redis) |  |

## What's Next

Follow the [Getting Started]({{< ref "/docs/Getting Started" >}}) guide to see Open Match in action.
