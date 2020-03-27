---
title: "Tutorials"
linkTitle: "Tutorials"
weight: 5
description: >
  Open Match Tutorials
---

Checkout the [release branch](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials) for the corresponding tutorials.
{{% alert title="Note" color="info" %}}
For Minikube users, please run the command below to instruct Minikube to use local Docker images.
```bash
# Instructs Minikube to use local images
# https://kubernetes.io/docs/setup/learning-environment/minikube/#use-local-images-by-re-using-the-docker-daemon
eval $(minikube docker-env)
```
{{% /alert %}}