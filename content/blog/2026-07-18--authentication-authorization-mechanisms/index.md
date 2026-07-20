---
title: "Authentication and Authorization Explained"
date: '2026-07-18'
tags: 
- SECURITY
type: post
draft: false
slug: authentication-authorization-mechanisms
author: Amita Shukla
showTableOfContents: true
---
You join a new company. On day 1, you're  asked to:

- Log into your laptop using a password.
- Authenticate to the corporate VPN using MFA.
- Sign in to Jira using Microsoft SSO.
- Use an SSH key to access a Linux server.
- Generate a Personal Access Token for GitHub.
- Call a cloud API using an Access Token.

Suddenly you're surrounded by terms like OAuth, OIDC, JWT, Kerberos, LDAP, SAML, API Keys, Service Accounts, Bearer Tokens, and RBAC. They all seem related, yet each serves a different purpose.
This post aims to untangle that vocabulary and show how these pieces fit together.

> This is my first post which has made such a heavy use of AI. I used AI to research and structure this, but I have tried my best to ensure the accuracy of the post. I wanted to use this post as a reference material, hence a bullet point structure. The analogy for each mechanism is my favourite part that I believe really drives home the concepts. Would love your opinion and review!

## Authentication

#### *How do I prove who I am?*

Authentication begins by verifying the identity of the caller. Depending on whether the caller is a human, application, or service, different mechanisms are used to prove identity. Each mechanism has its own strengths, trade-offs, and typical use cases.

### Password

A password is a secret string shared between a user and the authentication system. The user proves their identity by demonstrating knowledge of this secret. It is one of the simplest and oldest way to prove one's identity.
- **How does it work?**
    1. The user enters their username and password.
    2. The server retrieves the stored password hash for that user.
    3. The entered password is hashed using the same algorithm.
    4. If the computed hash matches the stored hash, the user is authenticated.
    5. The server typically creates a session or issues a token so the password doesn't need to be sent again.
- **Pros**
    - Simple and universally supported.
    - Easy to implement.
- **Cons**
    - Vulnerable to phishing, brute-force attacks, and password reuse.
    - Users often choose weak passwords.
    - Requires secure password hashing and storage.
- **Common examples**
    - Website logins
    - Linux login
    - Database authentication
    - Mobile applications
- **Notes**
    - Passwords are usually combined with MFA in modern systems.
    - Passwords are generally transmitted only during login. Subsequent requests use a session or token.

### Kerberos

- **Why does it exist?**
    - To eliminate the need for users to repeatedly send passwords over the network while enabling Single Sign-On (SSO) within trusted enterprise environments.
- **Used for**
    - Authenticating enterprise users and services within trusted networks.
- **What is it?**
    - Kerberos is a network authentication mechanism that uses time-limited tickets issued by a trusted server instead of passwords. Once authenticated, users can access multiple services without repeatedly entering their credentials.
- **How does it work?**
    1. The user logs in by providing their username and password.
    2. The Kerberos Key Distribution Center (KDC) verifies the credentials and issues a **Ticket Granting Ticket (TGT)**.
    3. When the user wants to access a service, they present the TGT to the KDC and request a **Service Ticket**.
    4. The KDC issues a Service Ticket for the requested service.
    5. The user presents the Service Ticket to the service, which verifies it and grants access without asking for the password again.
- **Pros**
    - Passwords are not repeatedly transmitted across the network.
    - Enables Single Sign-On (SSO).
    - Well suited for large enterprise environments.
- **Cons**
    - Requires synchronized system clocks.
    - More complex to deploy than password authentication.
    - Primarily designed for trusted internal networks.
- **Common examples**
    - Windows Active Directory domains
    - Hadoop ecosystem (Hive, HDFS, Impala)
    - Enterprise intranets

### OAuth + OpenID Connect (OIDC)

- **Why does it exist?**
    - To let applications authenticate users through a trusted Identity Provider instead of managing user passwords themselves.
