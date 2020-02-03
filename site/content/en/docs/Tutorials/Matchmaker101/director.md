---
title: "Step 2 - Build your own Director"
linkTitle: "Step 2 - Director"
weight: 2
---

## Overview

The Director is a backend component in the Online Game Service that typically performs the following tasks:

- Fetch Matches from Open Match for each MatchProfile.
- Fetch game allocations from a DGS (Dedicated Game Server) system.
- Establish connections from players to game servers and set Assignments based on connections in Open Match.

The tutorial provides a very basic Director scaffold `$TUTORIALROOT/director` that generates some MatchProfiles and then call FetchMatches for these profiles from Open Match. The director then sets Assignment to a fake connection string to simulate a DGS allocation for every Ticket in a generated match.

## Links to API Definitions for this tutorial

| [pb.Match]({{< relref "../../reference/api.md#match" >}}) | [pb.MatchProfile]({{< relref "../../reference/api.md#matchprofile" >}}) | [pb.FunctionConfig]({{< relref "../../reference/api.md#openmatch.FunctionConfig" >}}) | [backend.AssignTickets]({{< relref "../../reference/api.md#frontend" >}}) | [backend.FetchMatches]({{< relref "../../reference/api.md#frontend" >}}) |
| ----- | ---- | ----- | ----------- | ----------- |

## Make Changes

The Director uses a helper function `generateProfiles()` in `$TUTORIALROOT/director/profile.go` to generate MatchProfiles. For this tutorial, we will generate a MatchProfile for each game-mode. The MatchProfile will have a single Pool that has a single filtering criterion searching for the desired game-mode. Director will call FetchMatches for each of the generated Profiles. Below is a sample snippet to achieve this:

```golang
func generateProfiles() []*pb.MatchProfile {
  var profiles []*pb.MatchProfile
  modes := []string{"mode.demo", "mode.ctf", "mode.battleroyale"}
  for _, mode := range modes {
    profiles = append(profiles, &pb.MatchProfile{
      Name: "mode_based_profile",
      Pools: []*pb.Pool{
        {
          Name: "pool_mode_" + mode,
          TagPresentFilters: []*pb.TagPresentFilter{
            {
              Tag: mode,
            },
          },
        },
      },
    })
  }

  return profiles
}
```

Please copy the above helper or add your own profile generation logic to `$TUTORIALROOT/director/profiles.go`. Also, you may tweak the profile polling interval, Assignment logic, etc. in `$TUTORIALROOT/director/main.go`.

### Configuring

The following values need to be changed if your setup is different from the default in the `TUTORIALROOT/director/main.go`. The default value assumes you have Open Match deployed under `open-match` namespace and the Game Frontend under `mm101-tutorial` namespace in the same cluster:

> `omBackendEndpoint` - Open Match Backend endpoint
>
> `functionHostName` - Kubernetes Internal Hostname of your Match Function
>
> `functionPort` - Port Number that you host your Match Function service on

## Build and Push

Now that you have customized the Director, please run the below commands from `$TUTORIALROOT` to build a new image and push it to your configured image registry.

```
# Build the Director image.
docker build -t $REGISTRY/mm101-tutorial-director director/

# Push the Director image to the configured Registry.
docker push $REGISTRY/mm101-tutorial-director
```

## Whats's Next

Let's proceed to build the [Match Function]({{< relref "./matchfunction.md" >}}).
