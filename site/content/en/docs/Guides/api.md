---
title: "API"
linkTitle: "API"
weight: 1
description: >
  This guide covers how you can interact with the Open Match API.
---

Open Match has a resource based REST API that is served from HTTP and gRPC. It also
complies with the [Swagger / OpenAPI] API Specification which means it's easy to
download the schema and [generate clients](https://swagger.io/tools/swagger-codegen/)
in many different languages.

You can view and talk to this API via the swaggerui application that is deployed
with your Open Match cluster.

## Opening the swaggerui Tool

### Google Kubernetes Engine
If your cluster runs on GKE you can access the tool from your cluster using a Public IP address.
Go to Cloud Console > Kubernetes Engine > Services & Ingress and look for om-swaggerui.
In that row there's a link to view the API browser.

### Locally
The swaggerui tool is accessible from your cluster via port 50500. Kubernetes's
virtual network is by default private so you'll need to add a proxy to communicate with it.

```bash
kubectl port-forward --namespace open-match $(kubectl get pod --namespace open-match --selector="app=open-match,component=swaggerui" --output jsonpath='{.items[0].metadata.name}') 51500:51500
```

This command looks a bit convoluted but what it does is get the pod name and then setup a
proxy between that pod and your computer.

From there you can access the proxy from http://localhost:51500.

## Using the swaggerui Tool

SwaggerUI is a generic tool for viewing APIs and interacting with them.
Since Open Match has multiple APIs you can talk to them by changing the path located at
the top.

 * /api/backend.swagger.json
 * /api/frontend.swagger.json
 * /api/mmlogic.swagger.json

By clicking on a function you can see the schema of the API. To call an API click
`Try it out` and then fill in body and then select `Execute`. You'll then see the
HTTP code and response.

## Disable swaggerui Tool

For security purposes you will want to disable the swaggerui application by setting
`--set openmatch.swaggerui.install=false` in the helm command or add the following
YAML to your values.yaml.

```yaml
openmatch:
  swaggerui:
    install: false
```