- **Used for**
    - Authenticating human users using third-party identity providers.
- **What is it?**
    - OAuth 2.0 and OpenID Connect (OIDC) work together to enable social login and enterprise Single Sign-On. Users authenticate with an Identity Provider (such as Google or Microsoft), and the application trusts the result.
- **How does it work?**
    1. The application redirects the user to an Identity Provider.
    2. The user authenticates with the Identity Provider.
    3. The Identity Provider asks the user to grant any required permissions.
    4. After successful authentication, the Identity Provider returns an **ID Token** (identity information) and usually an **Access Token**.
    5. The application validates the ID Token and signs the user in.
- **Pros**
    - Applications never handle user passwords.
    - Enables Single Sign-On (SSO).
    - Widely adopted and interoperable.
- **Cons**
    - More complex than password authentication.
    - Requires trust in an external Identity Provider.
    - Can be confusing because OAuth and OIDC serve different purposes.
- **Common examples**
    - Sign in with Google
    - Sign in with Microsoft
    - Sign in with GitHub
    - Enterprise SSO
- **Notes**
    - OAuth 2.0 is an authorization framework, while OIDC adds authentication on top of OAuth.
    - Although often referred to together, they solve different problems. OAuth returns an Access Token (for accessing APIs) while OIDC returns an ID token (for identifying a user).


### SAML

- **Why does it exist?**
    - To allow organizations to provide Single Sign-On across multiple enterprise applications without requiring separate passwords for each application.
- **Used for**
    - Authenticating enterprise users.
- **What is it?**
    - Security Assertion Markup Language (SAML) is an XML-based standard that allows an Identity Provider to authenticate users and send trusted identity information to applications.
- **How does it work?**
    1. A user attempts to access an application.
    2. The application redirects the user to an Identity Provider.
    3. The Identity Provider authenticates the user.
    4. It generates a signed **SAML Assertion** containing the user's identity.
    5. The application verifies the assertion and grants access.
- **Pros**
    - Enables enterprise Single Sign-On.
    - Mature and widely supported.
    - Applications do not need to manage passwords.
- **Cons**
    - XML-based and relatively verbose.
    - More complex than modern web authentication protocols.
    - Less common in newer cloud-native applications.
- **Common examples**
    - Okta
    - Microsoft Entra ID (formerly Azure AD)
    - Corporate web portals
    - Enterprise SaaS applications
- **Notes**
    - SAML and OIDC solve the same problem. SAML is more common in traditional enterprise environments, while OIDC is more common in modern web and mobile applications. SAML uses verbose XML SAML assertion while OIDC uses json or JWTs.

### SSH Keys

- **Why does it exist?**
    - To securely authenticate users without requiring passwords, especially for remote server access.
- **Used for**
    - Authenticating developers and administrators.
- **What is it?**
    - SSH key authentication uses a public-private key pair. The user proves ownership of the private key, while the server verifies it using the corresponding public key.
- **How does it work?**
    1. The user generates a public-private key pair.
    2. The public key is stored on the server.
    3. During login, the server sends a challenge.
    4. The client signs the challenge using the private key.
    5. The server verifies the signature using the public key and grants access.
- **Pros**
    - More secure than passwords.
    - Resistant to brute-force attacks.
    - Convenient for automation.
- **Cons**
    - Private keys must be securely protected.
    - Key management can become difficult at scale.
- **Common examples**
    - SSH login to Linux servers
    - GitHub authentication via SSH
    - CI/CD automation

### Client Certificates

- **Why does it exist?**
    - To strongly authenticate devices and applications using digital certificates instead of shared secrets.
- **Used for**
    - Authenticating applications, devices, and enterprise clients.
- **What is it?**
    - A client certificate is a digital certificate that proves the identity of a client using public key cryptography.
