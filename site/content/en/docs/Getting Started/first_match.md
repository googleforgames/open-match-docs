---
title: "Quickstart: Create Your First Match"
linkTitle: "First Match"
weight: 20
description: >
  This guide covers how you can deploy the Demo matchmaker and create your first match.
---

## Objectives

- Deploy the demo matchmaking function (MMF) and evaluator.
- Create your first match.

### 1. Deploy the Demo

```bash
kubectl apply -f https://open-match.dev/install/v{{ .Site.Params.release_version }}/yaml/install.yaml
```