---
title: Multiple Inheritance and Mixins
tags:
- JAVA
- PROGRAMMING
cover: Diamond_Problem.png
author: Amita Shukla
date: '2016-02-25'
slug: multiple-inheritance-mixins
type: post
draft: false
---
This post discusses about the issues related to multiple inheritance and where it can be useful. 
As the concept goes, we call it multiple inheritance when a class inherits characteristics from more than one parent class. 
Inheritance is a powerful tool in object oriented programming but it should be used with caution. Languages such as Java, C# avoid multiple inheritance (though we can implement multiple interfaces) due to the potential problems it can cause. 
 


### The classic Diamond Problem

Consider the inheritance situation as displayed below:

 


<re-img src="Diamond_Problem.png"></re-img>

 


 


Let class B and C override a function defined in A differently. Now the ambiguity arises when class D tries to use that function. Which one should it use? The B's version or the C's version.

 


Hence, multiple inheritance is disallowed in Java language to keep up with its motto to keep it simple. It, however, allows us to implement multiple interfaces, so that we can write our own implementation of the functions declared in the inherited interfaces without giving rise to any ambiguity.

 


## Mixins

The primary use of multiple inheritance is to define \"mixins\" - a set of objects to set some properties to an object. Mixins are called so because they allow properties can be mixed in to derived classes. It is like an interface, but already implemented. These are classes that provide some functionalities and are standalone in nature. This means that mixins are independent of each other and do not have inheritance with other mixins.Mixins might be classes like Displayable, Persistant, Serializable, or Sortable.

Java 8 introduces a new feature in the form of default methods for interfaces. It allows a method to be defined in an interface with application in the scenario when a new method is to be added to an interface after the interface class programming setup is done. To add a new function to the interface means to implement the method at every class that uses the interface.

 


So, mixins uses multiple inheritance but are not subject to the diamond problem.

 


Source: <http://stackoverflow.com/questions/533631/what-is-a-mixin-and-why-are-they-useful>

<https://en.wikipedia.org/wiki/Mixin>

