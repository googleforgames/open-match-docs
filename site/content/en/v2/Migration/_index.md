---
title: "Migration"
linkTitle: "Migration"
weight: 30
type: docs
description: >
  Migration guide from Open Match 1 to Open Match 2
---

**Github Repository: https://github.com/googleforgames/open-match2**

## Space Agon Migration Example
The Space Agon example underwent a migration from using Open Match 1 to Open Match 2.

**Migrate Space Agon Demo from using OM 1 to OM2 on Cloud Run:** 

- https://github.com/googleforgames/space-agon/pull/51

**Migrate Space Agon Demo from using OM 1 to OM2 on GKE:**

- https://github.com/googleforgames/space-agon/pull/52

### Notes
- Please check the code changes and descriptions of these 2 pull requests, as they have concrete examples how to migrate from OM1 to OM2.
- Although the migration using Cloud Run was successful, it was later revealed that OM2 on Cloud Run has some performance issues, as it can only handle about 10 ticket creations per second, which significantly limits how fast matches can be generated. Also, as you will see in the example pull request descriptions, the set up for running OM2 on Cloud Run can feel more complex. Therefore, it’s strongly recommended that you use OM2 on GKE, which can handle 500 ticket creations per second and generate 500 matches per second, and can also be deployed relatively easily.
- The Pull Requests involve a large number of file changes, but most of the file changes are in the vendor folder, which is automatically generated. The files that actually have the OM1 to OM2 migration logic are:
    - [director/director.go](https://github.com/googleforgames/space-agon/blob/main/director/director.go)
    - [frontend/frontend.go](https://github.com/googleforgames/space-agon/blob/main/frontend/frontend.go)
    - [mmf/mmf.go](https://github.com/googleforgames/space-agon/blob/main/mmf/mmf.go)
    - [install/helm/space-agon/templates](https://github.com/googleforgames/space-agon/tree/main/install/helm/space-agon/templates)
    - [install/helm/space-agon/values.yaml](https://github.com/googleforgames/space-agon/blob/main/install/helm/space-agon/values.yaml)
    - [omclient/omclient.go](https://github.com/googleforgames/space-agon/blob/main/omclient/omclient.go) - mostly copied from https://github.com/googleforgames/open-match-ecosystem/blob/v2.0/v2/internal/omclient/omclient.go, but added an initializer and assignment related APIs.
    - [logging/logging.go](https://github.com/googleforgames/space-agon/blob/main/logging/logging.go) - completely copied from https://github.com/googleforgames/open-match-ecosystem/blob/v2.0/v2/internal/logging/logging.go.
