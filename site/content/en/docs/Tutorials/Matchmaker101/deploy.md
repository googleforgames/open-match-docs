---
title: "Step4 - Deploy and Run"
linkTitle: "Step4 - Deploy and Run"
weight: 4
---

This step assumes that you have completed the Tutorial prerequisites and all prior steps and have the Game Frontend, Director and Match Function built and pushed to your configured image registry. If you have done all of this, lets proceed.

## Customizing Open Match Installation

Open Match Core although installed needs to be customized to be operational. The core customizations Open Match needs are the Match Function and Evaluator. We already built and pushed the Match Function in the previous step. The next step is to build and push an Evaluator.

### Build and Push Evaluator

Although using an Evaluator is out of scope for this document, we still need to set up a default Evaluator for Open Match. This tutorial comes packaged with a default Evaluator (see [TUTORIALROOT]/evaluator). Please run the below steps to build this evaluator and push its image to the configured image registry.

```
# Build the Evaluator image.
docker build -t $REGISTRY/mm101-tutorial-evaluator .

# Push the Evaluator image.
docker push $REGISTRY/mm101-tutorial-evaluator
```

### Deploy and Customize

Next step is to deploy the Match Function and the Evaluator to the same cluster as Open Match deployment but to a different namespace. The [TUTORIALROOT]/customization.yaml deploys these components as Services to a 'mm101-tutorial' namespace and adds a ConfigMap to Open Match namespace with the configuration of the Evaluator. Run the below command in the [TUTORIALROOT] path to apply this yaml:

```
sed "s|REGISTRY_PLACEHOLDER|$REGISTRY|g" customization.yaml | kubectl apply -f -
```

Please validate that all the Open Match pods and the customizations are in Running state before proceeding to the next step. Here is a command to do this:

```
# Check status for all Open Match Core pods
kubectl get -n open-match pod

# Check status for all Open Match customization pods
kubectl get -n mm101-tutorial pod
```

## Deploy Game Frontend, Director

Now that Open Match is setup and customized, it is ready to be used by the Game Frontend and Director.

The [TUTORIALROOT]/matchmaker.yaml deploys these components as single Pods to a 'mm101-tutorial' namespace. Run the below command in the [TUTORIALROOT] path to apply this yaml:

```
sed "s|REGISTRY_PLACEHOLDER|$REGISTRY|g" matchmaker.yaml | kubectl apply -f -
```

## Matchmaking ever after

All the components authored in this tutorial simply log their progress. Thus to see the progress, please check the logs for the below pods. Below are the commands and the expected output:

### Game Frontend

```
# Command
kubectl logs -n mmf101-tutorial pod/om-tutorial-frontend

# Output

```

### Director

```
# Command
kubectl logs -n mmf101-tutorial pod/om-tutorial-director

# Output

```

### Match Function

```
# Command
kubectl logs -n mmf101-tutorial pod/om-tutorial-matchfunction

# Output

```
