---
title: "Telemetry"
linkTitle: "Telemetry"
weight: 3
description: >
  This guide covers how you can monitor your Open Match deployment.
---

Open Match is instrumented with [OpenCensus](https://opencensus.io/),
a telemetry library. The metrics that Open Match provides gives you
insight into the performance and health of your Open Match cluster.

## Dashboard

The easiest way to view the health of your Open Match cluster is to browse
the Grafana dashboards. Open Match ships with a few dashboards like RPC
traffic and database transaction rates.

To access Grafana you'll need to `kubectl port-forward` port 3000 from your
Kubernetes cluster.

```bash
# Port forward Grafana to your machine, http://localhost:3000.
kubectl port-forward --namespace open-match service/open-match-grafana 3000:3000
```

Next visit http://localhost:3000 in your browser with
Username: `admin` Password: `openmatch`.

Once you're in the Home Dashboard try selecting gRPC. You'll see a page like
this:

![Grafana gRPC Dashboard](../../../images/guides/telemetry-grafana-grpc.png)

## Prometheus

Prometheus is the server for capturing and analyzing metrics. You can use it
to draft metric queries that can be used to debug a service in the moment or
tweak a query that can be used in a Grafana dashboard.

To access Prometheus you'll need to `kubectl port-forward` port 9090 from your
Kubernetes cluster.

```bash
# Port forward Prometheus to your machine, http://localhost:9090.
kubectl port-forward --namespace open-match service/open-match-prometheus-server 9090:80
```

Next visit http://localhost:9090 in your browser.

Let's try an example query, `sum(rate(backend_tickets_assigned[5m]))`

This returns the number of tickets assigned by the backend server over a 5
minute sliding window period.

![Prometheus](../../../images/guides/telemetry-prometheus.png)

Let's break down each part of the query.

 * `sum()` - This will take the sum over each individual rate produced by
   each server (there may be more than 1 backend server).
 * `rate(metric_name[5m])` - Take the rate of a particular metric.
   Since a rate is not instanteous we must use a sliding window where we take
   *metric_name[now]* - *metric_name[5m ago]* at every time point. The
   smaller the time window the more exact but choppy the data appears.

You can learn how to query your metrics from the
[Prometheus Query Basics](https://prometheus.io/docs/prometheus/latest/querying/basics/)
tutorial.

## Configuration

You can configure where and what telemetry you want to emit from your Open Match
deployment. At this type we support:

 * Prometheus
 * Stackdriver

Preliminary support for:

 * OpenZipkin
 * Jaeger
 * OpenCensus Agent

Below is an example of `matchmaker_config.yaml` section to configure your
telemetry:

```yaml
telemetry:
  jaeger:
    agentEndpoint: 'open-match-jaeger-agent:6831'
    collectorEndpoint: 'http://open-match-jaeger-collector:14268/api/traces'
    enable: 'true'
  prometheus:
    enable: 'true'
    endpoint: '/metrics'
  reportingPeriod: '5s'
  stackdriver:
    enable: 'true'
    gcpProjectId: 'replace_with_your_project_id'
    metricPrefix: 'open_match'
  zipkin:
    enable: 'true'
    endpoint: '/zipkin'
    reporterEndpoint: 'zipkin'
```
