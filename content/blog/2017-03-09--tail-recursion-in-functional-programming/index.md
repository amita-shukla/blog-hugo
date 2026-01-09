---
title: (Tail) Recursion in Functional Programming
tags:
- ALGORITHMS
- FUNCTIONAL PROGRAMMING
- JAVA
- SCALA
cover: rec.png
author: Amita Shukla
date: '2017-03-09'
slug: tail-recursion-in-functional-programming
type: post
draft: false
---
In my previous post [Going The Functional Way](https://amitashukla.in/blog/why-functional-programming.html), I discussed the reasons for venturing into functional programming. Taking my explorations further, I soon realised a truth: Functional Programming relies heavily on Recursion. 
 


<re-img src="rec.png"></re-img>
 
 
Consider a simple task: Write a function to calculate the factorial of a given number 'n'. 
Let's attempt it with Java. 

```java
public int factorial(int n){
  int fact = 1;
  for(int i = n; i > 0; i--) fact *= i;
  return fact;
}
``` 
 
Attempting the same with Scala: 

```scala
def factorial(n : Int) :Int = {
  def loop(acc : Int, n : Int) : Int = {
    if(n == 0) acc
    else loop(acc*n,n-1)
  }
  loop(1,n)
}
```  
 
You see there is a lot of difference. First Java code is the Imperative style whereas the second Scala code is the Functional Style. At first I thought it is just another way of looking through a problem, but looks like it's a lot more than that. Functional Style uses Recursion a lot. A hell lot. 
 
But why? 
The first code looks so simple. You iterate through a loop, multiply the number with one less that it, until you reach 0. Looping has always been easy to learn. Moreover, it is always more intuitive to go by the 'loop' way - they are heavily embedded in our lives (if you are an Imperative programmer!) and we can't imagine a problem without loops. 
Another reason - Java has accommodated iteration seamlessly for us. There are for loops, while loops, foreach, do-while (yes, they exist.), Iterators, ResultSet... 
 
Look at the second code now. There is a function in a function (Oh! it's 'functional' programming by the way), the outer function does nothing other than calling another function defined within it with an extra parameter, the inner function computes factorial recursively. Even if we manage to understand the hierarchy of the code, the fact that it is recursive makes it difficult to understand. You need to keep in mind the previous stack while calculating the present stack. 
 


### Why Favour Recursion over Iteration?

Yes we know it - Recursion is bad for a code's health. For any given large number, recursion can get costly on memory. It is because the memory has to keep track of variables used in each cycle of recursion.

Consider a recursive function to calculate factorial in java:

```java
public int recFactorial(int n){
  if(n==0)
    return 1
  else
    return n*recFactorial(n-1);
}
```

This code, though may be intuitive, can result in memory and performance related issues. 
 


### What stops Functional Programming from adopting Iteration?

In functional programming, iteration conflicts with the basic principle of functional programming: 


> _\"Functions do not have side-effects.\"_

Considering the fact that a function does not produce side effects, a loop can also be considered as a function - given the number and a number as the counter. The value of this counter is supposed to change (decrease by 1, in this case) by each call to this function. However, this is not the desired effect: the result of the loop function depends on the number of times it has been called, a _side-effect._This leaves us to use recursion. 
 


### How Functional Programming deals with Recursion Related issues?

In functional programming, we use a trick known as Tail Recursion to overcome the implementation issues related with recursion. 
_Tail Recursion is a form of recursion, in which the recursive call is the last action in the function._ 
 
Tail recursion has an inherent advantage: when the recursive call is the last call, then it gives the compiler the freedom to reuse the stack. This is because, in case of tail recursion, once a recursive call is made, no variable is used later. Hence, the variables can be forgotten and the stack can be reused for a fresh set of variables. 
 
In general, if the last action of a function consists of calling another function ( which may be itself), one stack frame would be sufficient for both functions. Such calls are called _tail-calls_. 
 
_The above reason makes Tail Recursion equivalent to Iteration._ 
 


### How To Make Your Function Tail Recursive?

Given the reason that a function is written recursively, how can we approach a solution to a problem in a tail-recursive way?

#### Accumulator

Functional Programming gives us the freedom to define a function inside a function. Hence, we can create another function called 'loop', which takes up an extra parameter called `acc`. This variable, as its name suggests, is used to 'accumulate' the result over multiple recursive calls. 
 
```scala
def factorial(n : Int) :Int = {
  def loop(acc : Int, n : Int) : Int = {
    if(n == 0) acc
    else loop(acc*n,n-1)
  }
  loop(1,n)
}
```


The original function is used to call the helper function, supplying it with the initial value of the accumulator. We keep the outer function to maintain the signature of the factorial function, so that the user is not affected by the implementation side of it. 
 


### How to indicate the Compiler for Tail Recursion?

In Scala, only directly recursive calls to the current function are optimised by the compiler to be used in a way equivalent to that of Iteration. One can require that a function is tail recursive by using the annotation `@tailrec`

```scala
import scala.annotation.tailrec

object factExercise {
  def factorial(n : Int) :Int = {
    @tailrec
    def loop(acc : Int, n : Int) : Int = {
      if(n == 0) acc
      else loop(acc*n,n-1)
    }
    loop(1,n)
  }

  factorial(4)
}
```
 
I hope now the not-so-intuitive-functional-code starts to make sense. 
A side - effect free language, though seems to have adopted complex ways, unfolds into really simple version as we get used to it. Let's see what all it has for us!
