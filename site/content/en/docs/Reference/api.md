---
title: "Open Match API References" 
linkTitle: "Open Match API References" 
weight: 2 
description: 
  This document provides API references for Open Match services. 
---
# Protocol Documentation
<a name="top"></a>

## Table of Contents

- [api/backend.proto](#api/backend.proto)
    - [AssignTicketsRequest](#openmatch.AssignTicketsRequest)
    - [AssignTicketsResponse](#openmatch.AssignTicketsResponse)
    - [AssignmentFailure](#openmatch.AssignmentFailure)
    - [AssignmentGroup](#openmatch.AssignmentGroup)
    - [FetchMatchesRequest](#openmatch.FetchMatchesRequest)
    - [FetchMatchesResponse](#openmatch.FetchMatchesResponse)
    - [FunctionConfig](#openmatch.FunctionConfig)
    - [ReleaseAllTicketsRequest](#openmatch.ReleaseAllTicketsRequest)
    - [ReleaseAllTicketsResponse](#openmatch.ReleaseAllTicketsResponse)
    - [ReleaseTicketsRequest](#openmatch.ReleaseTicketsRequest)
    - [ReleaseTicketsResponse](#openmatch.ReleaseTicketsResponse)
  
    - [AssignmentFailure.Cause](#openmatch.AssignmentFailure.Cause)
    - [FunctionConfig.Type](#openmatch.FunctionConfig.Type)
  
    - [BackendService](#openmatch.BackendService)
  
- [api/evaluator.proto](#api/evaluator.proto)
    - [EvaluateRequest](#openmatch.EvaluateRequest)
    - [EvaluateResponse](#openmatch.EvaluateResponse)
  
    - [Evaluator](#openmatch.Evaluator)
  
- [api/extensions.proto](#api/extensions.proto)
    - [DefaultEvaluationCriteria](#openmatch.DefaultEvaluationCriteria)
  
- [api/frontend.proto](#api/frontend.proto)
    - [AcknowledgeBackfillRequest](#openmatch.AcknowledgeBackfillRequest)
    - [CreateBackfillRequest](#openmatch.CreateBackfillRequest)
    - [CreateTicketRequest](#openmatch.CreateTicketRequest)
    - [DeleteBackfillRequest](#openmatch.DeleteBackfillRequest)
    - [DeleteTicketRequest](#openmatch.DeleteTicketRequest)
    - [GetBackfillRequest](#openmatch.GetBackfillRequest)
    - [GetTicketRequest](#openmatch.GetTicketRequest)
    - [UpdateBackfillRequest](#openmatch.UpdateBackfillRequest)
    - [WatchAssignmentsRequest](#openmatch.WatchAssignmentsRequest)
    - [WatchAssignmentsResponse](#openmatch.WatchAssignmentsResponse)
  
    - [FrontendService](#openmatch.FrontendService)
  
- [api/matchfunction.proto](#api/matchfunction.proto)
    - [RunRequest](#openmatch.RunRequest)
    - [RunResponse](#openmatch.RunResponse)
  
    - [MatchFunction](#openmatch.MatchFunction)
  
- [api/messages.proto](#api/messages.proto)
    - [Assignment](#openmatch.Assignment)
    - [Assignment.ExtensionsEntry](#openmatch.Assignment.ExtensionsEntry)
    - [Backfill](#openmatch.Backfill)
    - [Backfill.ExtensionsEntry](#openmatch.Backfill.ExtensionsEntry)
    - [DoubleRangeFilter](#openmatch.DoubleRangeFilter)
    - [Match](#openmatch.Match)
    - [Match.ExtensionsEntry](#openmatch.Match.ExtensionsEntry)
    - [MatchProfile](#openmatch.MatchProfile)
    - [MatchProfile.ExtensionsEntry](#openmatch.MatchProfile.ExtensionsEntry)
    - [Pool](#openmatch.Pool)
    - [SearchFields](#openmatch.SearchFields)
    - [SearchFields.DoubleArgsEntry](#openmatch.SearchFields.DoubleArgsEntry)
    - [SearchFields.StringArgsEntry](#openmatch.SearchFields.StringArgsEntry)
    - [StringEqualsFilter](#openmatch.StringEqualsFilter)
    - [TagPresentFilter](#openmatch.TagPresentFilter)
    - [Ticket](#openmatch.Ticket)
    - [Ticket.ExtensionsEntry](#openmatch.Ticket.ExtensionsEntry)
  
    - [DoubleRangeFilter.Exclude](#openmatch.DoubleRangeFilter.Exclude)
  
- [api/query.proto](#api/query.proto)
    - [QueryBackfillsRequest](#openmatch.QueryBackfillsRequest)
    - [QueryBackfillsResponse](#openmatch.QueryBackfillsResponse)
    - [QueryTicketIdsRequest](#openmatch.QueryTicketIdsRequest)
    - [QueryTicketIdsResponse](#openmatch.QueryTicketIdsResponse)
    - [QueryTicketsRequest](#openmatch.QueryTicketsRequest)
    - [QueryTicketsResponse](#openmatch.QueryTicketsResponse)
  
    - [QueryService](#openmatch.QueryService)
  
- [Scalar Value Types](#scalar-value-types)



<a name="api/backend.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## api/backend.proto



<a name="openmatch.AssignTicketsRequest"></a>

### AssignTicketsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| assignments | [AssignmentGroup](#openmatch.AssignmentGroup) | repeated | Assignments is a list of assignment groups that contain assignment and the Tickets to which they should be applied. |






<a name="openmatch.AssignTicketsResponse"></a>

### AssignTicketsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| failures | [AssignmentFailure](#openmatch.AssignmentFailure) | repeated | Failures is a list of all the Tickets that failed assignment along with the cause of failure. |






<a name="openmatch.AssignmentFailure"></a>

### AssignmentFailure
AssignmentFailure contains the id of the Ticket that failed the Assignment and the failure status.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ticket_id | [string](#string) |  |  |
| cause | [AssignmentFailure.Cause](#openmatch.AssignmentFailure.Cause) |  |  |






<a name="openmatch.AssignmentGroup"></a>

### AssignmentGroup
AssignmentGroup contains an Assignment and the Tickets to which it should be applied.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ticket_ids | [string](#string) | repeated | TicketIds is a list of strings representing Open Match generated Ids which apply to an Assignment. |
| assignment | [Assignment](#openmatch.Assignment) |  | An Assignment specifies game connection related information to be associated with the TicketIds. |






<a name="openmatch.FetchMatchesRequest"></a>

### FetchMatchesRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| config | [FunctionConfig](#openmatch.FunctionConfig) |  | A configuration for the MatchFunction server of this FetchMatches call. |
| profile | [MatchProfile](#openmatch.MatchProfile) |  | A MatchProfile that will be sent to the MatchFunction server of this FetchMatches call. |






<a name="openmatch.FetchMatchesResponse"></a>

### FetchMatchesResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| match | [Match](#openmatch.Match) |  | A Match generated by the user-defined MMF with the specified MatchProfiles. A valid Match response will contain at least one ticket. |






<a name="openmatch.FunctionConfig"></a>

### FunctionConfig
FunctionConfig specifies a MMF address and client type for Backend to establish connections with the MMF


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| host | [string](#string) |  |  |
| port | [int32](#int32) |  |  |
| type | [FunctionConfig.Type](#openmatch.FunctionConfig.Type) |  |  |






<a name="openmatch.ReleaseAllTicketsRequest"></a>

### ReleaseAllTicketsRequest







<a name="openmatch.ReleaseAllTicketsResponse"></a>

### ReleaseAllTicketsResponse







<a name="openmatch.ReleaseTicketsRequest"></a>

### ReleaseTicketsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ticket_ids | [string](#string) | repeated | TicketIds is a list of string representing Open Match generated Ids to be re-enabled for MMF querying because they are no longer awaiting assignment from a previous match result |






<a name="openmatch.ReleaseTicketsResponse"></a>

### ReleaseTicketsResponse






 


<a name="openmatch.AssignmentFailure.Cause"></a>

### AssignmentFailure.Cause


| Name | Number | Description |
| ---- | ------ | ----------- |
| UNKNOWN | 0 |  |
| TICKET_NOT_FOUND | 1 |  |



<a name="openmatch.FunctionConfig.Type"></a>

### FunctionConfig.Type


| Name | Number | Description |
| ---- | ------ | ----------- |
| GRPC | 0 |  |
| REST | 1 |  |


 

 


<a name="openmatch.BackendService"></a>

### BackendService
The BackendService implements APIs to generate matches and handle ticket assignments.

| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| FetchMatches | [FetchMatchesRequest](#openmatch.FetchMatchesRequest) | [FetchMatchesResponse](#openmatch.FetchMatchesResponse) stream | FetchMatches triggers a MatchFunction with the specified MatchProfile and returns a set of matches generated by the Match Making Function, and accepted by the evaluator. Tickets in matches returned by FetchMatches are moved from active to pending, and will not be returned by query. |
| AssignTickets | [AssignTicketsRequest](#openmatch.AssignTicketsRequest) | [AssignTicketsResponse](#openmatch.AssignTicketsResponse) | AssignTickets overwrites the Assignment field of the input TicketIds. |
| ReleaseTickets | [ReleaseTicketsRequest](#openmatch.ReleaseTicketsRequest) | [ReleaseTicketsResponse](#openmatch.ReleaseTicketsResponse) | ReleaseTickets moves tickets from the pending state, to the active state. This enables them to be returned by query, and find different matches. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |
| ReleaseAllTickets | [ReleaseAllTicketsRequest](#openmatch.ReleaseAllTicketsRequest) | [ReleaseAllTicketsResponse](#openmatch.ReleaseAllTicketsResponse) | ReleaseAllTickets moves all tickets from the pending state, to the active state. This enables them to be returned by query, and find different matches. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |

 



<a name="api/evaluator.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## api/evaluator.proto



<a name="openmatch.EvaluateRequest"></a>

### EvaluateRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| match | [Match](#openmatch.Match) |  | A Matches proposed by the Match Function representing a candidate of the final results. |






<a name="openmatch.EvaluateResponse"></a>

### EvaluateResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| match_id | [string](#string) |  | A Match ID representing a shortlisted match returned by the evaluator as the final result. |





 

 

 


<a name="openmatch.Evaluator"></a>

### Evaluator
The Evaluator service implements APIs used to evaluate and shortlist matches proposed by MMFs.

| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| Evaluate | [EvaluateRequest](#openmatch.EvaluateRequest) stream | [EvaluateResponse](#openmatch.EvaluateResponse) stream | Evaluate evaluates a list of proposed matches based on quality, collision status, and etc, then shortlist the matches and returns the final results. |

 



<a name="api/extensions.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## api/extensions.proto



<a name="openmatch.DefaultEvaluationCriteria"></a>

### DefaultEvaluationCriteria
A DefaultEvaluationCriteria is used for a match&#39;s evaluation_input when using
the default evaluator.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| score | [double](#double) |  |  |





 

 

 

 



<a name="api/frontend.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## api/frontend.proto



<a name="openmatch.AcknowledgeBackfillRequest"></a>

### AcknowledgeBackfillRequest
BETA FEATURE WARNING: This Request message is not finalized and still subject
to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| backfill_id | [string](#string) |  | An existing ID of Backfill to acknowledge. |
| assignment | [Assignment](#openmatch.Assignment) |  | An updated Assignment of the requested Backfill. |






<a name="openmatch.CreateBackfillRequest"></a>

### CreateBackfillRequest
BETA FEATURE WARNING: This Request message is not finalized and still subject
to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| backfill | [Backfill](#openmatch.Backfill) |  | An empty Backfill object. |






<a name="openmatch.CreateTicketRequest"></a>

### CreateTicketRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ticket | [Ticket](#openmatch.Ticket) |  | A Ticket object with SearchFields defined. |






<a name="openmatch.DeleteBackfillRequest"></a>

### DeleteBackfillRequest
BETA FEATURE WARNING: This Request message is not finalized and still subject
to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| backfill_id | [string](#string) |  | An existing ID of Backfill to delete. |






<a name="openmatch.DeleteTicketRequest"></a>

### DeleteTicketRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ticket_id | [string](#string) |  | A TicketId of a generated Ticket to be deleted. |






<a name="openmatch.GetBackfillRequest"></a>

### GetBackfillRequest
BETA FEATURE WARNING: This Request message is not finalized and still subject
to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| backfill_id | [string](#string) |  | An existing ID of Backfill to retrieve. |






<a name="openmatch.GetTicketRequest"></a>

### GetTicketRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ticket_id | [string](#string) |  | A TicketId of a generated Ticket. |






<a name="openmatch.UpdateBackfillRequest"></a>

### UpdateBackfillRequest
UpdateBackfillRequest - update searchFields, extensions and set assignment.

BETA FEATURE WARNING: This Request message is not finalized and still subject
to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| backfill | [Backfill](#openmatch.Backfill) |  | A Backfill object with ID set and fields to update. |






<a name="openmatch.WatchAssignmentsRequest"></a>

### WatchAssignmentsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ticket_id | [string](#string) |  | A TicketId of a generated Ticket to get updates on. |






<a name="openmatch.WatchAssignmentsResponse"></a>

### WatchAssignmentsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| assignment | [Assignment](#openmatch.Assignment) |  | An updated Assignment of the requested Ticket. |





 

 

 


<a name="openmatch.FrontendService"></a>

### FrontendService
The FrontendService implements APIs to manage and query status of a Tickets.

| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| CreateTicket | [CreateTicketRequest](#openmatch.CreateTicketRequest) | [Ticket](#openmatch.Ticket) | CreateTicket assigns an unique TicketId to the input Ticket and record it in state storage. A ticket is considered as ready for matchmaking once it is created. - If a TicketId exists in a Ticket request, an auto-generated TicketId will override this field. - If SearchFields exist in a Ticket, CreateTicket will also index these fields such that one can query the ticket with query.QueryTickets function. |
| DeleteTicket | [DeleteTicketRequest](#openmatch.DeleteTicketRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) | DeleteTicket immediately stops Open Match from using the Ticket for matchmaking and removes the Ticket from state storage. The client should delete the Ticket when finished matchmaking with it. |
| GetTicket | [GetTicketRequest](#openmatch.GetTicketRequest) | [Ticket](#openmatch.Ticket) | GetTicket get the Ticket associated with the specified TicketId. |
| WatchAssignments | [WatchAssignmentsRequest](#openmatch.WatchAssignmentsRequest) | [WatchAssignmentsResponse](#openmatch.WatchAssignmentsResponse) stream | WatchAssignments stream back Assignment of the specified TicketId if it is updated. - If the Assignment is not updated, GetAssignment will retry using the configured backoff strategy. |
| AcknowledgeBackfill | [AcknowledgeBackfillRequest](#openmatch.AcknowledgeBackfillRequest) | [Backfill](#openmatch.Backfill) | AcknowledgeBackfill is used to notify OpenMatch about GameServer connection info This triggers an assignment process. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |
| CreateBackfill | [CreateBackfillRequest](#openmatch.CreateBackfillRequest) | [Backfill](#openmatch.Backfill) | CreateBackfill creates a new Backfill object. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |
| DeleteBackfill | [DeleteBackfillRequest](#openmatch.DeleteBackfillRequest) | [.google.protobuf.Empty](#google.protobuf.Empty) | DeleteBackfill receives a backfill ID and deletes its resource. Any tickets waiting for this backfill will be returned to the active pool, no longer pending. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |
| GetBackfill | [GetBackfillRequest](#openmatch.GetBackfillRequest) | [Backfill](#openmatch.Backfill) | GetBackfill returns a backfill object by its ID. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |
| UpdateBackfill | [UpdateBackfillRequest](#openmatch.UpdateBackfillRequest) | [Backfill](#openmatch.Backfill) | UpdateBackfill updates search_fields and extensions for the backfill with the provided id. Any tickets waiting for this backfill will be returned to the active pool, no longer pending. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |

 



<a name="api/matchfunction.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## api/matchfunction.proto



<a name="openmatch.RunRequest"></a>

### RunRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| profile | [MatchProfile](#openmatch.MatchProfile) |  | A MatchProfile defines constraints of Tickets in a Match and shapes the Match proposed by the MatchFunction. |






<a name="openmatch.RunResponse"></a>

### RunResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| proposal | [Match](#openmatch.Match) |  | A Proposal represents a Match candidate that satifies the constraints defined in the input Profile. A valid Proposal response will contain at least one ticket. |





 

 

 


<a name="openmatch.MatchFunction"></a>

### MatchFunction
The MatchFunction service implements APIs to run user-defined matchmaking logics.

| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| Run | [RunRequest](#openmatch.RunRequest) | [RunResponse](#openmatch.RunResponse) stream | DO NOT CALL THIS FUNCTION MANUALLY. USE backend.FetchMatches INSTEAD. Run pulls Tickets that satisfy Profile constraints from QueryService, runs matchmaking logic against them, then constructs and streams back match candidates to the Backend service. |

 



<a name="api/messages.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## api/messages.proto



<a name="openmatch.Assignment"></a>

### Assignment
An Assignment represents a game server assignment associated with a Ticket.
Open Match does not require or inspect any fields on assignment.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| connection | [string](#string) |  | Connection information for this Assignment. |
| extensions | [Assignment.ExtensionsEntry](#openmatch.Assignment.ExtensionsEntry) | repeated | Customized information not inspected by Open Match, to be used by the match making function, evaluator, and components making calls to Open Match. Optional, depending on the requirements of the connected systems. |






<a name="openmatch.Assignment.ExtensionsEntry"></a>

### Assignment.ExtensionsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [google.protobuf.Any](#google.protobuf.Any) |  |  |






<a name="openmatch.Backfill"></a>

### Backfill
Represents a backfill entity which is used to fill partially full matches.

BETA FEATURE WARNING:  This call and the associated Request and Response
messages are not finalized and still subject to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| id | [string](#string) |  | Id represents an auto-generated Id issued by Open Match. |
| search_fields | [SearchFields](#openmatch.SearchFields) |  | Search fields are the fields which Open Match is aware of, and can be used when specifying filters. |
| extensions | [Backfill.ExtensionsEntry](#openmatch.Backfill.ExtensionsEntry) | repeated | Customized information not inspected by Open Match, to be used by the MatchMakingFunction, evaluator, and components making calls to Open Match. Optional, depending on the requirements of the connected systems. |
| create_time | [google.protobuf.Timestamp](#google.protobuf.Timestamp) |  | Create time is the time the Ticket was created. It is populated by Open Match at the time of Ticket creation. |
| generation | [int64](#int64) |  | Generation gets incremented on GameServers update operations. Prevents the MMF from overriding a newer version from the game server. Do NOT read or write to this field, it is for internal tracking, and changing the value will cause bugs. |






<a name="openmatch.Backfill.ExtensionsEntry"></a>

### Backfill.ExtensionsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [google.protobuf.Any](#google.protobuf.Any) |  |  |






<a name="openmatch.DoubleRangeFilter"></a>

### DoubleRangeFilter
Filters numerical values to only those within a range.
  double_arg: &#34;foo&#34;
  max: 10
  min: 5
matches:
  {&#34;foo&#34;: 5}
  {&#34;foo&#34;: 7.5}
  {&#34;foo&#34;: 10}
does not match:
  {&#34;foo&#34;: 4}
  {&#34;foo&#34;: 10.01}
  {&#34;foo&#34;: &#34;7.5&#34;}
  {}


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| double_arg | [string](#string) |  | Name of the ticket&#39;s search_fields.double_args this Filter operates on. |
| max | [double](#double) |  | Maximum value. |
| min | [double](#double) |  | Minimum value. |
| exclude | [DoubleRangeFilter.Exclude](#openmatch.DoubleRangeFilter.Exclude) |  | Defines the bounds to apply when filtering tickets by their search_fields.double_args value. BETA FEATURE WARNING: This field and the associated values are not finalized and still subject to possible change or removal. |






<a name="openmatch.Match"></a>

### Match
A Match is used to represent a completed match object. It can be generated by
a MatchFunction as a proposal or can be returned by OpenMatch as a result in
response to the FetchMatches call.
When a match is returned by the FetchMatches call, it should contain at least
one ticket to be considered as valid.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| match_id | [string](#string) |  | A Match ID that should be passed through the stack for tracing. |
| match_profile | [string](#string) |  | Name of the match profile that generated this Match. |
| match_function | [string](#string) |  | Name of the match function that generated this Match. |
| tickets | [Ticket](#openmatch.Ticket) | repeated | Tickets belonging to this match. |
| extensions | [Match.ExtensionsEntry](#openmatch.Match.ExtensionsEntry) | repeated | Customized information not inspected by Open Match, to be used by the match making function, evaluator, and components making calls to Open Match. Optional, depending on the requirements of the connected systems. |
| backfill | [Backfill](#openmatch.Backfill) |  | Backfill request which contains additional information to the match and contains an association to a GameServer. BETA FEATURE WARNING: This field is not finalized and still subject to possible change or removal. |
| allocate_gameserver | [bool](#bool) |  | AllocateGameServer signalise Director that Backfill is new and it should allocate a GameServer, this Backfill would be assigned. BETA FEATURE WARNING: This field is not finalized and still subject to possible change or removal. |






<a name="openmatch.Match.ExtensionsEntry"></a>

### Match.ExtensionsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [google.protobuf.Any](#google.protobuf.Any) |  |  |






<a name="openmatch.MatchProfile"></a>

### MatchProfile
A MatchProfile is Open Match&#39;s representation of a Match specification. It is
used to indicate the criteria for selecting players for a match. A
MatchProfile is the input to the API to get matches and is passed to the
MatchFunction. It contains all the information required by the MatchFunction
to generate match proposals.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) |  | Name of this match profile. |
| pools | [Pool](#openmatch.Pool) | repeated | Set of pools to be queried when generating a match for this MatchProfile. |
| extensions | [MatchProfile.ExtensionsEntry](#openmatch.MatchProfile.ExtensionsEntry) | repeated | Customized information not inspected by Open Match, to be used by the match making function, evaluator, and components making calls to Open Match. Optional, depending on the requirements of the connected systems. |






<a name="openmatch.MatchProfile.ExtensionsEntry"></a>

### MatchProfile.ExtensionsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [google.protobuf.Any](#google.protobuf.Any) |  |  |






<a name="openmatch.Pool"></a>

### Pool
Pool specfies a set of criteria that are used to select a subset of Tickets
that meet all the criteria.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| name | [string](#string) |  | A developer-chosen human-readable name for this Pool. |
| double_range_filters | [DoubleRangeFilter](#openmatch.DoubleRangeFilter) | repeated | Set of Filters indicating the filtering criteria. Selected tickets must match every Filter. |
| string_equals_filters | [StringEqualsFilter](#openmatch.StringEqualsFilter) | repeated |  |
| tag_present_filters | [TagPresentFilter](#openmatch.TagPresentFilter) | repeated |  |
| created_before | [google.protobuf.Timestamp](#google.protobuf.Timestamp) |  | If specified, only Tickets created before the specified time are selected. |
| created_after | [google.protobuf.Timestamp](#google.protobuf.Timestamp) |  | If specified, only Tickets created after the specified time are selected. |






<a name="openmatch.SearchFields"></a>

### SearchFields
Search fields are the fields which Open Match is aware of, and can be used
when specifying filters.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| double_args | [SearchFields.DoubleArgsEntry](#openmatch.SearchFields.DoubleArgsEntry) | repeated | Float arguments. Filterable on ranges. |
| string_args | [SearchFields.StringArgsEntry](#openmatch.SearchFields.StringArgsEntry) | repeated | String arguments. Filterable on equality. |
| tags | [string](#string) | repeated | Filterable on presence or absence of given value. |






<a name="openmatch.SearchFields.DoubleArgsEntry"></a>

### SearchFields.DoubleArgsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [double](#double) |  |  |






<a name="openmatch.SearchFields.StringArgsEntry"></a>

### SearchFields.StringArgsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [string](#string) |  |  |






<a name="openmatch.StringEqualsFilter"></a>

### StringEqualsFilter
Filters strings exactly equaling a value.
  string_arg: &#34;foo&#34;
  value: &#34;bar&#34;
matches:
  {&#34;foo&#34;: &#34;bar&#34;}
does not match:
  {&#34;foo&#34;: &#34;baz&#34;}
  {&#34;bar&#34;: &#34;foo&#34;}
  {}


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| string_arg | [string](#string) |  | Name of the ticket&#39;s search_fields.string_args this Filter operates on. |
| value | [string](#string) |  |  |






<a name="openmatch.TagPresentFilter"></a>

### TagPresentFilter
Filters to the tag being present on the search_fields.
  tag: &#34;foo&#34;
matches:
  [&#34;foo&#34;]
  [&#34;bar&#34;,&#34;foo&#34;]
does not match:
  [&#34;bar&#34;]
  []


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| tag | [string](#string) |  |  |






<a name="openmatch.Ticket"></a>

### Ticket
A Ticket is a basic matchmaking entity in Open Match. A Ticket may represent
an individual &#39;Player&#39;, a &#39;Group&#39; of players, or any other concepts unique to
your use case. Open Match will not interpret what the Ticket represents but
just treat it as a matchmaking unit with a set of SearchFields. Open Match
stores the Ticket in state storage and enables an Assignment to be set on the
Ticket.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| id | [string](#string) |  | Id represents an auto-generated Id issued by Open Match. |
| assignment | [Assignment](#openmatch.Assignment) |  | An Assignment represents a game server assignment associated with a Ticket, or whatever finalized matched state means for your use case. Open Match does not require or inspect any fields on Assignment. |
| search_fields | [SearchFields](#openmatch.SearchFields) |  | Search fields are the fields which Open Match is aware of, and can be used when specifying filters. |
| extensions | [Ticket.ExtensionsEntry](#openmatch.Ticket.ExtensionsEntry) | repeated | Customized information not inspected by Open Match, to be used by the match making function, evaluator, and components making calls to Open Match. Optional, depending on the requirements of the connected systems. |
| create_time | [google.protobuf.Timestamp](#google.protobuf.Timestamp) |  | Create time is the time the Ticket was created. It is populated by Open Match at the time of Ticket creation. |






<a name="openmatch.Ticket.ExtensionsEntry"></a>

### Ticket.ExtensionsEntry



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| key | [string](#string) |  |  |
| value | [google.protobuf.Any](#google.protobuf.Any) |  |  |





 


<a name="openmatch.DoubleRangeFilter.Exclude"></a>

### DoubleRangeFilter.Exclude


| Name | Number | Description |
| ---- | ------ | ----------- |
| NONE | 0 | No bounds should be excluded when evaluating the filter, i.e.: MIN &lt;= x &lt;= MAX |
| MIN | 1 | Only the minimum bound should be excluded when evaluating the filter, i.e.: MIN &lt; x &lt;= MAX |
| MAX | 2 | Only the maximum bound should be excluded when evaluating the filter, i.e.: MIN &lt;= x &lt; MAX |
| BOTH | 3 | Both bounds should be excluded when evaluating the filter, i.e.: MIN &lt; x &lt; MAX |


 

 

 



<a name="api/query.proto"></a>
<p align="right"><a href="#top">Top</a></p>

## api/query.proto



<a name="openmatch.QueryBackfillsRequest"></a>

### QueryBackfillsRequest
BETA FEATURE WARNING:  This Request messages are not finalized and 
still subject to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| pool | [Pool](#openmatch.Pool) |  | The Pool representing the set of Filters to be queried. |






<a name="openmatch.QueryBackfillsResponse"></a>

### QueryBackfillsResponse
BETA FEATURE WARNING:  This Request messages are not finalized and 
still subject to possible change or removal.


| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| backfills | [Backfill](#openmatch.Backfill) | repeated | Backfills that meet all the filtering criteria requested by the pool. |






<a name="openmatch.QueryTicketIdsRequest"></a>

### QueryTicketIdsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| pool | [Pool](#openmatch.Pool) |  | The Pool representing the set of Filters to be queried. |






<a name="openmatch.QueryTicketIdsResponse"></a>

### QueryTicketIdsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| ids | [string](#string) | repeated | TicketIDs that meet all the filtering criteria requested by the pool. |






<a name="openmatch.QueryTicketsRequest"></a>

### QueryTicketsRequest



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| pool | [Pool](#openmatch.Pool) |  | The Pool representing the set of Filters to be queried. |






<a name="openmatch.QueryTicketsResponse"></a>

### QueryTicketsResponse



| Field | Type | Label | Description |
| ----- | ---- | ----- | ----------- |
| tickets | [Ticket](#openmatch.Ticket) | repeated | Tickets that meet all the filtering criteria requested by the pool. |





 

 

 


<a name="openmatch.QueryService"></a>

### QueryService
The QueryService service implements helper APIs for Match Function to query Tickets from state storage.

| Method Name | Request Type | Response Type | Description |
| ----------- | ------------ | ------------- | ------------|
| QueryTickets | [QueryTicketsRequest](#openmatch.QueryTicketsRequest) | [QueryTicketsResponse](#openmatch.QueryTicketsResponse) stream | QueryTickets gets a list of Tickets that match all Filters of the input Pool. - If the Pool contains no Filters, QueryTickets will return all Tickets in the state storage. QueryTickets pages the Tickets by `queryPageSize` and stream back responses. - queryPageSize is default to 1000 if not set, and has a minimum of 10 and maximum of 10000. |
| QueryTicketIds | [QueryTicketIdsRequest](#openmatch.QueryTicketIdsRequest) | [QueryTicketIdsResponse](#openmatch.QueryTicketIdsResponse) stream | QueryTicketIds gets the list of TicketIDs that meet all the filtering criteria requested by the pool. - If the Pool contains no Filters, QueryTicketIds will return all TicketIDs in the state storage. QueryTicketIds pages the TicketIDs by `queryPageSize` and stream back responses. - queryPageSize is default to 1000 if not set, and has a minimum of 10 and maximum of 10000. |
| QueryBackfills | [QueryBackfillsRequest](#openmatch.QueryBackfillsRequest) | [QueryBackfillsResponse](#openmatch.QueryBackfillsResponse) stream | QueryBackfills gets a list of Backfills. BETA FEATURE WARNING: This call and the associated Request and Response messages are not finalized and still subject to possible change or removal. |

 



## Scalar Value Types

| .proto Type | Notes | C++ | Java | Python | Go | C# | PHP | Ruby |
| ----------- | ----- | --- | ---- | ------ | -- | -- | --- | ---- |
| <a name="double" /> double |  | double | double | float | float64 | double | float | Float |
| <a name="float" /> float |  | float | float | float | float32 | float | float | Float |
| <a name="int32" /> int32 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint32 instead. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="int64" /> int64 | Uses variable-length encoding. Inefficient for encoding negative numbers – if your field is likely to have negative values, use sint64 instead. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="uint32" /> uint32 | Uses variable-length encoding. | uint32 | int | int/long | uint32 | uint | integer | Bignum or Fixnum (as required) |
| <a name="uint64" /> uint64 | Uses variable-length encoding. | uint64 | long | int/long | uint64 | ulong | integer/string | Bignum or Fixnum (as required) |
| <a name="sint32" /> sint32 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int32s. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="sint64" /> sint64 | Uses variable-length encoding. Signed int value. These more efficiently encode negative numbers than regular int64s. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="fixed32" /> fixed32 | Always four bytes. More efficient than uint32 if values are often greater than 2^28. | uint32 | int | int | uint32 | uint | integer | Bignum or Fixnum (as required) |
| <a name="fixed64" /> fixed64 | Always eight bytes. More efficient than uint64 if values are often greater than 2^56. | uint64 | long | int/long | uint64 | ulong | integer/string | Bignum |
| <a name="sfixed32" /> sfixed32 | Always four bytes. | int32 | int | int | int32 | int | integer | Bignum or Fixnum (as required) |
| <a name="sfixed64" /> sfixed64 | Always eight bytes. | int64 | long | int/long | int64 | long | integer/string | Bignum |
| <a name="bool" /> bool |  | bool | boolean | boolean | bool | bool | boolean | TrueClass/FalseClass |
| <a name="string" /> string | A string must always contain UTF-8 encoded or 7-bit ASCII text. | string | String | str/unicode | string | string | string | String (UTF-8) |
| <a name="bytes" /> bytes | May contain any arbitrary sequence of bytes. | string | ByteString | str | []byte | ByteString | string | String (ASCII-8BIT) |

