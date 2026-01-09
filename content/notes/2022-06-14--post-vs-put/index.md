---
title: REST - POST v/s PUT
tags:
- PROGRAMMING
- REST
author: Amita Shukla
date: '2022-06-14'
slug: post-vs-put
type: post
draft: false
---
Both POST and PUT requests are used to create a resource. The main difference is that a PUT request is **idempotent** whereas a POST request is not. This means, if I trigger the same POST request multiple times, that resource gets created multiple times. This is not safe. Whereas, if I trigger a PUT request multiple times, only the first time that resource gets created, other times an update is made to the same resource.

## Response Codes
When a resource gets created successfully, wheather through POST or PUT, we can send a 201 CREATED response. 

When calling the same PUT request multiple times, the resource will not be created except the first time. We can send the response 200 (OK). We can also decide to send back 409 (CONFLICT). Keeping in mind that PUT is idempotent, I prefer to send a 2xx response, indicating that even though the resource did not get created, the request is not considered 'failed'.