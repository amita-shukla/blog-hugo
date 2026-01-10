---
title: CORS
date: '2025-09-08'
tags:
- SECURITY
- FRONTEND
- JAVASCRIPT
draft: false
type: post
slug: cors
author: Amita Shukla
---
Whether we're building public APIs, internal tools, or just calling third-party services — understanding and configuring CORS correctly is part of responsible development. Cross-Origin Resource Sharing is a security feature implemented by browsers to restrict how resources are shared between different origins. For example, if site A (hosted on origin a.com) wants to make a direct request to site B (hosted on origin b.com), browsers do not allow that by default. CORS is a way to relax this policy safely.

## What is an Origin
An origin is defined by:
- Protocol (`http` or `https`)
- Domain (`example.com`)
- Port (e.g., 3000)

So, these are different origins:
- `http://example.com`
- `https://example.com`
- `http://api.example.com`
- `http://example.com:3000`

##  Why CORS exists
This is because browsers implement **Same Origin Policy**, which prevents javascript running on one origin from accessing resources on another origin. But there are a number of reasons that a browser may need to make a request to another origin. For a successful cross-origin request, the server needs to respond allowing this. We will see how this happens [later](#how-cors-works), we first need to understand why cross-origin requests are blocked in the first place:
#### 1. Prevent Malicious Websites from Stealing Data
If any website could freely read data from any other domain, a malicious site could:
- Read private info from your bank or email sites while you're logged in.
- Steal your authentication tokens, cookies, or sensitive information.
Blocking cross-origin requests by default prevents this kind of data theft.
#### 2. Stop Cross-Site Request Forgery (CSRF) Attacks
Without restrictions, a malicious site could make requests to another site on our behalf (using our logged-in session) and perform unwanted actions like changing password or making purchases. The browser blocking cross-origin JavaScript access reduces the risk of these attacks.
#### 3. Maintain User Privacy
Cross-origin restrictions limit what a website can learn about our browsing habits and what other sites we visit.
#### 4. Prevent Unintended Interactions
Without these restrictions, scripts from one site could interfere with or manipulate content from another site, causing unexpected or harmful behavior.

## Cross Origin Usecases
Let's understand a few scenarios where a cross-origin request might be required:
### 1. Frontend Website to API Server
The frontend and backend are hosted on different domains, which is often the case.
- Website: `https://www.example.com`
- Backend: `https://api.example.com`
The frontend Javascript fetches data from the api:
```js
fetch('https://api.example.com')
```
### 2. Single Page Application (SPA) with separate Backend
A Single Page Application might be hosted from a CDN domain (like `https://myapp.cdn.net`), but backend lives on a different domain (`https://backend.myapp.com`). 
### 3. Third Party Widgets / Services
A lot of times a frontend embeds third-party services like:
- Google Maps API
- Login and Share Buttons
- Payment Gateways
Third parties handle CORS in different ways depending on the service they offer.
- For APIs like Google Maps API, weather APIs, Crypto Price APIs, CDN hosted assets: They allow all origins as the data is public and read-only.
- For Services that require authentication in the form of API keys, tokens, cookies, e.g. Firebase, auth APIs. They do not allow all origins. We need to whitelist our origin in account settings, or they dynamically authenticate using key/token and then allow the origin.
- If the service provides an Embed script, e.g. youtube. For these services, you don't directly call their API using `fetch()` so CORS doesn't apply here. Instead, the frontend embeds a `<script>` or an `<iframe>`. The js script part of the embed handles it by itself.
### 4. Microservice Architecture
In a microservices architecture, different services run on different domains or ports and need to communicate. e.g. frontend on `https://console.company.com` calls multiple microservices `https://auth.company.com`, `https://data.company.com` 
### 5. CDN serving static assets
The website is hosted on `https://app.example.com` but static assets such as images, fonts, scripts are served from a CDN at `https://cdn.example.com`.
### 6. Fonts
Web fonts are often loaded from a different origin (e.g., Google Fonts).

## How CORS Works
When our frontend, say `https://console.company.com` makes a request to another origin, say `https://api.company.com`, the browser:
1. Sends a preflight request (for some request types) using `OPTIONS` method. (Read more about `OPTIONS` [here](https://amitashukla.in/note/options))
2. The server now responds with specific CORS headers, like:
```http
Access-Control-Allow-Origin: http://localhost:3000
Access-Control-Allow-Methods: GET, POST
Access-Control-Allow-Headers: Content-Type
```
If the headers are missing or incorrect, the browser blocks the response (even though the request reaches the server).
Now, to handle this, a server needs to be aware if it is expected to handle cross-origin requests. In this case, it needs to explicitly *whitelist* the origin by:
- Detecting and responding to `OPTIONS` requests,
- Returning the correct CORS headers, and
- Usually return a `204 No Content` status.
  
Here's how a backend service implemented in Spring handles requests from `https://frontend.company.com`:
### Using `@CrossOrigin` annotation on Controller or the Method:
```java
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyController {

    @CrossOrigin(origins = "https://frontend.company.com")
    @GetMapping("/api/data")
    public String getData() {
        return "Hello from backend";
    }
}
```
### Global CORS configuration (recommended for APIs):
Define a global CORS policy in a `Configuration` class:
```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                        .allowedOrigins("https://frontend.company.com")
                        .allowedMethods("GET", "POST", "PUT", "DELETE")
                        .allowedHeaders("*")
                        .allowCredentials(true);
            }
        };
    }
}
```
Remember, we do not redirect the request ourselves — the request goes straight to `https://api.company.com`, but the backend must explicitly allow frontend in its CORS response headers.

## When CORS Fails
We may see a CORS issue, like: `Access to fetch at 'https://api.example.com' from origin 'https://frontend.example.com' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource.`. Before handling CORS, pause and think, *"Should this request be made from server itself?"*. A backend needs to handle a request if:
- the third-party API doesn’t allow the frontend’s origin.
- API requires secret credentials, like an API key or token.
- The data being fetched is user-specific or sensitive.
- You want to cache, transform, or sanitize the response before sending it to the frontend.
- You need to aggregate data from multiple sources.
This keeps the sensitive secrets out of the client, and gives more control over rate-limiting, error handling and logging.

Now that we're sure the request is being made from where it is meant to be, let's move on to further analysis. 

When a CORS request fails, it’s usually not because the request didn't reach the server — it’s because the browser refused to deliver the response to your JavaScript due to a missing or incorrect CORS header. Check the network tab: it may show the request went out and the response came back — but the browser flagged it as blocked.
### Possible Causes:
- The server didn’t respond with `Access-Control-Allow-Origin`, or responded with the wrong origin.
- The frontend sent a preflight `OPTIONS` request, and the server didn’t respond properly.
- We tried to send credentials (like cookies or Authorization headers), but the server didn’t include `Access-Control-Allow-Credentials: true`.
CORS errors are browser-level blocks, so you won’t see them in the backend logs unless you log OPTIONS requests.

It’s easy to think of CORS as a roadblock, especially when we’re just trying to connect our frontend to an API. But in reality, CORS is a protective layer that prevents malicious websites from secretly making requests on behalf of your users without their knowledge. It’s not just a frontend issue or a backend task — it’s a collaboration between both, enforced by the browser to keep the web safe.