- **How does it work?**
    1. The client presents its certificate during connection establishment.
    2. The server verifies that the certificate is trusted and valid.
    3. The client proves ownership of the corresponding private key.
    4. If verification succeeds, the client is authenticated.
- **Pros**
    - Strong cryptographic authentication.
    - No shared passwords.
    - Difficult to forge.
- **Cons**
    - Certificate lifecycle management can be complex.
    - Requires a Public Key Infrastructure (PKI).
- **Common examples**
    - Mutual TLS
    - Enterprise VPNs
    - Financial systems
    - Internal APIs, microservices 
- **Notes**
    - Client certificates are commonly used as part of **mTLS**, as we will see below.
    - SSH is commonly used where we both control the client and server, whereas Client Certificates are used where many clients and servers need to trust each other without manual intervention. 

### API Keys

- **Why does it exist?**
    - To provide a simple way for applications and scripts to identify themselves when calling an API.
- **Used for**
    - Authenticating applications, scripts, and third-party integrations.
- **What is it?**
    - An API key is a unique secret string issued by an API provider. Clients include it with each request so the server can identify the caller.
- **How does it work?**
    1. The API provider generates a unique API key.
    2. The client stores the key securely.
    3. The client includes the key in every API request (typically in a header or query parameter).
    4. The server verifies the key and associates the request with the corresponding application or account.
    5. If valid, the request is processed.
- **Pros**
    - Simple to generate and use.
    - Easy to integrate with APIs.
    - Suitable for low-risk or internal APIs.
- **Cons**
    - If leaked, anyone possessing the key can use it.
    - Usually identifies the application, not the individual user.
    - Limited support for fine-grained authorization.
- **Common examples**
    - Google Maps API
    - OpenAI API
    - Weather APIs
    - Internal REST APIs
- **Notes**
    - Despite the name, an API key is usually used to identify an application rather than authenticate a human user.
    - Many modern APIs are replacing API keys with OAuth-based authentication for improved security.

### Service Accounts

- **Why does it exist?**
    - Applications and automated workloads need identities just like human users, but they cannot log in interactively.
- **Used for**
    - Authenticating applications, services, containers, and automated workloads.
- **What is it?**
    - A service account is a non-human identity created specifically for applications or services. It allows software to authenticate and access resources securely.
- **How does it work?**
    1. An administrator creates a service account.
    2. Credentials (such as a key, certificate, or token) are associated with the account.
    3. The application presents these credentials when communicating with other services.
    4. The receiving service authenticates the service account.
    5. Authorization policies determine what the service account can access.
- **Pros**
    - Separates machine identities from human users.
    - Enables secure automation.
    - Supports fine-grained permissions.
- **Cons**
    - Long-lived credentials must be carefully managed.
    - Compromised service accounts can expose critical infrastructure.
    - Permission sprawl can occur if not regularly reviewed.
- **Common examples**
    - Kubernetes Service Accounts
    - Google Cloud Service Accounts
    - AWS IAM Roles for workloads
    - CI/CD pipelines
- **Notes**
    - Service accounts are identities, not credentials. They often authenticate using tokens, certificates, or key pairs.

### Mutual TLS (mTLS)

- **Why does it exist?**
    - To allow both the client and server to verify each other's identity before exchanging data.
- **Used for**
    - Authenticating services, applications, and devices.
- **What is it?**
    - Mutual TLS extends standard TLS by requiring both the client and the server to present and validate digital certificates.
- **How does it work?**
    1. The client initiates a TLS connection.
    2. The server presents its certificate.
    3. The client verifies the server's certificate.
    4. The server requests the client's certificate.
    5. After both certificates are verified, a secure connection is established.
- **Pros**
    - Strong mutual authentication.
    - Resistant to impersonation attacks.
    - Provides encrypted communication.
- **Cons**
    - Certificate management can be complex.
    - Requires a Public Key Infrastructure (PKI).
- **Common examples**
    - Service meshes (Istio, Linkerd)
    - Banking systems
    - Internal microservices
    - Kubernetes control plane
