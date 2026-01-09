---
title: Rate Limter v/s Circuit Breaker in Microservices
tags:
- SOFTWARE ARCHITECTURE
author: Amita Shukla
date: '2022-07-09'
slug: rate-limiter-vs-circuit-breeaker
type: post
draft: false
---
A Rate Limiter is a pattern put in place for a service to protect itself from too many calls. A resource-intensive service is always in danger of overloading if triggered multiple times, or it may end up calling other resource-intensive services, bringing the whole system down. If such a service is exposed directly to clients, it is susceptible to DDOS attacks as well. Another use case is that we may want to limit the user to call a request depending on the Pricing Plan they are subscribed to, e.g. a user can be restricted to call a service only ‘n’ times a day depending upon what plan they’ve chosen. All further calls are rejected.

A Circuit Breaker is a pattern put in place for a service to protect itself from calling too many unresponsive services. If a service is unresponsive, it makes sense to not overload it further by retrying it. If a service I am attempting to call repeatedly fails, the circuit ‘breaks’ and I return a default response for some time. After a wait duration only I attempt to call the failing service.

**Note that, a rate limiter is applied on the service being called (or the *callee*) by other services while a circuit breaker is implemented on the service calling other services (or the *caller*).**
