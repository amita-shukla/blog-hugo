---
title: Designing REST API for Long Running Jobs
tags:
- SOFTWARE ARCHITECTURE
- REST
cover: skeleton_meme.jpg
author: Amita Shukla
date: '2022-07-06'
slug: rest-api-for-long-running-jobs
type: post
draft: false
---
Consider the case below where we have an API for 'orders'. We want to expose an Order Service for a client to  list all orders, create a new order, or get details for a particular order.

## API Design
So we create a GET endpoint `/orders` to list all orders:
```atom
GET /orders
```
The server responds with:
```atom
200 OK
{"orders" : [
    {"id": 1, "products": ["a", "b", "c"], "amount" : 100},
    {"id": 2, "products": ["b", "f", "x"], "amount" : 200}
]}
```
And to get order details for a particular order:
```atom
GET /orders/2
```
the server responding with:
```atom
200 OK
{"id" : 2, "products" : ["b", "f", "x"], "amount" : 200}
```
For creating an order, we create a POST endpoint which accepts the list of products and total amount for that order:
```atom
POST /orders/
{"products" : ["y", "z"], "amount" : 250}
```
The server gets back to you with:
```atom
201 CREATED
{"id" : 3}
```
To check the result of this order:
```atom
GET /orders/3
```
```atom
200 OK
{"id" : 3, "products" : ["y", "z"], "amount" : 250}
```
## The Case of Long Running Jobs
This is a simple workflow for resources which are trivial to create. But sometimes a lot of work can go into creating a resource, e.g. in our case we would need to access database,  call other services such as a products service, users service, a metadata service and so on. In general, even if it's not about creating a resource per se, a POST request caters to a variety of functions.

<re-img src="skeleton_meme.jpg"></re-img>

### More such Use Cases
- Perform some analytics and generate a report by calculating a number of data points. 
- Scan a pdf, process its contents and save in database.
- Upload multiple files onto server, but before saving combine, resize, format those files.

These all are long running operations that take a lot more time for an HTTP request. Most applications have a standard timeout, and such jobs can easily surpass that time. Also, suppose a client application/ frontend calls this request, then it would need to wait for this call to complete. For such long running operations, it is always a better option that we trigger a background operation that does all the heavy lifting and the current request returns a token which the user can later use to cancel this ongoing request, or come back later to view results.

Let's see how this API would look like:

#### Get List of Orders
```atom
GET /orders/
```
Response:
```atom
200 OK
{"orders" : [
    { "id" : 1, "products" : ["a", "b", "c"], "amount" : 100 }, 
    { "id" : 2, "products" : ["b", "f", "x"], "amount" : 200 }
]}
```
#### Create a new order 
Send a POST request with the body containing order details.
```atom
POST /orders/
{"products" : ["y", "z"], "amount": 250}
```
In response, the creation is accepted (not completed), and the process starts in the background. An automatically generated "id" is assigned to the order.
```atom
202 ACCEPTED
{
    "id" : 3,
}
```
#### Poll For Status
Now this resource creation is a long running process, so you keep polling for the status:
```atom
GET /orders/3/status
```
The response to this call contains the status of the job, such as "started", "running", "cancelled", "completed" or "failed"...
```atom
200 OK
{
    "id" : 3,
    "status" : "running"
}
```
#### Cancel Running Job
If the status is "running", this job can be cancelled:
```atom
DELETE /orders/3/cancel
```
The delete call doesn't delete the resource here, but marks the currently running task pertaining to this id as "cancelled". The backend may decide to try to interrupt the background task, or it may let the task complete but cleanup the result at sometime later. (At this point I feel it would be better I write a separate post about this...)

It also responds with 204 response code, meaning that the call has succeeded but the no-body response is intentional.
```atom
204 NO CONTENT 
```
You can check the status of this cancelled job using the `/status` endpoint:
```atom
GET /orders/3/status
```
```atom
200 OK
{
    "id" : 3,
    "status" : "cancelled"
}
```
#### Get Result for Completed Job
Now, if you really need the results, you can decide to keep polling the status for this job, until it's "complete":
```atom
GET /orders/3/status
```
```atom
200 OK
{
    "id" : 3,
    "status" : "complete"
}
```
If the status is "complete", get the result:
```atom
GET /orders/3/result
```
```atom
200 OK
{
    "id" : 3,
    "products" : ["y", "z"],
    "amount" : 250
}
```

## Conclusion
Just like we have asynchronous calls (AJAX) on the frontend, and like async calls on the backend, we can add one more level of decoupling between the frontend and backend by designing the API this way. We can return more detailed status updates, or progress bars to update the user about the exact stage of the concerned job. I got the chance to work on this feature once, which was a great boost to the user experience of our application. 