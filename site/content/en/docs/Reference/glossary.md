---
title: "Glossary"
linkTitle: "Glossary"
weight: 3
description: >
  Open Match uses a lot of Cloud native tools. Here's what they mean.
---

**Docker Image**

Docker Images are sort of like a zip file that would contain your game binary and assets.
It also contains a minimal operating system (~2-10MiB), environment variables, and other contexts.

The intent is that the image is portable between host machines (that can run different host OSes)
but the application itself will run the same because all of its dependencies (ex: glibc, DLLs, etc)
included without the need for virtualization. Docker Images are stored in Docker Image
Repositories and are versioned.

Open Match uses [distroless/static:nonroot](https://github.com/GoogleContainerTools/distroless)
images which provide just enough Linux OS to run a mostly-static binary. There are other flavors
of distroless for the popular languages.

**Docker**

[Docker](https://docs.docker.com/engine/docker-overview/) is what generally mean when they say
"containers". It allows you to run Docker Images on a host operating system. Containers provide
a thin layer of isolation between the host and the application that makes it think it is running
in its own environment.

**Kubernetes**

You give [Kubernetes](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/)
a bunch of servers to run and it'll figure out how where to run them based on available
resources. The machines can be different shapes and sizes. You can declare how much CPU
and RAM a container may consume before it's throttled or killed respectively.

Kubernetes also provides a configurable private network that by default servers cannot
communicate outside the network. It's possible to open up ports through
[Service](https://kubernetes.io/docs/concepts/services-networking/service/) definitions.

Lastly, it provides configuration management including secrets
(like passwords and auth tokens) and auto-healing (service health monitoring and restart).

Open Match uses Kubernetes to schedule and run its services. It also uses secrets to
hold TLS certificates and Redis passwords.

**Helm**

[Helm](https://helm.sh/) is the Kubernetes package manager. It allows you to create
Kubernetes deployments as templates and parameters. Helm deployments are called charts.
For example, you can create a Open Match deployment that has 50 frontend servers via
`--set openmatch.frontend.replicas=50`.

Open Match uses Helm to simplify its Kubernetes deployment. By default, the Helm chart
deploys Redis, Open Match, Prometheus, and Grafana.

_Helm is not required for Open Match._

**Terraform**

[Terraform](https://www.terraform.io/intro/index.html#what-is-terraform-) provides
a way to express your
[infrastructure-as-code](https://en.wikipedia.org/wiki/Infrastructure_as_code).
In other words, you can write a template that says "give me 20 machines each with
4 vCPUs and 32 GiB RAM that live in us-west1-b on the same network in GCP" and
Terraform will make that happen. You can then change your configuration to have 25
machines and Terraform will add the additional 5.

Open Match does not use Terraform. We provide an example of a Terraform template that
can be used to declare infrastructure you'd need to run it.

_Terraform is not required for Open Match._
