---
title: "How to delete all tickets"
linkTitle: "How to delete all tickets"
weight: 3
description: >
  This guide provides guidance about how to delete all tickets in Open Match.
---

Open Match does not provides a `DeleteAll` API for users who want to delete all tickets in Open Match. However, starting from Open Match v0.10.0, we recommend using the `QueryTicketIds` API to query and delete all tickets. Here is a code snippet for the recommended usage.

```go
// Connect to QueryService.
qc, err := grpc.Dial(queryServiceAddr, grpc.WithInsecure())
if err != nil {
    log.Fatalf("Failed to connect to Open Match, got %s", err.Error())
}
defer qc.Close()

q := pb.NewQueryServiceClient(conn)

fc, err := grpc.Dial(queryServiceAddr, grpc.WithInsecure())
if err != nil {
    log.Fatalf("Failed to connect to Open Match, got %s", err.Error())
}
defer fc.Close()

f := pb.NewQueryServiceClient(conn)


// an empty pool returns all ticket ids in Open Match
stream, err := qc.QueryTicketIds(context.Background(), &pb.QueryTicketIdsRequest{})

ids := []string{}
for {
    resp, err := stream.Recv()
    if err == io.EOF {
        break
    }
    if err != nil {
        // process the error
    }

    ids = append(ids, resp.GetIds()...)
}

for _, id := range ids {
    _, err = f.DeleteTicket(context.Background(), &pb.DeleteTicketRequest{TicketId: id})
    if err != nil {
        // process the error
    }
}
```