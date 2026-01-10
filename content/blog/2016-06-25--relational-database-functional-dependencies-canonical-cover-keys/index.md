---
title: Relational Database Design
tags:
- DATABASE
- TECHNOLOGY
author: Amita Shukla
date: '2016-06-25'
slug: relational-database-functional-dependencies-canonical-cover-keys
type: post
draft: false
showTableOfContents: true
---
Database systems are used to manage large bodies of information. For an enterprise, database management is crucial, for purposes such as sales, accounting, manufacturing, banking etc. Almost every institution in today's world needs to maintain a database. 
 


### Relational Database

Relational Databases became dominant for commercial applications. Other types of database models that exist are Network, Object, Hierarchical systems. In a relational database, the data is organized in the form of tables (or relations ). These tables are organized into rows and columns. This model is named so because of its underlying theme, it stores **inter-related** data.

 


### Primary Goals of a Relational Database

- Reduce Redundancy
- Minimize Access Times for information retrieval

 


Let us now discuss the formal approach to relational database design.

 


While E-R model is the graphical representation of entities and their relationships, relational database design requires representing all data in tables, by the use of some principles, known as **Normal Forms.**We will dig in them some other time. Let's get into some concepts about relational databases.

** 
**

Database design aims to reduce (but not eliminate) Redundancy and perform INSERT, UPDATE and DELETE operations without confronting inconsistency.

 


### Functional Dependency

A relational database is expressed in terms of relations. There are several attributes that **depend** on each other, and in many different ways. For large and complex databases, it gets difficult to analyze which dependencies are logical and direct, and which ones are trivial and derived. We can ignore the later ones, because, if implied, they can cause redundancy and inconsistency in a database. 
 
To formally represent these 'dependencies', we have Functional Dependencies. It can be stated as: 


#### A→ B

means, A functionally determines B, i.e. B ⊆ A.

 


### Closure of Attribute Sets

The full set of values that can be determined from a set of known values for a given relationship using its functional dependencies is called Closure.

 


For example, R(ABC)

It means a relation R containing A,B,C columns , given the following dependencies exist :

F: A→ B

B→ C

 


then, the closure F+ = A→ B 
B→ C 
A→ C 
 
 


### Armstrong's Axioms

Closure is computed using Armstrong's Axioms: 


**1.****Reflexive**

A → B ⇒ B ⊆ A

**2. Augmentation**

A→ B ⇒CA → CB

**3. Transitivity**

A→B, B→ C⇒A→ C

**4. Union**

A→ B, A →C ⇒ A →BC

**5. Decomposition**

A→ BC ⇒ A →B, A → C

**6. Pseudo-transitivity**

A→B, BC → D ⇒ AC → D

 


 


 


For example, let a set F be:

**A →B 
A →C 
BC →D**

Then the closure F+ will be 
(i) A →B 
(ii) A →C 
(iii) BC →D 
\[ The given FDs are of course a part of closure ] 
(iv) A → BC \[ Union ] 
(v) A →D \[ Transitivity Rule on (iv) and (v) ] 
(vi) A → BCD \[ Union on (iv) and (v) ] 
(vii) AC →D \[ Augmentation and then Transitivity ] 
 


### Non- Redundant Cover

- For a given set of FD's, choose any desired FD.
- Find the closure of the attribute on the left, not considering the chosen FD.
- If the closure of the FD contains the attribute on the right of the chosen FD, we say that the FD is redundant.
- Hence, remove that FD and move on to next one.

For example, given set of FDs :

**A →BC**

**CD →E**

**E →C**

**D →AEH**

**ABH → BD**

**DH →BC**

** 
**

Lets find out the redundant FDs:

A+ = A \[ Remember, we are not considering the FD whose closure we are finding ]

CD+ = CDAEHB \[ As this FD contains E int its closure, we mark it as **redundant**]

E+ = E

D+ = D

ABH+ = ABHC

DH+ = DHAEBC \[ As this FD contains BC in its closure, we mark it as **redundant**]

 
The problem is that they depend on the order in which you start evaluating. Solution to non redundant cover may not be unique if there are more than 1 candidate key. 
 


### Canonical Cover

A Canonical cover for a relation is a reduced set of Functional Dependencies whose closure will be the same as the actual FDs. A canonical cover is a simplification of the original dependencies and hence it is easier to test for any dependency violations in a relation. 
 
 Following are the steps to compute canonical cover: 
 


- Make the attributes simple. That is, apply Decomposition Rule to all dependencies such that there is only a single attribute on the right of all FDs.
- Now, remove the redundant FDs by finding closure, using the same procedure as above for redundant cover.
- Now make a check again. Make sure that the left side of each dependency does not have any **extraneous** attributes. An attribute of a functional dependency is said to be extraneous if we can remove it without affecting the closure of the set of FDs. If there exist any such attributes, then remove them.

 
Lets take the above example, 
 


**A →BC**

**E →C**

**D →AEH**

**ABH → BD**

As you can see, I have already removed the redundant dependencies. 
** 
** Step 1: Make the FDs 'simple'. 
A →B 
A →C 
E →C 
D →A 
D →E 
D →H 
ABH → B 
ABH →D 
 


 
Step 2: Remove redundant dependencies. 
A+ = AC 
A+ = AB 
E+ = E 
D+ = DHEC 
D+ = DABHC 
D+ = DAEBC 
 
We can not find any redundancy here. 
 
Step 3: 
Let us check for any redundant attributes on the left side. 
 
Since A → B \[ To understand it better you can interpret it as B⊆ A] 
Therefore the FD:ABH →D can be written as AH →D. 
 
Hence, the canonical cover is: 
A →B 
A →C 
E →C 
D →A 
D →E 
D →H 
AH →D 
 


### Keys, Keys Everywhere

Lets get in terms with the keys and know about their role in a schema:

 


#### Candidate Key

A candidate key is a key, or a column ( or a set of columns) that can be used to uniquely identify a row in a table. Let an attribute be A. If A+ contains all the attributes of the relation to which it belongs, then we can take it as a super set, and A can be taken as a candidate key.

A candidate key is called so because they are candidates for primary key.

 


For example, given the FDs:

A →D

A → B

B →C

D →A

 


A+ = ABCD

D+ = ABCD

 


Hence, A and D are candidate keys.

 


#### Primary Key

The primary key is the 'chosen one'. Out if all the candidate keys, we choose one key that is used to determine uniquely the rows of a table. Remember that, a primary key:

- is unique.
- does not contain null values.

All the candidate keys other than the primary key (the not chosen ones) are termed as **Alternate Keys.**

In the above example, we can choose A as the primary key, then D becomes the alternate key.

** 
**

#### Super Key

If the closure of a key contains all the attributes of a relation, but the one that can be minimized further, is called super key.

 


Let us take a key DC. Since D is already a candidate key, DC is super key. Here, C is redundant.

 


### How to Find Candidate Key

As you can understand now, the key lies in finding the candidate key. Following are the ways to find the Candidate Key:

- Choose any attribute and take its closure. This time, remember to include the attributes on the right side of the chosen FD.
- If the closure contains all the attributes that exist in the given relation, then it is a candidate key.
- If the closure of a single key is not able to produce all the attributes, take the union of one more attribute and try again.
- In the worst case, all the attributes of the relation will comprise of the candidate key.

 


