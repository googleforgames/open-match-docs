---
title: "Step1 - Build your own Game Frontend"
linkTitle: "Step1 - Game Frontend"
weight: 1
---

## Overview

In an Online Game Service Architecture using Open Match based Matchmaking, the Players will connect to a Game Frontend which will typically perform the following tasks:

- Authenticate and fetch Player data from storage, Platform Services
- Create a Ticket in Open Match to queue this Player's matchmaking request
- Fetch an Assignment for this Ticket and return it back to the Player.

The tutorial provides a very basic Game Frontend scaffold (*[TUTORIALROOT]/frontend*) that generates batches of fake Tickets at periodic intervals and adds them to Open Match. It then polls these Tickets at periodic interval for Assignment. Once an Assignment is received it emits a log with the Assignment details (as a proxy for returning the assignment to the Player) and deletes the Ticket from Open Match. (*Note: In a real setup, polling each Ticket for Assignment is not recommended. You would likely use some eventing mechanism to communicate Assignments from the Director to the Game Frontend*).

## Make Changes

The frontend uses a helper function *makeTicket* in ticket.go to generate a fake Ticket. Any property that is intended to be used for Matchmaking (for instance, game mode in this case) is set as a SearchField on the Ticket. SearchFields can be of different types (double, string, tag) and an appropriate one should be chosen based on the nature of the property and filtering requirements.

For this tutorial, we can create a Ticket that has a game mode specified as a Tag SearchField. The below code snippet picks a random game mode and sets it as a Tag on a fake Ticket.

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

Please copy the above helper or add your own fake Ticket creation logic to *[TUTORIALROOT]/frontend/ticket.go*. Also, you may tweak the size of the Ticket creation batches, polling interval etc. in *[TUTORIALROOT]/frontend/main.go*.

### Configuring

The following values need to be set in the Frontend (currently specified as a const in the *[TUTORIALROOT]/frontend/main.go*):

- Open Match Frontend endpoint: The current value assumes the tutorial setup where Open Match is deployed in an open-match namespace with the default configuration and the Game Frontend is deployed in the same cluster in the mmf101-tutorial namespace.

Please update this value if your setup is different from the default.

## Build and Push

Now that you have customized the Game Frontend, please run the below commands (from [TUTORIALROOT]) to build a new image and push it to your configured image registry.

```
# Build the Frontend image.
docker build -t $REGISTRY/mm101-tutorial-frontend frontend/.

# Push the Frontend image to the configured Registry.
docker push $REGISTRY/mm101-tutorial-frontend
```

Lets proceed to the next step to build the Director.
