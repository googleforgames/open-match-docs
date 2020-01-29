---
title: "Grafana: Go Processes"
linkTitle: "Grafana: Go Processes"
weight: 2
description:
  What metrics are included in the Go Processes dashboard?
---

Here is a [raintank snapshot](https://snapshot.raintank.io/dashboard/snapshot/EwEoNzsCfz4z7ZuHH6gYavWJ3TQP48oJ) to what you will see after navigating to the Go Processes dashboard.

| Metric Name                          | Description                                                                                                     |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------- |
| `CPU Usage Limit Percentage`         | Current CPU usage to CPU resource limit ratio per pod (%)                                                       |
| `Go Routines`                        | Average number of Go routines by deployment                                                                     |
| `Process Memory`                     | Average number of resident/virtual memory by deployment                                                         |
| `Process Memory Derivative`          | Derivative of the average number of resident/virtual memory by deployment                                       |
| `Go Memstats`                        | Average number of `bytes allocated`/`allocation rate`/`stack inuse`/`heap inuse` by deployment                  | 
| `Go Memstats Derivative`             | Derivative of the average number of `bytes allocated`/`allocation rate`/`stack inuse`/`heap inuse` by deployment|
| `Open File Descriptors`              | Average number of currently opened file descriptors by deployment                                               |
| `Open File Descriptors Derivative`   | Derivative of the average number of currently opened file descriptors by deployment                             |
| `GC Duration Quantiles`              | Average number of garbage collection time by deployment and quantile                                            |
