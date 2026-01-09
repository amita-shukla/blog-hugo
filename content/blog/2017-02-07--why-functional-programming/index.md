---
title: Going the Functional Way
tags:
- BIG DATA
- FUNCTIONAL PROGRAMMING
- SCALA
cover: FP.png
author: Amita Shukla
date: '2017-02-07'
slug: why-functional-programming
type: post
draft: false
---
2016 ended with me struggling to solve Scala assignments on Coursera. It was a mind-twisting experience, as I was accustomed to writing Java code. My [first assignment](https://github.com/amita-shukla/functional-programming) was on the topic Recursion, was a set of three problems, printing the Pascal's Triangle, checking balanced parenthesis, and change given the money. I had practised all these problems, but in Java. Doing these problems in functional programming was baffling, as it has an entirely different approach to solving problems. 
 
But I wondered, why did I decide functional programming in the first place? 
 


### Functional Programming Makes You Look At Things Differently.

Functional programming was the answer to the question, \"What next?\" Even when you have spent sufficient time on programming, going the functional way made me an amateur again. I recalled my initial days in school, when I was given a problem and I just didn't know what to do next. Same happened here, it brought down my confidence on programming, only to achieve a new sense of confidence, a more humble one. It was the same as doing Mathematics : It is always better to solve a problem in more than one way.

 


### When You Have A Big Data Job, You Should Know Its Roots.

I went through [this](https://www.joelonsoftware.com/2006/08/01/can-your-programming-language-do-this/) blog post ( I was later binge reading this blog, [Joel On Software](https://www.joelonsoftware.com/)), I realized that it was functional programming where the functions Map and Reduce were first used. I was reading a lot about Hadoop and Map Reduce before this, but nowhere I could relate all that. I decided that let's think about the Map Reduce in the way its creators thought about it. The Functional Way.

 


### A More Concise, Cleaner Code

As I went on reading code written by my colleagues in Scala, I realized that the same code in Java would have added a lot of boilerplate code. Scala was a much cleaner alternative. Though there are other languages that are more concise than Java (Python?), Scala was different. It was a mix of [Functional and Object-Oriented](https://www.scala-lang.org/). 
 
 


<re-img src="FP.png"></re-img>

 


 


### Functional Is The Way For Concurrency

To handle a huge amount of data, you take up chunks of data to handle them separately, without interacting with each other. Imperative Programming provides multi-threading of course, but we need to use them with extra care. Any thread that causes changes outside of what it is supposed to do (known as Side-Effects), it can crash the whole application. These side effects can cause threads to get entangled together (Ouch!)... and then you handle them with abstractions using locks, etc.

 


Functional Programming, on the other hand, forces you to write side-effect free functions. And therefore, you can run these functions in any order. In this way, it becomes very simple to enable concurrency.

 


### Time v/s Space

Martin Odersky, the creator of Scala, talks about the difference of time-space approach while working on the imperative or functional approach to programming.

When we think of a time based approach, we write the code in the form of time-based steps, happening one after the other. Whereas, the functional approach guides to perform manipulation on data, making chunks, processing those chunks... this approach is space oriented.

For concurrency related problems, programming the time-based approach is more complicated as compared to the space-based approach.

 


 


 


 
There is a lot more to discuss, but I would prefer to code some of it and then write about my experiences...

