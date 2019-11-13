---
title: "Step 4 - Deploy and Run"
linkTitle: "Step 4 - Deploy and Run"
weight: 4
---

This step assumes that you have completed the Tutorial prerequisites and all prior steps and have the Game Frontend, Director and Match Function built and pushed to your configured image registry. If you have done all of this, let's proceed.

## Deploy the Match Function, Game Frontend, Director

The next step is to deploy the Match Function, the Game Frontend and the Director to the same cluster as Open Match deployment but to a different namespace. The `$TUTORIALROOT/matchmaker.yaml` deploys these components to a `mm101-tutorial` namespace. Run the below command in the `$TUTORIALROOT` path to apply this YAML:

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
