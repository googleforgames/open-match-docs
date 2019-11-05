---
title: "Step2 - Build your own Director"
linkTitle: "Step2 - Director"
weight: 2
---

## Overview

The Director is a component in the Online Game Service Backend that will typically perform the following tasks:

- Fetch Matches from Open Match for each MatchProfile
- Fetch allocation from a DGS allocation system.
- Make Assignments for matches to game servers and set those Assignments in Open Match.

The tutorial provides a very basic Director scaffold *[TUTORIALROOT]/director* that generates all the profiles to be queried for and then fetches matches for these profiles from Open Match. For all the Tickets on the generated match, it sets Assignment to a fake assignment string to simulate a DGS allocation.

## Make Changes

The Director uses a helper function *generateProfiles* in profile.go to generate MatchProfiles. A MatchProfiles describes a Match specifying a set of Pools for the match. A Pool comprises of a set of filtering criteria that can be applied to the all the current matchmaking Tickets to shortlist Tickets that meet all the criteria. The Profile gets passed to the Match Function which can query the Tickets for all the Pools in that profile and using those Tickets, generate Match proposals.

For this tutorial, we will generate a MatchProfile for each game-mode. The MatchProfile will have a single Pool that has a single filtering criteria searching for the desired game-mode. Director will call FetchMatches for each of the generated Profiles. Below is a sample snippet to achieve this:

```
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

Please copy the above helper or add your own profile generation logic to *[TUTORIALROOT]/director/profiles.go*. Also, you may tweak the behavior of the Director to change the interval duration between profile polls, assignment logic etc. by making changes to *<TUTORIALROOT>/director/main.go*

### Configuring

The following values need to be set in the Director (currently specified as a const in the *[TUTORIALROOT]/director/main.go*):

- Open Match Backend endpoint: The current value assumes the tutorial setup where Open Match is deployed in an open-match namespace with the default configuration and the Director is deployed in the same cluster in the mmf101-tutorial namespace.
- Match Function Host and Port: The current value uses the host, port specified in deployment yaml (covered later in the Deploy and Run step)

Please update this value if your setup is different from the tutorial default.

## Build and Push

Now that you have customized the Director, please run the below commands (from [TUTORIALROOT]) to build a new image and push it to your configured image registry.

```
# Build the Director image.
docker build -t $REGISTRY/mm101-tutorial-director director/.

# Push the Director image to the configured Registry.
docker push $REGISTRY/mm101-tutorial-director
```

Lets proceed to the next step to build the Match Function.
