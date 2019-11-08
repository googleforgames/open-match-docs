---
title: "Customize core Open Match"
linkTitle: "Customize core Open Match"
weight: 5
description: >
  This guide covers how to customize your Open Match deployment.
---

Open Match needs to be customized to your Matchmaker. This custom configuration is provided to the Open Match components via a ConfigMap (`om-configmap-override`). Thus, starting the core service pods waits on this config map being available.

To customize an Open Match installation, we need to provide a ConfigMap with the sample configuration. Here is a sample YAML that contains the customization ConfigMap:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: om-configmap-override
  namespace: open-match
data:
  matchmaker_config_override.yaml: |-
    # Specifies the hostname and port of the evaluator that Open Match should talk to.
    api:
      evaluator:
        hostname: "om-evaluator"
        grpcport: "50508"
        httpport: "51508"
    # Specifies if we should turn on/off the synchronizer.
    #   - If on, specifies the registrationInterval and proposalCollectionInterval in milliseconds.
    synchronizer:
      enabled: true
      registrationIntervalMs: 3000ms
      proposalCollectionIntervalMs: 2000ms
```

To configure Open Match with your custom config, create a new YAML file with this content, make your edits and run this command:

```
kubectl apply -f <filename_here>
```

The [Evaluator Guide]({{< relref "../Guides/evaluator.md" >}}) gives an overview of Synchronization, Evaluation and all the related configuration.
