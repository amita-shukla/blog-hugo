---
title: OPTIONS HTTP Method
tags:
- REST
author: Amita Shukla
date: '2025-09-08'
slug: options
type: post
draft: false
---
The HTTP OPTIONS method is a request used to inquire about the communication options available for a specific resource or the entire server. It's primarily used for diagnostic purposes, allowing clients to determine which HTTP methods are supported and potentially other CORS (Cross-Origin Resource Sharing) headers.

### When is `OPTIONS` used?

#### 1. CORS Preflight Request
When a browser makes a cross-origin request that:
* Uses non-simple HTTP methods (like `PUT`, `DELETE`, or custom methods),
* Includes custom headers (like `Authorization`, `X-Auth-Token`),
* Uses a `Content-Type` other than `application/x-www-form-urlencoded`, `multipart/form-data`, or `text/plain`,

…it first sends an `OPTIONS` request to the target server to *ask for permission*. e.g.,

Browser sends:
```http
OPTIONS /api/data HTTP/1.1
Origin: http://localhost:3000
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type
```

Server replies:
```http
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Methods: POST, GET
Access-Control-Allow-Headers: Content-Type
```
If the browser receives a valid response, it proceeds with the actual request (`POST`, in this case).

#### 2. Method Discovery

We can also use `OPTIONS` manually (e.g., with `curl`) to ask which methods are supported for a given URL:
```bash
curl -X OPTIONS -i https://example.com/api/resource
```
The response may include:
```http
Allow: GET, POST, OPTIONS
```

### Server-side Handling

If we're building an API, we typically:
* Detect and respond to `OPTIONS` requests,
* Return the correct CORS headers, and
* Usually return a 204 No Content status.