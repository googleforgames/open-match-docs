---
title: "Customize Core Open Match"
linkTitle: "Customize Core Open Match"
weight: 6
description: >
  This guide covers how to customize your Open Match deployment.
---

Open Match needs to be customized to your Matchmaker. This custom configuration is provided to the Open Match components via a ConfigMap (`om-configmap-override`). Thus, starting the core service pods waits on this config map being available.

To customize an Open Match installation, we need to provide a ConfigMap with the sample configuration. Here is a sample YAML that contains the customization ConfigMap:

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

To configure Open Match with your custom config, create a new YAML file with this content, make your edits and run this command:

```bash
kubectl apply -f <filename_here>
```

The [Evaluator Guide]({{< relref "../Evaluator/_index.md" >}}) gives an overview of Synchronization, Evaluation and all the related configuration.

## Configurations
The following tables lists the configurable parameters of the Open Match override configmap and their default values.
### Telemetry
| Supported Backend | Parameter | Description | Default |
|-----              |-----      |-----        |-----    |
| zPages            |           | Serves HTTP server runtime profiling data in the format expected by the [pprof](https://pkg.go.dev/net/http/pprof) visualization tool under `/debug/pprof` path |         |
|                   | `telemetry.zpages.enabled` |  Enable zPages support on Open Match core services |  `true`   |
| [Jaeger](https://www.jaegertracing.io/)            | | An open source, end-to-end distributed tracing. | |
|             | `telemetry.jaeger.enabled` | Enable Jaeger exporter on Open Match core services | `false` |
|| `telemetry.jaeger.samplerFraction` | Setup Jaeger exporter to randomly sample a trace with this probability. For example, with `samplerFraction: 0.5` approximately 1 out of 2 traces will be sampled | `1` |
|             | `telemetry.jaeger.agentEndpoint` | AgentEndpoint instructs exporter to send spans to jaeger-agent at this address. | `open-match-jaeger-agent:6831` |
|             | `telemetry.jaeger.collectorEndpoint` | CollectorEndpoint is the full url to the Jaeger HTTP Thrift collector. | `open-match-jaeger-collector:14268/api/traces` |
| [Prometheus](https://prometheus.io/)        |           |             |         |
|             | `telemetry.prometheus.enabled` | Enable Prometheus exporter on Open Match core services | `false` |
|| `telemetry.prometheus.endpoint` | Bind the Prometheus exporters to the specified endpoint handler, also configures the `prometheus.io/path` k8s scraping annotations  | `/metrics` |
|             | `telemetry.prometheus.serviceDiscovery` | If Prometheus is enabled and `serviceDiscover: true`, add the Prometheus scraping annotations to each Pod of the Open Match core services | `true` |
| [Stackdriver](https://cloud.google.com/stackdriver/)       |           |             |         |
|             | `telemetry.stackdriverMetrics.enabled` | Enable Stackdriver Metric exporter on Open Match core services | `false` |
|| `telemetry.stackdriverMetrics.prefix` | MetricPrefix overrides the prefix of a Stackdriver metric display names to help you better identifies your metrics | `open_match` |
| [Grafana](https://grafana.com)           |           |             |         |
|             | `telemetry.grafana.enabled` | Enable Grafana exporter on Open Match core services | `false` |
