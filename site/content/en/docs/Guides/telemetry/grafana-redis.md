---
title: "Grafana: Redis"
linkTitle: "Grafana: Redis"
weight: 2
description:
  What metrics are included in the Redis dashboard?
---

Here is a [raintank snapshot](https://snapshot.raintank.io/dashboard/snapshot/GkJjEmiHVzgJCX3MoeR8p9BnL4K4vfYE) to what you will see after navigating to the Redis dashboard.

| Metric Name                                           | Description                                                                                     |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------- | 
| `Uptime`                                | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the QueryService                        |  
| `Memory Usage`                           | Defines the number of pod replicas for QueryService's Kubernetes deployment                                         | 
| `Total DB Items`                         | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the FrontendService                        | 
| `CPU Usage Percentage of Limit`                    | Defines the number of pod replicas for FrontendService's Kubernetes deployment                                         |  
| `Total Memory Usage`                        | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the BackendService                        | 
| `Hits / Misses per Sec`                          | Defines the number of pod replicas for BackendService's Kubernetes deployment                                                          | 
| `Commands Executed / sec`                               | Global `imagePullPolicy` for all Open Match service deployments |  
| `Network I/O`                       | Global Docker image tag for all Open Match service deployments | 
| `Clients`         | Turn on/off the installation of Open Match core services                        | 
