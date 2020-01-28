---
title: "Grafana: gRPC"
linkTitle: "Grafana: gRPC"
weight: 2
description:
  What metrics are included in the gRPC dashboard?
---

Here is a [raintank snapshot](https://snapshot.raintank.io/dashboard/snapshot/0IpGHqbDsP3CXdZi4E9lo454RthSMDVi) to what you will see after navigating to the gRPC dashboard.

| Metric Name                                           | Description                                                                                     |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------- | 
| `Client Request Rate`                                | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the QueryService                        | 
| `Server Request Rate`                           | Defines the number of pod replicas for QueryService's Kubernetes deployment                                         | 
| `gRPC Error Rate`                         | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the FrontendService                        | 
| `Network IO per second`                    | Defines the number of pod replicas for FrontendService's Kubernetes deployment                                         |  
| `Bytes Sent per Call: openmatch.{Component}/{MethodName}`                        | Defines Kubernetes [ServiceTypes](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for the BackendService                        |  
| `Bytes Received per Call: openmatch.{Component}/{MethodName}`                          | Defines the number of pod replicas for BackendService's Kubernetes deployment                                                          |  
| `Client RTT: openmatch.{Component}/{MethodName}`                               | Global `imagePullPolicy` for all Open Match service deployments |  