- **Notes**
    - TLS encrypts communication. mTLS adds authentication in both directions, ensuring both parties can trust each other's identity.

## Identity Stores & Authentication Infrastructure

#### *Where are identities stored and managed?*

Authentication mechanisms rely on supporting infrastructure to store users, groups, passwords, certificates, and other identity information. These systems act as the source of truth that applications consult while authenticating users and services.

### LDAP

- **Why does it exist?**
    - To provide a centralized place for storing and managing user identities instead of maintaining separate user databases for every application.
- **Used for**
    - Managing enterprise users, groups, and organizational information.
- **What is it?**
    - LDAP (Lightweight Directory Access Protocol) is a protocol for accessing and managing directory services. It allows applications to look up users, groups, passwords, and other identity-related information.
- **How does it work?**
    1. User and group information is stored in a directory.
    2. An application connects to the LDAP server.
    3. The application searches for a user or validates their credentials.
    4. LDAP returns the requested identity information.
    5. The application decides whether to authenticate the user.
- **Pros**
    - Centralized identity management.
    - Reduces duplicate user databases.
    - Supported by most enterprise software.
- **Cons**
    - Requires dedicated infrastructure.
    - Doesn't provide Single Sign-On by itself.
- **Common examples**
    - Corporate employee directories
    - Enterprise applications
    - Linux authentication
    - Email systems
- **Notes**
    - LDAP stores identity information—it is **not** an authentication mechanism by itself.

### Active Directory

- **Why does it exist?**
    - To centrally manage users, computers, groups, and security policies in Windows-based organizations.
- **Used for**
    - Managing enterprise identities and Windows domains.
- **What is it?**
    - Active Directory (AD) is Microsoft's directory service. It stores identities and integrates with technologies like Kerberos, Group Policy, and LDAP to provide centralized authentication and management.
- **How does it work?**
    1. Administrators create users, computers, and groups in Active Directory.
    2. Devices join the Active Directory domain.
    3. Authentication requests are handled using Kerberos (or sometimes NTLM).
    4. Applications query Active Directory for identity and group information.
- **Pros**
    - Centralized identity management.
    - Deep integration with Windows.
    - Supports Single Sign-On across enterprise resources.
- **Cons**
    - Primarily designed for Windows environments.
    - Requires domain infrastructure and administration.
- **Common examples**
    - Corporate Windows laptops
    - Microsoft enterprise environments
    - Office networks
- **Notes**
    - Active Directory is built on multiple technologies, including LDAP and Kerberos.

### Kerberos Key Distribution Center (KDC)

- **Why does it exist?**
    - To act as the trusted authority that issues Kerberos tickets.
- **Used for**
    - Supporting Kerberos authentication.
- **What is it?**
    - The KDC is the central server in a Kerberos environment. It verifies identities and issues Ticket Granting Tickets (TGTs) and Service Tickets.
- **How does it work?**
    1. A user authenticates with the KDC.
    2. The KDC verifies the user's credentials.
    3. It issues a Ticket Granting Ticket (TGT).
    4. Later, it exchanges the TGT for Service Tickets that can be presented to applications.
- **Pros**
    - Centralized trust.
    - Enables Single Sign-On.
    - Passwords are not repeatedly sent to services.
- **Cons**
    - Becomes a critical component of the authentication infrastructure.
    - Requires high availability and time synchronization.
- **Common examples**
    - Windows Active Directory
    - Hadoop clusters
    - Enterprise networks
- **Notes**
    - Every Kerberos environment has one or more KDCs.

## Authentication Artifacts

#### *What do I receive after successfully authenticating?*

Once you've successfully authenticated, systems rarely ask you to prove your identity again on every request. Instead, they issue a temporary credential or artifact that can be presented to other services. These credentials are typically time-limited and may also carry authorization information.

### Sessions & Cookies

- **Why does it exist?**
    - To avoid asking users to authenticate on every HTTP request.
