---
title: "Grafana: gRPC"
linkTitle: "Grafana: gRPC"
weight: 2
description:
  What metrics are included in the gRPC dashboard?
---

Here is a [raintank snapshot](https://snapshot.raintank.io/dashboard/snapshot/0IpGHqbDsP3CXdZi4E9lo454RthSMDVi) to what you will see after navigating to the gRPC dashboard.

| Metric Name                                                    | Description                                                                                   |
| ---------------------------------------------------            | ----------------------------------------------------------------------------------------------| 
| `Client Request Rate`                                          | Average gRPC client side request per second by Open Match API methods                         | 
| `Server Request Rate`                                          | Average gRPC server side request per second by Open Match API methods                         | 
| `gRPC Error Rate`                                              | Ratio of gRPC calls that returned an non-OK status code by Open Match methods                 | 
| `Network IO per second`                                        | Total network I/O rate per second                                                             |  
| `Bytes Sent per Call: openmatch.{Component}/{MethodName}`      | Average bytes sent per call by quantile                                                       |  
| `Bytes Received per Call: openmatch.{Component}/{MethodName}`  | Average bytes received per call by quantile                                                   |  
| `Client RTT: openmatch.{Component}/{MethodName}`               | Average roundtrip latency by quantile                                                         |  