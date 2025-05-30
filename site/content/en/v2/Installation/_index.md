---
title: "Installation"
linkTitle: "Installation"
weight: 10
type: docs
description: >
  How to install and set up Open Match v2
---

**Github Repository: https://github.com/googleforgames/open-match2**

## Install on GKE

See the example manifests in https://github.com/googleforgames/open-match2/tree/main/deploy/gke.
To install Open Match 2 on GKE, first configure a Google Service Account with Metric Write role,
and bind the Google Service Account to the Kuberentes Service Account:

```
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$GOOGLE_SERVICE_ACCOUNT" --role="roles/monitoring.metricWriter"
gcloud iam service-accounts add-iam-policy-binding $GOOGLE_SERVICE_ACCOUNT --role roles/iam.workloadIdentityUser --member "serviceAccount:$PROJECT_ID.svc.id.goog[default/open-match-sa]"
```

then deploy the example manifests:

```
kubectl apply -f redis.yaml
kubectl apply -f om.yaml
```

## Install on Cloud Run

The deploy directory contains sample `service.yaml` and `cloudbuild.yaml` files, either of which you can edit to deploy an om-core service to Cloud Run in Google Cloud. Typically the `service.yaml` is easier to adapt to manually deploying via command line, and `cloudbuild.yaml` is easier to adapt to a continuous build system, although feel free to use them as you see fit.

You should populate the following:

- Your VPC network. Unless your company has turned on the `constraints/compute.skipDefaultNetworkCreation` org policy, your Google Cloud project will have a VPC created already, named `default`.
- Your Service Account created for `om-core`. The `deploy/cloudrun-sa.iam` file lists all the roles the service account will need.
- Your Redis instance IP address(es, OM supports configuring reads and writes to go to a master/replica respectively if you wish) that can be reached from Cloud Run. We test against Cloud Memorystore for Redis using the configuration detailed in this [guide](https://cloud.google.com/memorystore/docs/redis/connect-redis-instance-cloud-run).

With the `service.yaml` file populated with everything you've configured, you can deploy the service with a command like this:

```
gcloud run services replace service.yaml
```