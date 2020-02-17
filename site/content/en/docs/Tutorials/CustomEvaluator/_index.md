---
title: "Build a custom Evaluator"
linkTitle: "Build a custom Evaluator"
weight: 4
description: >
  A tutorial on how to build a custom Evaluator and configure Open Match to use it.
---

## Objectives

The tutorial aims to explain how to :

- Build your custom Evaluator
- Deploy, Run your custom Evaluator and configure Open Match core to use it

## Prerequisites

### Default Evaluator tutorial

It is highly recommended that you run the [default Evaluator tutorial]({{< relref "../DefaultEvaluator/_index.md" >}}) as it introduces the core concepts that this tutorial builds upon. After completion, please remember to [cleanup the default Evaluator tutorial]({{< relref "../DefaultEvaluator/_index.md#cleanup" >}}) before proceeding.

{{% alert title="Note" color="info" %}}
Given that all the other tutorials so far use the default Evaluator, the chances are, you already have the default Evaluator deployed in the open-match namespace. That is OK as at a later point, you will simply configure Open Match to point to your custom Evaluator in this tutorial's namespace.

However, given that the default Evaluator in the open-match namespace will not be used for this tutorial, you may choose to delete it. Alternatively, you may delete the open-match namespace and [Install Open Match Core]({{< relref "../../Installation/yaml.md#install-core-open-match" >}}) **without** installing the default Evaluator.
{{% /alert %}}

### Set up Image Registry

