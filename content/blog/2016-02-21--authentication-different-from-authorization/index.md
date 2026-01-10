---
title: How is Authentication different from Authorization?
tags: []
author: Amita Shukla
date: '2016-02-21'
slug: authentication-different-from-authorization
type: post
draft: false
showTableOfContents: true
---
We all hear the words 'authentication' and 'authorization' frequently. However, many a times these words are used interchangeably. This post discusses the difference between the two. 


 


### Authentication

Authentication means verifying the identity of the user. The process of logging in somewhere using your username and password is called Authentication. The user name, and the password are checked against an entry in the database and the user is verified. It is then the user is allowed to enter into his login space.

 


### Authorization

Authorization is basically based on access rules. There may be some resources that are accessible to you depending upon the role you play. You can be an anonymous user, a registered user, admin etc. Depending upon your role, you may or may not access resources.

 


We can infer that authentication leads to authorization. Once a user logs in and verifies who he is, it is decided what he is allowed to do.

 


