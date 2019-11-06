---
title: "Step3 - Build your own Match Function"
linkTitle: "Step3 - Match Function"
weight: 3
---

## Overview

The MatchFunction is a service that implements the core matchmaking logic. A MatchFunction receives a MatchProfile as an input should return Match proposals for this MatchProfile. Here are the tasks it typically performs:

- Query for Tickets for each Pool in the MatchProfile (Open Match provides a helper library for this)
- Use these Tickets to generate Match Proposals. (The MatchProfile also has a Roster Field that can be used to influence the match shape)
- Stream the Match Proposals back to to Open Match.

The tutorial provides a very basic MatchFunction scaffold ```$TUTORIALROOT/matchfunction``` that simply groups the filtered tickets into proposals forming matches of a configurable number of players.

## Make Changes

The MatchFunction scaffolding creates a GRPC service that implements the interface prescribed by Open Match for MatchFunctions. It integrates with Open Match library to Query the Tickets for the given MatchProfile and has logic to stream proposals back to Open Match. It uses a helper function ```makeMatches()``` that accepts a map of Pool names to Tickets in that Pool and returns Match proposals. For this tutorial, the MatchProfile passed in to the MatchFunction has a single Pool that filters Tickets for a game-mode. Thus the ```makeMatches()``` receives a Pool with Tickets belonging to a game-mode and groups these Tickets into matches till it runs out of Tickets. Below is a sample snippet to achieve this:

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

Please copy the above helper or add your own matchmaking logic to ```$TUTORIALROOT/matchfunction/mmf/matchfunction.go```. Also, you may make simple changes such as the number of Tickets per match to observe its impact on the matchmaker run.

### Configuring

The following values need to be set in the MatchFunction (currently specified as a const in the ```$TUTORIALROOT/matchfunction/main.go```):

**Open Match MMLogic endpoint:** The current value assumes the tutorial setup where Open Match is deployed in an open-match namespace with the default configuration and the MatchFunction is deployed in the same cluster in the mmf101-tutorial namespace.
**MatchFunction Port:** This is used to set up the GRPC service. The current value uses the port specified in deployment yaml (covered later in the Deploy and Run step)

Please update this value if your setup is different from the default.

## Build and Push

Now that you have customized the MatchFunction, please run the below commands from ```$TUTORIALROOT``` to build a new image and push it to your configured image registry.

```
# Build the MatchFunction image.
docker build -t $REGISTRY/mm101-tutorial-matchfunction .

# Push the MatchFunction image to the configured Registry.
docker push $REGISTRY/mm101-tutorial-matchfunction
```

Lets proceed to the next step to deploy and run the Matchmaker.
