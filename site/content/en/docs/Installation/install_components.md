---
title: "Install Example Components"
linkTitle: "Install Example Components"
weight: 3
description: >
  Steps to install sample Match Function, Evaluator in a Kubernetes cluster.
---

Open Match framework requires the user to author a custom Match Function and an Evaluator that are invoked to create matches. These functions should be implemented as gRPC / HTTP services. The Evaluator service endpoint should be configured in Open Match configuration. The Match Function service endpoint can be specified in each FetchMatch call from the Director.

To get started, you can deploy the example Match Function and Evaluator in the same Kubernetes cluster as Open Match using the following command:

```bash
# Install the example Match Function and Evaluator.
kubectl apply -f https://open-match.dev/install/v{{ .Site.Params.release_version }}/yaml/install-demo.yaml --namespace open-match
```
