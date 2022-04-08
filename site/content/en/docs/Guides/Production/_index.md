---
title: "Production Best Practices"
linkTitle: "Production Best Practices"
weight: 8
description: >
  This guide covers the best practices to configure and deploy Open Match for production setups.
---

Here are a list of settings that may help you to improve Open Match's scalability, stability, and availability under production environments.

## Setup grpc.KeepaliveEnforcementPolicy for your MMF and evaluator server

We recommend adding the `grpc.WithKeepaliveParams` and `grpc.KeepaliveEnforcementPolicy` to your customizable components. The `Keepalive` settings will allow the client to ping the server after a duration of time to see if it is still alive. This could help the application to cleanup the invalid connections due to pod changes from Kubernetes' `HorizontalPodAutoscaler`. Here is a code snippet in go about these settings:

```go
import (
    "google.golang.org/grpc/keepalive"
    "google.golang.org/grpc"
)

...
// Client side settings
conn, err := grpc.Dial("some_address", grpc.WithKeepaliveParams(
    keepalive.ClientParameters{
        Time: 20 * time.Second,
        Timeout: 10* time.Second,
        PermitWithoutStream: true,
    })
)
...
// Server side settings
server := grpc.NewServer(
    grpc.KeepaliveEnforcementPolicy(
        keepalive.EnforcementPolicy{
            MinTime:             10 * time.Second,
            PermitWithoutStream: true,
        },
    ),
)
```

## Enable the client-side load balancer for your gRPC client
You need to add the a load balancer config to your gRPC client to enable Open Match's horizontal scaling feature. Here are the two steps to turn on this setting and make it compatible with Kubernetes' environment.

1. Changing the Kubernetes' services of your customized components into `HeadlessService`s, if any. e.g.:

    ```yaml
    # https://kubernetes.io/docs/concepts/services-networking/service/#headless-services
    spec:
      selector:
        app: mmf
        component: mmf
        release: open-match
      clusterIP: None
      type: ClusterIP
    ```

2. Using gRPC's DNS resolver when creating your clients and enable the client side load balancer:

    ```go
    import (
	    "google.golang.org/grpc/resolver"
    )

    func init() {
        // Using gRPC's DNS resolver to create clients.
        // This is a workaround for load balancing gRPC applications under k8s environments.
        // See https://kubernetes.io/blog/2018/11/07/grpc-load-balancing-on-kubernetes-without-tears/ for more details.
        // https://godoc.org/google.golang.org/grpc/resolver#SetDefaultScheme
        resolver.SetDefaultScheme("dns")
    }

    // Adding the client side load balancing config
    conn, err := grpc.Dial(
        "some_address",
        grpc.WithDefaultServiceConfig(`{"loadBalancingPolicy":"round_robin"}`),
    )
    ```

## Enable Redis Sentinel for high-availability and failover supports
[Redis Sentinel](https://redis.io/docs/manual/sentinel/) provides high-availability for Redis. By default, the sentinel is disabled to lower the resource requirements required by Open Match. If you prefer to turn on the sentinel, please override the value of `redis.sentinel.enabled` to true when installing Open Match via helm.

```bash
helm install my-release -n open-match open-match/open-match --set redis.sentinel.enabled=true
```

## Deploy Open Match based on `values-production.yaml` for production setup
Open Match project provides a recommended helm config file for production setups under `install/helm/open-match/values-production.yaml`. Note that this setup requires significant resources for running production workload.
```bash
helm install my-release -n open-match open-match/open-match -f values-production.yaml
```

## Use Envoy or other load balancing solution if you plan to connect to Open Match via an out-of-cluster client
The above load balancing solution is sufficient if you have both the client and the server deployment within the same cluster. However, some game architectures may require connecting to Open Match services from an out-of-cluster client. We recommend [Envoy](https://www.envoyproxy.io/) as a solution. Alternatives like Kubernetes Ingress or platform specific L7 Load Balancer can also work. 

## Use alternative to included Redis (Bitnami) image
Open Match comes included with a Redis image with a high-availability option. If your needs require a Redis offering with features unavailable with the included image, Open Match provides configs to bring your own Redis. First, you must disable the use of the included image by setting the `open-match-core.redis.enabled` param to `false`. To connect to your alternative Redis setup, provide the instance's hostname/IP address to the `open-match-core.redis.hostname`.

{{% alert title="Note: If Using Memorystore" color="info" %}}
To connect to [Memorystore](https://cloud.google.com/memorystore) from a GKE cluster it requires a VPC-native cluster. If you've created a cluster, you will have to re-create it as [VPC-native cluster using Alias-IPs](https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips). 
{{% /alert %}}

```bash
helm install open-match --create-namespace --namespace open-match open-match/open-match \
  --set open-match-customize.enabled=true \
  --set open-match-customize.evaluator.enabled=true \
  --set open-match-override.enabled=true \
  --set open-match-core.redis.enabled=false \
  --set open-match-core.redis.hostname= # Your redis server address
```