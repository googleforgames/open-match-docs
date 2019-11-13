---
title: "Step 1 - Build your own Game Frontend"
linkTitle: "Step 1 - Game Frontend"
weight: 1
---

## Overview

The Game Frontend serves as a layer that transfers players' matchmaking requests from players' Game Client to proto messages that Open Match can understand. The Game Frontend typically performs the following tasks:

- Fetches the player data from some backend storage (or Platform Services if required) and authenticates players.
- Submits the matchmaking requests to Open Match by creating a Ticket.
- Communicates the Assignment result back to the Game Client once Open Match found an Assignment for this Ticket.

This tutorial provides a very basic Game Frontend scaffold (`$TUTORIALROOT/frontend`) that periodically generates batches of fake Tickets, adds them to Open Match, and polls these Tickets for Assignment. Once an Assignment is received it emits a log with the Assignment details (as a proxy for returning the Assignment to the Player) and deletes the Ticket from Open Match.

{{% alert title="Note" color="info" %}}
Under production environment, polling each Ticket for Assignment is not recommended. We recommend using event handlers/listeners to communicate Assignments result to the Game Frontend.
{{% /alert %}}

## Links to API Definitions for this tutorial

| [pb.Ticket]({{< relref "../../reference/api.md#openmatch.Ticket" >}}) | [frontend.CreateTicket]({{< relref "../../reference/api.md#frontend" >}}) | [frontend.GetTicket]({{< relref "../../reference/api.md#frontend" >}}) | [frontend.DeleteTicket]({{< relref "../../reference/api.md#frontend" >}})
| ----- | ---- | ----- | ----------- |

## Make Changes

The Game Frontend uses a helper function `makeTicket()` in `$TUTORIALROOT/frontend/ticket.go` to generate a fake Ticket. Any property that is intended to be used for Matchmaking (for instance, game mode in this case) is set as a SearchField on the Ticket. For this tutorial, we create a Ticket that has a game mode specified as a Tag SearchField. The below code snippet picks a random game mode and sets it as a Tag on a fake Ticket.

```
func makeTicket() *pb.Ticket {
  modes := []string{"mode.demo", "mode.ctf", "mode.battleroyale"}
  ticket := &pb.Ticket{
    SearchFields: &pb.SearchFields{
      Tags: []string{
        modes[rand.Intn(len(modes))],
      },
    },
  }

  return ticket
}
```

Please copy the above helper or add your own fake Ticket creation logic to `$TUTORIALROOT/frontend/ticket.go`. Also, you may tweak the size of the Ticket creation batches, polling interval, etc. in `$TUTORIALROOT/frontend/main.go`.

### Configuring

The following values need to be changed if your setup is different from the default in the `$TUTORIALROOT/frontend/main.go`. The default value assumes you have Open Match deployed under `open-match` namespace and the Game Frontend under `mm101-tutorial` namespace in the same cluster:

> `omFrontendEndpoint` - Open Match Frontend endpoint

## Build and Push

Now that you have customized the Game Frontend, please run the below commands from `$TUTORIALROOT` to build a new image and push it to your configured image registry.

```
# Build the Frontend image.
docker build -t $REGISTRY/mm101-tutorial-frontend frontend/.

# Push the Frontend image to the configured Registry.
docker push $REGISTRY/mm101-tutorial-frontend
```

## Whats's Next:

Let's proceed to build the [Director]({{< relref "./director.md" >}}).