- **Used for**
    - Maintaining authenticated user sessions in web applications.
- **What is it?**
    - A session stores authentication information on the server, while a session cookie stores only a unique session identifier in the user's browser.
- **How does it work?**
    1. The user successfully logs in.
    2. The server creates a session and stores it.
    3. The server sends a session cookie containing the session ID.
    4. The browser automatically includes the cookie in future requests.
    5. The server looks up the session and recognizes the user.
- **Pros**
    - Simple and secure.
    - Session data remains on the server.
    - Easy to revoke.
- **Cons**
    - Requires server-side session storage.
    - Doesn't scale as easily across multiple servers without shared session storage.
- **Common examples**
    - Traditional web applications
    - Banking websites
    - E-commerce websites
- **Notes**
    - Cookies are not the session itself—they simply contain the session identifier.

### Bearer Tokens

- **Why does it exist?**
    - To allow clients to prove they've already authenticated without maintaining server-side sessions.
- **Used for**
    - Authenticating API requests.
- **What is it?**
    - A Bearer Token is a token that grants access simply by being presented. Whoever possesses the token can use it.
- **How does it work?**
    1. The client obtains a token after authentication.
    2. The client sends the token in the `Authorization: Bearer <token>` header.
    3. The server validates the token.
    4. If valid, the request is processed.
- **Pros**
    - Stateless.
    - Well suited for APIs.
    - Easy to use across distributed systems.
- **Cons**
    - Anyone possessing the token can use it.
    - Must always be transmitted over HTTPS.
- **Common examples**
    - REST APIs
    - Mobile applications
    - Microservices
- **Notes**
    - **Bearer** describes **how a token is used**, not what the token contains. A Bearer Token is often a JWT, but it doesn't have to be.


### Access Tokens

- **Why does it exist?**
    - To provide temporary permission to access protected resources.
- **Used for**
    - Accessing APIs after successful authentication.
- **What is it?**
    - An Access Token is a credential issued after authentication that allows a client to access specific resources for a limited period.
- **How does it work?**
    1. The client authenticates.
    2. The Authorization Server issues an Access Token.
    3. The client includes the token with API requests.
    4. The API validates the token before serving the request.
- **Pros**
    - Short-lived and more secure than long-lived credentials.
    - Can carry permissions (scopes or claims).
- **Cons**
    - Expires after a short time.
    - Must be securely stored.
- **Common examples**
    - OAuth 2.0
    - Google APIs
    - Microsoft Graph
    - Kubernetes APIs
- **Notes**
    - An Access Token is often sent as a Bearer Token and is frequently represented as a JWT.

### Refresh Tokens

- **Why does it exist?**
    - To let users remain signed in without repeatedly entering their credentials.
- **Used for**
    - Obtaining new Access Tokens.
- **What is it?**
    - A Refresh Token is a long-lived credential that can be exchanged for a new Access Token when the current one expires.
- **How does it work?**
    1. The user authenticates.
    2. The Authorization Server issues both an Access Token and a Refresh Token.
    3. When the Access Token expires, the client sends the Refresh Token.
    4. The Authorization Server validates it and issues a new Access Token.
- **Pros**
    - Improves user experience.
    - Reduces the need for repeated logins.
- **Cons**
    - More sensitive than Access Tokens.
    - Must be carefully protected.
- **Common examples**
    - Mobile applications
    - Single Page Applications (SPAs)
    - Long-running user sessions
- **Notes**
    - Refresh Tokens are not sent with every API request. They are only used to obtain new Access Tokens.

### JSON Web Tokens (JWT)

- **Why does it exist?**
    - To allow identity and authorization information to be securely shared between systems in a compact, self-contained format.
- **Used for**
    - Representing identity and authorization information.
- **What is it?**
    - A JWT (JSON Web Token) is a compact, digitally signed token format containing claims about a user or service.
