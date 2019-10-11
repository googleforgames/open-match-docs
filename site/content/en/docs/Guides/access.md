---
title: "Access Open Match under different cluster settings"
linkTitle: "Access Open Match under different cluster settings"
weight: 1
description: >
  This guide covers how you can access Open Match using an in-cluster or out-of-cluster client.
---

You can talk to Open Match either via an in-cluster or out-of-cluster service client.

## Access Open Match via an out-of-cluster service client
To access Open Match via an out-of-cluster client, the first step is to expose a service onto an external IP address. We recommend exposing your service using Kubernetes Load Balancers in production for a public IP if needed. Open Match provides two different ways to configure your service with Load Balancer. The following provide examples to expose the `backend` service with code examples in Go.

### 1 Exposing the Service using Cloud Load Balancer
#### a. Modify the install.yaml files of the latest release
```bash
# Download the latest install.yaml file
wget http://open-match.dev/install/v0.7.0/yaml/01-open-match-core.yaml
```
Find and modify the `spec.type` fields of the Service that you want to expose to `LoadBalancer`.

```yaml
kind: Service
apiVersion: v1
metadata:
  name: om-backend
  ...
spec:
  type: LoadBalancer
```
Save the changes and deploy Open Match
```bash
kubectl apply -f ./install.yaml
```
#### b. Configure Load Balancer using the Helm chart

> If you don't have `Helm` installed locally, or `Tiller` installed in your Kubernetes cluster, read the [Using Helm](https://docs.helm.sh/using_helm/) documentation to get started.

Open Match's helm chart lives under the `install/helm/open-match` folder of the root directory. To install Open Match with Load Balancer enabled:
```bash
# Change directoy to the helm chart folder
kubectl create clusterrolebinding default-view-open-match --clusterrole=view --serviceaccount=open-match:default
# Expose Service onto a public IP using helm cli
helm upgrade [YOUR_HELM_RELEASE_NAME] --install --wait --debug -n open-match \
    --set global.image.tag=0.6.0 \
    --set global.gcpProjectId=[YOUR_GCPPROJECT_ID] \
    --set backend.portType=LoadBalancer
```

### 2. Wait for the external IP address
```bash
$ kubectl get services -n open-match om-backend
# The output is similar to this
# Note: If the external IP address is shown as <pending>, wait for a minute and enter the same command again.
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)               AGE
om-backend   LoadBalancer   10.0.4.7     104.198.205.71        50505/TCP,51505/TCP   3h2m
```
### 3. Talk to Open Match using an out-of-cluster client with the external IP
```go
// Create a gRPC backend client
conn, err := grpc.Dial("<external-ip>:50505", grpc.WithInsecure())
...
beClient := pb.NewBackendClient(conn)
...
```
> Note that if you want to obtain the external IP programatically, look at the [out of cluster configuration](https://github.com/kubernetes/client-go/tree/master/examples/out-of-cluster-client-configuration)
example from the Kubernetes client and use the code below for your reference.

```go
import (
    ...
    "errors"

    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    "k8s.io/client-go/kubernetes"
)

...
// Get the Open Match backend service object using the kubernetes go client
svc, err := kubeClient.CoreV1().Services("open-match").Get("om-backend", metav1.GetOptions{})
if err != nil {
    panic(err)
}

if len(svc.Status.LoadBalancer.Ingress) == 0 {
    panic(errors.New(fmt.Sprintf("service: %s does not have ingress exposed.\n", svcName)))
}

externalIP := svc.Status.LoadBalancer.Ingress[0].IP
```

## Access Open Match via an in-cluster service client
To access Open Match with a service client deployed in the same namespace as Open Match
```go
// Create a gRPC backend client
conn, err := grpc.Dial("om-backend:50505", grpc.WithInsecure())
...
beClient := pb.NewBackendClient(conn)
...
```

To access Open Match with a service client deployed in other namespaces than Open Match
```go
// Create a gRPC backend client
// [OPEN-MATCH-NAMESPACE] is usually open-match if you install Open Match via the official yaml files.
conn, err := grpc.Dial("om-backend.[OPEN-MATCH-NAMESPACE]:50505", grpc.WithInsecure())
...
beClient := pb.NewBackendClient(conn)
...
```

## Next Steps
- Learn how to [interact with Open Match using gRPC and HTTP APIs]({{< relref "./api.md" >}}).
