---
title: "Step 4 - Deploy and Run"
linkTitle: "Step 4 - Deploy and Run"
weight: 4
---

This step assumes that you have completed the Tutorial prerequisites and all prior steps and have the Game Frontend, Director and Match Function built and pushed to your configured image registry. If you have done all of this, let's proceed.

## Customizing Open Match Installation

Open Match Core needs some customizations to be fully operational. The two customizations Open Match needs are the Match Function and Evaluator. We already built and pushed the Match Function image in the previous step. The next step is to build and push an Evaluator image.

### Build and Push Evaluator

Although using an Evaluator is out of scope for this document, we still need to set up a default Evaluator for Open Match. This tutorial comes packaged with a default Evaluator (see ```$TUTORIALROOT/evaluator```). Please run the below steps from ```$TUTORIALROOT``` to build this Evaluator and push its image to the configured image registry.

```
# Build the Evaluator image.
docker build -t $REGISTRY/mm101-tutorial-evaluator evaluator/.

# Push the Evaluator image.
docker push $REGISTRY/mm101-tutorial-evaluator
```

## Links to API Definitions for this tutorial

| [pb.DefaultEvaluationCriteria]({{< relref "../../reference/api.md#defaultevaluationcriteria" >}}) | [evaluator.Evaluate]({{< relref "../../reference/api.md#api-evaluator-proto" >}}) |
| ----- | ---- |

### Deploy and Customize

The next step is to deploy the Match Function and the Evaluator to the same cluster as Open Match deployment but to a different namespace. The ```$TUTORIALROOT/customization.yaml``` deploys these components as Services to ```mm101-tutorial``` namespace and adds a ConfigMap to Open Match namespace with the configuration of the Evaluator. Run the below command in the ```$TUTORIALROOT``` path to apply this YAML:

```
sed "s|REGISTRY_PLACEHOLDER|$REGISTRY|g" customization.yaml | kubectl apply -f -
```

Please validate that all the Open Match pods and the customizations are in running state before proceeding to the next step. Here is a command to do this:

```
# Check status for all Open Match Core pods
kubectl get -n open-match pod

# Check status for all Open Match customization pods
kubectl get -n mm101-tutorial pod
```

## Deploy Game Frontend, Director

Now that Open Match is set up and customized, it is ready to be used by the Game Frontend and Director.

The ```$TUTORIALROOT/matchmaker.yaml``` deploys these components as single Pods to a ```mm101-tutorial``` namespace. Run the below command in the ```$TUTORIALROOT``` path to apply this YAML:

```
sed "s|REGISTRY_PLACEHOLDER|$REGISTRY|g" matchmaker.yaml | kubectl apply -f -
```

## Matchmaking ever after

All the components authored in this tutorial simply log their progress. Thus to see the progress, please check the logs for the below pods. Below are the commands and the expected output:

### Game Frontend

```
kubectl logs -n mm101-tutorial pod/mm101-tutorial-frontend

# Sample Expected Output
2019/11/07 17:44:45 Ticket created successfully, id: bn25g39sm0mrm8pkpssg
2019/11/07 17:44:45 Ticket created successfully, id: bn25g39sm0mrm8pkpst0
2019/11/07 17:44:45 Ticket bn25g0psm0mrm8pkpr70 got assignment connection:"3.195.34.194:2222"
2019/11/07 17:44:45 Ticket bn25g0psm0mrm8pkpr7g got assignment connection:"207.123.239.153:2222"
```

### Director

```
kubectl logs -n mm101-tutorial pod/mm101-tutorial-director

# Output
2019/11/07 17:45:15 Generated 16 matches for profile mode_based_profile
2019/11/07 17:45:15 Assigned server 217.7.41.62:2222 to match profile-mode_based_profile-time-2019-11-07T17:45:10.53-0
2019/11/07 17:45:15 Assigned server 210.183.191.233:2222 to match profile-mode_based_profile-time-2019-11-07T17:45:10.53-1
```

### Match Function

```
kubectl logs -n mm101-tutorial pod/mm101-tutorial-matchfunction

# Output
2019/11/07 17:45:45 Generating proposals for function mode_based_profile
2019/11/07 17:45:45 Streaming 5 proposals to Open Match
```

## Deleting the Tutorial

To remove the tutorial and its custom components, here is the command you need to run:

```
kubectl delete namespace mm101-tutorial
```

This will delete all the components (including the match function and the evaluator). Note that the Open Match core in open-match namespace can then be used for other exercises but you will need to re-customize it.
