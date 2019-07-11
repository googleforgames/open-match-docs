---
title: "API Guide"
linkTitle: "API Guide"
weight: 1
description: >
  This guide covers how you can interact with the Open Match API.
---

Open Match has a resource based REST API that is served from HTTP and gRPC. It also
complies with the OpenAPI (fka Swagger) API Specification which means it's easy to
download the schema and [generate clients](https://swagger.io/tools/swagger-codegen/)
in many different languages.

You can view and talk to this API via the Swagger UI application that is deployed
with your Open Match cluster.

## Opening the Swagger UI

### Google Kubernetes Engine
If your cluster runs on GKE you can access the tool from your cluster using a Public IP address.
Go to `Cloud Console > Kubernetes Engine > Services & Ingress` and look for `om-swaggerui`.
In that row there's a link to view the API browser.

### Locally
The Swagger UI is accessible from your cluster via port 51500. Kubernetes's
virtual network is by default private so you'll need to add a proxy to communicate with it.

```bash
# Get the name of a pod running Swagger UI.
SWAGGERUI_POD=`kubectl get pod --namespace open-match --selector="app=open-match,component=swaggerui" --output jsonpath='{.items[0].metadata.name}'`
# Open the port to the pod so that it can be accessed locally.
kubectl port-forward --namespace open-match $SWAGGERUI_POD 51500:51500
```

From there you can access the proxy from http://localhost:51500.

## Using the Swagger UI

Swagger UI is a generic tool for viewing APIs and interacting with them.
Open Match has many APIs but the default one is the `Frontend`.

![Swagger UI for Open Match](../../../images/swaggerui.png)

By clicking on a function you can see the schema of the API. To call an API click
`Try it out` and then fill in body and then select `Execute`. You'll then see the
HTTP code and response.

## Disable Swagger UI

For security purposes you will want to disable the Swagger UI application by setting
`--set openmatch.swaggerui.install=false` in the helm command or add the following
YAML to your values.yaml.

```yaml
openmatch:
  swaggerui:
    install: false
```