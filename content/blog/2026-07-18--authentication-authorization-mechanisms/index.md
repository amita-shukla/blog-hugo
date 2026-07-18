---
title: "Authentication and Authorisation Mechanisms"
date: '2026-07-18'
tags: 
- SECURITY
type: post
draft: true
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

# Identity Verification Mechanisms

### *How do I prove who I am?*

Authentication begins by verifying the identity of the caller. Depending on whether the caller is a human, application, or service, different mechanisms are used to prove identity. Each mechanism has its own strengths, trade-offs, and typical use cases.

## Password

- **Why does it exist?**
    - To provide a simple way for a user to prove their identity using a secret known only to them and the authentication server.
- **Used for**
    - Human authentication.
- **What is it?**
    - A password is a secret string shared between a user and the authentication system. The user proves their identity by demonstrating knowledge of this secret.
- **How does it work?**
    1. The user enters their username and password.
    2. The server retrieves the stored password hash for that user.
    3. The entered password is hashed using the same algorithm.
    4. If the computed hash matches the stored hash, the user is authenticated.
    5. The server typically creates a session or issues a token so the password doesn't need to be sent again.
- **Pros**
    - Simple and universally supported.
    - Easy to implement.
    - No additional infrastructure required.
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

## Kerberos

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
- **Notes**
    - Kerberos uses **tickets**, not tokens.
    - The KDC acts as the trusted authority that issues these tickets.
## OAuth + OpenID Connect (OIDC)

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
    - OAuth 2.0 is an authorization framework, while **OIDC adds authentication** on top of OAuth.
    - Although often referred to together, they solve different problems.
## SAML

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
    - SAML and OIDC solve similar problems. SAML is more common in traditional enterprise environments, while OIDC is more common in modern web and mobile applications.
## SSH Keys

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
- **Notes**
    - The private key never leaves the client's machine.
## Client Certificates

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
    - Internal APIs
- **Notes**
    - Client certificates are commonly used as part of **mTLS**, which you'll see below in the Authentication Protocols section.
## API Keys

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
## Service Accounts

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

## Mutual TLS (mTLS)

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
    - TLS encrypts communication. **mTLS adds authentication in both directions**, ensuring both parties can trust each other's identity.

# Identity Stores & Authentication Infrastructure

### Where are identities stored and managed?

Authentication mechanisms rely on supporting infrastructure to store users, groups, passwords, certificates, and other identity information. These systems act as the source of truth that applications consult while authenticating users and services.

## LDAP

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

## Active Directory

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

## Kerberos Key Distribution Center (KDC)

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

