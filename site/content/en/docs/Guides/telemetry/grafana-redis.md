---
title: "Grafana: Redis"
linkTitle: "Grafana: Redis"
weight: 2
description:
  What metrics are included in the Redis dashboard?
---

Here is a [raintank snapshot](https://snapshot.raintank.io/dashboard/snapshot/GkJjEmiHVzgJCX3MoeR8p9BnL4K4vfYE) to what you will see after navigating to the Redis dashboard.

| Metric Name                                         | Description                                                                                     |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------- | 
| `Uptime`                                            | Redis uptime                                                                                    |  
| `Memory Usage`                                      | Redis memory usage in percentage                                                                | 
| `Total DB Items`                                    | Total Redis DB keys in Redis master                                                             | 
| `CPU Usage Percentage of Limit`                     | Current CPU usage to CPU resource limit ratio per pod (%)                                       |  
| `Total Memory Usage`                                | Current and maximum Redis memory usage by Redis instances                                       | 
| `Hits / Misses per Sec`                             | Cache hits/misses per second by Redis instances                                                 | 
| `Commands Executed / sec`                           | Executed Redis commands per second by Redis instances (excludes Redis sync calls)               |  
| `Network I/O`                                       | Total network I/O per second by Redis instances                                                 | 
| `Clients`                                           | Number of currently connected Redis clients by Redis instances                                  | 