- **How does it work?**
    1. The issuer creates a JSON payload containing claims.
    2. The payload is digitally signed.
    3. The token is sent to the client.
    4. The receiving service verifies the signature before trusting the claims.
- **Pros**
    - Stateless.
    - Compact and easy to transmit.
    - Can be verified without contacting the issuer.
- **Cons**
    - Revocation can be difficult before expiration.
    - Should not contain sensitive information unless encrypted.
- **Common examples**
    - OAuth Access Tokens
    - OpenID Connect ID Tokens
    - Kubernetes Service Account Tokens
- **Notes**
    - JWT is a **token format**, not an authentication protocol or authentication mechanism.

### Personal Access Tokens (PATs)

- **Why does it exist?**
    - To allow developers to authenticate to APIs without using their account password.
- **Used for**
    - Authenticating developers and automation tools.
- **What is it?**
    - A Personal Access Token is a long-lived token generated by a user that acts as an alternative to their password for API access.
- **How does it work?**
    1. The user generates a PAT from an application.
    2. The application stores the token securely.
    3. The token is included with API requests.
    4. The server validates the token and applies the user's permissions.
- **Pros**
    - Safer than sharing passwords.
    - Can often be scoped to specific permissions.
    - Easy to revoke independently of the user account.
- **Cons**
    - Long-lived tokens require careful management.
    - A leaked PAT can be abused until revoked or expired.
- **Common examples**
    - GitHub
    - GitLab
    - Azure DevOps
    - Atlassian APIs
- **Notes**
    - Many platforms are replacing passwords with PATs for command-line tools and API access because they are easier to manage and can be individually revoked.


## A Simple Analogy to Understand Authentication

Let's imagine a security guard standing at the entrance of a building. Different authentication mechanisms answer this question in different ways.

### Password

**"Tell me the secret that only you should know."**

The security guard asks for a secret password. If the password matches what's on record, you're allowed inside.

### Kerberos

**"Show me the visitor pass issued by the reception desk."**

Instead of asking for your password at every office, you first visit reception. After verifying your identity, reception gives you a visitor pass. Every office in the building trusts that pass because they trust the reception desk.

### OAuth + OpenID Connect (OIDC)

**"Bring someone I already trust to introduce you."**

Rather than proving your identity directly, you ask a trusted organization—such as Google or Microsoft—to vouch for you. Once they confirm your identity, the application accepts their introduction and signs you in.

### SSH Keys

**"Prove that you own the private key."**

The guard already has a sample of your handwriting that is uniquely yours. To prove your identity, you're asked to write a random sentence. If the handwriting matches, the guard knows you're the legitimate owner.

### Client Certificates

**"Show me an identity card issued by an authority I trust."**

Instead of manually registering everyone, the building trusts identity cards issued by a recognized authority. The guard doesn't need to know you personally—they simply verify that your certificate was issued by a trusted Certificate Authority.

### API Keys

**"Show me your membership card."**

You present your membership card when you enter the building. The receptionist checks that it's valid and associates it with your membership. Anyone having a membership card can enter. Your own identity is not verified.

### Service Accounts

**"You're not human but a robot."**

Some visitors aren't humans at all. They are trusted machines performing automated work. Instead of human credentials, they use machine identities known as Service Accounts.

### Mutual TLS (mTLS)

**"I'll show you my identity card if you show me yours."**

In highly secure environments, it's not enough for only one side to prove its identity. You should trust the guard before presenting them your identity. Before entering, both you and the security guard exchange trusted identity cards. Only after both identities are verified does communication begin. This is how services securely authenticate each other using mutual TLS.

## Authorization

#### *Now that I know who you are, what are you allowed to do?*

Authentication verifies **who you are**. Authorization determines **what you're allowed to do**. After a user or service has been authenticated, the system evaluates roles, permissions, attributes, or policies before granting access to a resource.

### Role-Based Access Control (RBAC)