Please setup an Image registry(such as [Docker Hub](https://hub.docker.com/) or [GC Container Registry](https://cloud.google.com/container-registry/)) to store the Docker Images used in this tutorial. Once you have set this up, here are the instructions to set up a shell variable that points to your registry:

```bash
REGISTRY=[YOUR_REGISTRY_URL]
```

If using GKE, you can populate the image registry using the command below:

```bash
REGISTRY=gcr.io/$(gcloud config list --format 'value(core.project)')
```

### Get the tutorial template

Make a local copy of the [tutorials Folder](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/custom_evaluator). Use `tutorials/custom_evaluator` as a working copy for all the instructions in this tutorial.

For convenience, set the following variable:

```bash
TUTORIALROOT=[SRCROOT]/tutorials/custom_evaluator
```

{{% alert title="Note" color="info" %}}
This tutorial only focuses on building the custom Evaluator and so the working copy of Matchmaker components already has the changes to Frontend, Director that were made to work with the default Evaluator.
{{% /alert %}}

### Create the tutorial namespace

Run this command to create a namespace custom-eval-tutorial in which all the components for this tutorial will be deployed.

```bash
kubectl create namespace custom-eval-tutorial
```

## References

It is highly recommended that you read the [Evaluator Guide]({{< relref "../../Guides/evaluator.md" >}}) to familiarize yourself with the lifecycle of a Match proposal through the synchronization and evaluation phases. Also, keep the [API Reference]({{< relref "../../reference/api.md" >}}) handy to look up Open Match specific terminology used in this document. The tutorial also customizes the Open Match installation with the configuration of the custom Evaluator. The [Customization Guide]({{< relref "../../Guides/custom.md" >}}) is a good reference for those changes.

A complete [solution](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/custom_evaluator/solution) for this tutorial is in the folder `tutorials/custom_evaluator/solution`.

## Custom Evaluator

### Scenario Overview

For this tutorial, we will use the matchmaking scenario where a Player selects more than one game-mode to be considered for finding a Match. This will result in concurrent MatchFunction executions to generate overlapping results and hence require evaluation. We will build a custom Evaluator and configure Open Match to resolve conflicts using this Evaluator. We will also add the property on the Ticket indicating the time at which the Ticket entered matchmaking queue.
{{% alert title="Note" color="info" %}}
Comparing to the default Evaluator, the Matchmaking function **need** not precompute any score to hint on Match quality. You will have full control over what Tickets decide a better Match with a custom evaluator.
{{% /alert %}}

Thus, the only change to the Matchmaker components from the default Evaluator tutorial is that we will not compute the score or the DefaultEvaluationCriteria in the Match Function. The core of the tutorial thus will focus on authoring the Evaluator and customizing Open Match with it.

### Building the Evaluator

Please revisit the Evaluator overview section in the [default Evaluator tutorial]({{< relref "../DefaultEvaluator/_index.md#evaluation" >}}) as it specifically calls out the scenario in which a custom Evaluator is needed.

This tutorial provides an Evaluator scaffold (`$TUTORIALROOT/evaluator`) as a starting point. The basis [Evaluator server](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/custom_evaluator/evaluator/evaluate/server.go) implementation in `$TUTORIALROOT/evaluator/evaluate/server.go` provides the following functionality:

- Creates a gRPC service that listens on the configured port
- Implements the `Evaluate()` interface that Open Match prescribes
- Accepts a stream of proposals in its implementation fo this interface and then calls into a simplified helper method.
- Streams back results from the helper method to Open Match.

Below is the `evaluate()` helper method in `$TUTORIALROOT/evaluator/evaluate/evaluator.go` where the core evaluation logic should be implemented. At runtime, Open Match calls the `Evaluate()` method and streams the proposals for evaluation. This triggers the `evaluate()` method with a list of proposals. The `evaluate()` method should de-collide the proposals and return a list of results that Open Match will then return back to the Director.

```golang
func evaluate(proposals []*pb.Match) ([]string, error) {
  // Core evaluation logic
  return []string{}, nil
}
```

Please add your evaluation logic to this method. Here are some strategies for evaluation you may use when you detect Matches with overlapping Tickets:

1. Aggregate the wait time of the Tickets on the Match. The Match with higher aggregate wait time is selected and the rest are discarded.
2. Match with the Ticket with the longest wait time gets selected and others discarded.

These are just suggestions. You can also experiment with your own evaluation criteria for this scenario.

As a reference, you may check the implementation of the [tutorial solution Evaluator](https://github.com/googleforgames/open-match/blob/{{< param release_branch >}}/tutorials/custom_evaluator/solution/evaluator/evaluate/evaluator.go) that uses strategy 2.

### Build and Push

Now that we have a custom Evaluator, please run the below commands in the `$TUTORIALROOT` to build and push the Evaluator to your configured image registry.

```bash
docker build -t $REGISTRY/custom-eval-tutorial-evaluator evaluator/
docker push $REGISTRY/custom-eval-tutorial-evaluator
```

### Deploy and Customize

Run the below command in the `$TUTORIALROOT` path to deploy the custom Evaluator to the `custom-eval-tutorial` namespace:

```bash
sed "s|REGISTRY_PLACEHOLDER|$REGISTRY|g" evaluator/evaluator.yaml | kubectl apply -f -
```

We need to update the Open Match ConfigMap with details of the custom Evaluator. The [Customization Guide]({{< relref "../../Guides/custom.md" >}}) provides some details on customizing your Open Match installation. The updated ConfigMap for the custom Evaluator is present in the `customization.yaml`. Run the below command in the `$TUTORIALROOT` path to customize Open Match installation:

```bash
kubectl apply -f customization.yaml --namespace open-match
```

## Build, Deploy, Run Matchmaker

### Build and Push Container images

Now that you have customized these components, please run the below commands from `$TUTORIALROOT` to build new images and push them to your configured image registry.

```bash
docker build -t $REGISTRY/custom-eval-tutorial-frontend frontend/
docker push $REGISTRY/custom-eval-tutorial-frontend
docker build -t $REGISTRY/custom-eval-tutorial-director director/
docker push $REGISTRY/custom-eval-tutorial-director
docker build -t $REGISTRY/custom-eval-tutorial-matchfunction matchfunction/
docker push $REGISTRY/custom-eval-tutorial-matchfunction
```

### Deploy and Run

Run the below command in the `$TUTORIALROOT` path to deploy the MatchFunction, Game Frontend. the Director to the `custom-eval-tutorial` namespace:

```bash
sed "s|REGISTRY_PLACEHOLDER|$REGISTRY|g" matchmaker.yaml | kubectl apply -f -
```

### Output

All the components in this tutorial simply log their progress to stdout. To see the progress, run the below commands:

```bash
kubectl logs -n custom-eval-tutorial pod/custom-eval-tutorial-frontend
kubectl logs -n custom-eval-tutorial pod/custom-eval-tutorial-director
kubectl logs -n custom-eval-tutorial pod/custom-eval-tutorial-matchfunction
```

To check the logs from the custom Evaluator, run the following commands:

```bash
kubectl logs -n custom-eval-tutorial pod/custom-eval-tutorial-evaluator
```

## Cleanup

Run the below command to remove all the components of this tutorial:

```bash
kubectl delete namespace custom-eval-tutorial
```

This will delete all the components deployed in this tutorial. Open Match core in open-match namespace can then be reused for other exercises but you will need to re-customize it.
