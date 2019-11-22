---
title: "Step 3 - Build your own Match Function"
linkTitle: "Step 3 - Match Function"
weight: 3
---

## Overview

The MatchFunction is a service that implements the core matchmaking logic. A MatchFunction accepts a MatchProfile and should return Match proposals for this MatchProfile. The MatchFunction typically performs the following tasks:

- Queries Tickets for each Pool in the MatchProfile (Open Match provides a helper library for this).
- Uses these Tickets to generate Proposals (The MatchProfile can also describe the shape of a match using the Roster Field).
- Streams the Proposals back to Open Match.

The tutorial provides a very basic MatchFunction scaffold `$TUTORIALROOT/matchfunction` that simply groups the filtered tickets into Proposals of a configurable number of players.

## Links to API Definitions for this tutorial

| [pb.Pool]({{< relref "../../reference/api.md#pool" >}}) | [pb.MatchProfile]({{< relref "../../reference/api.md#matchprofile" >}}) | [pb.Match]({{< relref "../../reference/api.md#match" >}}) | [matchfunction.Run]({{< relref "../../reference/api.md#matchfunction" >}}) |
| ----- | ---- | ----- | ----------- |

## Make Changes

The MatchFunction scaffolding creates a gRPC service that implements the interface prescribed by Open Match for MatchFunctions. It integrates with Open Match library to Query the Tickets for the given MatchProfile and has logic to stream proposals back to Open Match. It uses a helper function `makeMatches()` that accepts a map of Pool names to Tickets in that Pool and returns Match proposals. For this tutorial, the MatchProfile passed into the MatchFunction has a single Pool that filters Tickets for a game-mode. Thus the `makeMatches()` receives a Pool with Tickets belonging to a game-mode and groups these Tickets into matches till it runs out of Tickets. Below is a sample snippet to achieve this:

```
func makeMatches(p *pb.MatchProfile, poolTickets map[string][]*pb.Ticket) ([]*pb.Match, error) {
  var matches []*pb.Match
  count := 0
  for {
    insufficientTickets := false
    matchTickets := []*pb.Ticket{}
    for pool, tickets := range poolTickets {
      if len(tickets) < ticketsPerPoolPerMatch {
        // This pool is completely drained out. Stop creating matches.
        insufficientTickets = true
        break
      }

      // Remove the Tickets from this pool and add to the match proposal.
      matchTickets = append(matchTickets, tickets[0:ticketsPerPoolPerMatch]...)
      poolTickets[pool] = tickets[ticketsPerPoolPerMatch:]
    }

    if insufficientTickets {
      break
    }

    matches = append(matches, &pb.Match{
      MatchId:       fmt.Sprintf("profile-%v-time-%v-%v", p.GetName(), time.Now().Format("2006-01-02T15:04:05.00"), count),
      MatchProfile:  p.GetName(),
      MatchFunction: matchName,
      Tickets:       matchTickets,
    })

    count++
  }

  return matches, nil
}
```

Please copy the above helper or add your own matchmaking logic to `$TUTORIALROOT/matchfunction/mmf/matchfunction.go`. Also, you may change the number of Tickets per match to observe its impact on the matchmaker run.

### Configuring

The following values need to be changed if your setup is different from the default in the `$TUTORIALROOT/frontend/main.go`. The default value assumes you have Open Match deployed under `open-match` namespace and the Game Frontend under `mm101-tutorial` namespace in the same cluster:

> `mmlogicAddress` - Open Match Mmlogic endpoint
>
> `serverPort` - Port Number that you host your Match Function service on, needs to be consistent with `functionPort` in the director. The current value uses the port specified in deployment YAML (covered later in the Deploy and Run step)

## Build and Push

Now that you have customized the MatchFunction, please run the below commands from `$TUTORIALROOT` to build a new image and push it to your configured image registry.

```
# Build the MatchFunction image.
docker build -t $REGISTRY/mm101-tutorial-matchfunction matchfunction/

# Push the MatchFunction image to the configured Registry.
docker push $REGISTRY/mm101-tutorial-matchfunction
```

Let's proceed to the next step to [Deploy and Run the Matchmaker]({{< relref "./deploy.md" >}}).