- **Why does it exist?**
    - To simplify permission management by assigning permissions to roles instead of individual users.
- **Used for**
    - Managing permissions for users and services.
- **What is it?**
    - RBAC groups permissions into roles (such as *Admin*, *Developer*, or *Viewer*). Users are assigned roles, and roles determine what they can access.
- **How does it work?**
    1. Administrators define roles.
    2. Permissions are assigned to each role.
    3. Users or services are assigned one or more roles.
    4. During authorization, the system checks the caller's roles before granting access.
- **Pros**
    - Easy to understand.
    - Scales well for large organizations.
    - Centralizes permission management.
- **Cons**
    - Too many roles can become difficult to manage.
    - Less flexible for complex access rules.
- **Common examples**
    - Kubernetes RBAC
    - AWS IAM
    - GitHub organizations
    - Enterprise applications
- **Notes**
    - RBAC is the most widely used authorization model.

### Attribute-Based Access Control (ABAC)

- **Why does it exist?**
    - To support fine-grained access decisions based on characteristics of the user, resource, or environment.
- **Used for**
    - Dynamic authorization.
- **What is it?**
    - ABAC grants or denies access by evaluating attributes rather than predefined roles.
- **How does it work?**
    1. The system gathers attributes about the user, resource, and request.
    2. Policies evaluate these attributes.
    3. Access is granted only if the policy conditions are satisfied.
- **Pros**
    - Highly flexible.
    - Supports complex authorization rules.
- **Cons**
    - More difficult to design and maintain.
    - Policies can become complex.
- **Common examples**
    - Cloud IAM
    - Healthcare systems
    - Government applications
- **Notes**
    - Example: *Allow access only if the user's department is Finance and the request originates from the corporate network.*

### Policy-Based Access Control (PBAC)

- **Why does it exist?**
    - To separate authorization logic from application code.
- **Used for**
    - Centralized policy enforcement.
- **What is it?**
    - PBAC uses explicit policies to determine whether access should be granted.
- **How does it work?**
    1. Policies are defined centrally.
    2. A request is evaluated against these policies.
    3. The policy engine returns an allow or deny decision.
- **Pros**
    - Centralized authorization.
    - Easy to update policies without changing application code.
- **Cons**
    - Requires a policy engine.
    - Can increase operational complexity.
- **Common examples**
    - Open Policy Agent (OPA)
    - Kubernetes Gatekeeper
    - Enterprise authorization systems
- **Notes**
    - ABAC is often implemented using a policy engine, making the two concepts closely related.

### Access Control Lists (ACLs)

- **Why does it exist?**
    - To specify exactly which users or groups can access a particular resource.
- **Used for**
    - Resource-level authorization.
- **What is it?**
    - An ACL is a list attached to a resource that specifies who can perform which actions on it.
- **How does it work?**
    1. Each resource maintains an access list.
    2. A request arrives.
    3. The system checks whether the caller appears in the ACL.
    4. Access is granted or denied accordingly.
- **Pros**
    - Fine-grained control.
    - Easy to understand for individual resources.
- **Cons**
    - Difficult to manage at large scale.
    - Permissions become scattered across resources.
- **Common examples**
    - Linux file permissions
    - Windows file sharing
    - Amazon S3 bucket ACLs
- **Notes**
    - ACLs focus on **resources**, whereas RBAC focuses on **users and roles**.


### OAuth Scopes

- **Why does it exist?**
    - To limit what an application can access on behalf of a user.
- **Used for**
    - Restricting API permissions.
- **What is it?**
    - Scopes define the specific permissions granted to an Access Token.
- **How does it work?**
    1. The application requests one or more scopes.
    2. The user approves the requested permissions.
    3. The issued Access Token contains those scopes.
    4. APIs check the scopes before serving the request.
- **Pros**
    - Fine-grained API permissions.
    - Supports the principle of least privilege.
- **Cons**
    - Poorly designed scopes can become difficult to manage.
