---
title: Decomposition Rules In Databases
tags:
- DATABASE
author: Amita Shukla
date: '2016-07-09'
slug: decomposition-rules-in-databases-lossless-and-dependency-preservation
type: post
draft: false
showTableOfContents: true
---
In my previous posts, we discussed the [terms used in database design](http://shuklaamita.blogspot.com/2016/06/relational-database-functional-dependencies-canonical-cover-keys.html), and the [principles used to design relational databases](http://shuklaamita.blogspot.com/2016/07/normalization-in-databases.html). We discussed as to how Normal Forms can be used to determine whether or not to decompose a database, and how to decompose it. 
 
We need to be very careful while decomposing a database. Any improper decomposition may lead to errors in database design. 
 
To check if a decomposition is proper, we need to satisfy the following properties: 
 


1. It must be a lossless join
2. It must be dependency preserving

Let's discuss these properties in detail.

 


### Lossless

Suppose a relation R is decomposed into R1 and R2.

A decomposition is said to be loss less if R1 ∩R2 is the candidate key of any decomposed relation.

Hence, for relation R(ABC) \[ Primary Key A] the following relations are lossless:

- R1( A,B) and R2( A, C) \[ R1 ∩ R2 = A, and A is the primary key of R1 & R2]
- R1( A, C ) and R2( C, A ) \[ R1 ∩ R2 = C, and C is the primary key of R2]
- R1( A, B ) and R2 ( B,C ) \[ R1 ∩ R2 = B, and B is the candidate key of R2]

On the other hand, the decomposition

R1( A,C ) and R2( B,C ) is not lossless, as R1 ∩ R2 = C, which is not the primary key of any of the relations R1 or R2.

 


Hence, a loss less decomposition ensures that the attributes involved in the natural join (R1 ∩ R2) are candidate key if at least one of the two relations.

This, in turn ensures that we can never get a situation where false tuples are generated. For any value on the join attributes there will be a unique tuple in one of the relations.

 


### Dependency Preserving

Dependency is said to be**preserved**if we can derive all the original dependencies from the FDs after decomposition.

Formally stating, if closure of functional dependencies after decomposition is same as closure of Fds after decomposition, then dependencies are preserved.