- **Common examples**
    - Google Drive API
    - Microsoft Graph
    - GitHub API
- **Notes**
    - A user may be an administrator, but if the Access Token lacks the required scope, the API request can still be denied.


### Claims-Based Authorization

- **Why does it exist?**
    - To allow authorization decisions based on information carried inside tokens.
- **Used for**
    - Modern web applications and APIs.
- **What is it?**
    - Instead of looking up permissions in a database for every request, applications evaluate claims contained in a token, such as the user's role, department, or subscription level.
- **How does it work?**
    1. The Identity Provider issues a token containing claims.
    2. The application validates the token.
    3. The application reads the claims.
    4. Access decisions are made using those claims.
- **Pros**
    - Fast and stateless.
    - Well suited for distributed systems.
- **Cons**
    - Claims remain valid until the token expires.
    - Changes to permissions may not take effect immediately.
- **Common examples**
    - JWT-based applications
    - OpenID Connect
    - ASP.NET Identity
- **Notes**
    - Claims describe **who the user is** (for example, `role=admin` or `department=finance`). Applications use these claims to make authorization decisions.

## Putting It All Together

Modern authentication systems rarely rely on a single technology. Instead, they combine authentication mechanisms, identity stores, protocols, credentials, and authorization models to provide secure access. Here are a few common examples.

### Example 1: Traditional Website Login
```text
User
   │
Username + Password
   │
Authentication Server
   │
Session Created
   │
Session Cookie
   │
RBAC / ACL
   │
Application
```

- The user authenticates using a **password**.
- The server validates the password against its user store.
- A **session** is created and identified using a **session cookie**.
- The application uses **RBAC** or **ACLs** to determine what the user can access.

### Example 2: Sign in with Google
```text
User
   │
OAuth + OIDC
   │
Google Identity Provider
   │
ID Token + Access Token
   │
Application
   │
Claims / Roles
```
- The user authenticates with **Google** instead of the application.
- **OIDC** proves the user's identity.
- **OAuth 2.0** provides an **Access Token** for API access.
- The application authorizes the user using **claims**, **roles**, or both.

### Example 3: Enterprise Login
```text
Employee
    │
Kerberos
    │
Active Directory + KDC
    │
Service Ticket
    │
Enterprise Application
    │
RBAC
```
- The employee authenticates once using **Kerberos**.
- The **KDC** issues a **Kerberos ticket**.
- The ticket enables **Single Sign-On** across enterprise applications.
- Access is controlled using **RBAC** or **ACLs**.

### Example 4: Microservice-to-Microservice Communication
```text
Service A
    │
mTLS
    │
OAuth Client Credentials
    │
Access Token (JWT)
    │
Service B
```
- **mTLS** allows both services to verify each other's identity.
- **OAuth Client Credentials** obtains an **Access Token**.
- The token (often a **JWT**) is sent as a **Bearer Token**.
- Service B authorizes the request using **claims** or **scopes**.

### Example 5: Kubernetes
```text
Pod
 │
Service Account
 │
JWT
 │
Kubernetes API Server
 │
RBAC
```
- Each Pod runs using a **Service Account**.
- Kubernetes issues a **JWT** representing that Service Account.
- The API server authenticates the Service Account.
- **RBAC** determines what the Pod is allowed to do.

### Example 6: GitHub API

```
Developer
     │
Personal Access Token
     │
GitHub API
```

- The developer generates a **Personal Access Token (PAT)**.
- The PAT is sent with API requests.
- GitHub authenticates the token.
- The token's permissions determine which operations are allowed.

Authentication and authorization are vast topics, but as software engineers, what matters is understanding the role each technology plays—whether it's verifying identity, storing user information, issuing credentials, or controlling access to resources. With this mental model,I hope terms like OAuth, OIDC, Kerberos, JWT, LDAP, and RBAC become much less intimidating, making it easier to design, integrate, and troubleshoot secure applications in your day-to-day work.