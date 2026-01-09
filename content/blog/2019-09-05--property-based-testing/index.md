---
title: Property Based Testing
tags:
- DATA STRUCTURES
- FUNCTIONAL PROGRAMMING
- HASKELL
- SCALA
- TESTING
cover: pbt.gif
author: Amita Shukla
date: '2019-09-05'
slug: property-based-testing
type: post
draft: false
---
Let's talk about testing today. And testing is _hard_. The most common way we have been testing is what is known as **Example Based Testing**. 
Following steps are followed for writing test cases: 


- We start by taking a function
- To write a test for the chosen function, we start by defining a set of inputs and the expected outputs.
- For each test, we call this function for an input and match it with some expected value.

How do we practice testing? When given a feature: 


- we write the test cases first,
- run the test cases, verify that they fail,
- implement the function at hand,
- run the test cases against our implementation,
- make sure all test cases pass.

Let's start with an example. I will be using ScalaTest framework for this small example function, say `add`. 
Let's write a few test cases for the `add` function: 
 
Now I implement my add function: 
Obviously, I am being a bad programmer here. My test fails. But I can be worse. Now I have to deliver this thing, and for that, the test cases must pass. So I do whatever it takes. 
 
Cool. Now my test case pass. But hey! this is not over yet. I try to get this pushed, but I can't really get away with just one test case. Huh! Let's add some more. 
Now given my implementation of `add` above, one of my test cases are failing. But I am bent on passing my test cases by hook or by crook. So now I implement: 
Now you would say one day or the other I will be caught, but I can always handle test cases like this. You would also say that this example is too obvious. Yes, I agree. But not all code is this obvious, and not all coders are malicious. This example shows that test cases can pass even when the code is bad and the logic is broken. 
 


[![](https://miro.medium.com/max/1208/1*ok5iNXeD1HjzDHhKUcl5cQ.gif)](https://miro.medium.com/max/1208/1*ok5iNXeD1HjzDHhKUcl5cQ.gif)

 
So how do we correct this? One solution is trusting developers with their coding skills and let the error flow until it blows up in production. Or... try Property Based Testing. 
 


### Property Based Testing

What is property based testing? In property based testing, instead of providing a specific set of input for each test case, we write properties. 
 


#### Property

Property is nothing but a testable unit. In property based testing, these properties need to be satisfied by the function we need to test. If we take a combined look at all the properties defined for a function, it should indicate the behaviour of the function under any circumstance. Now that we have defined a property, what sort of properties can we think up for our code? Let's move ahead with our `add` example.

 
What can be the properties of an `add` function? 


- Adding by 0 can be a good start. We know add on a number and 0 must give out the number. We call this property **identity**. So: `add(x,0)=x`

Let's run this property: 

```shell
 [info] ! Add.identity: Falsified after 0 passed tests.
 [info] > ARG_0: 0
 [info] > ARG_0_ORIGINAL: 1
```
 
This test failed as expected, but the property alone is not sufficient. Suppose our bad code already contains this handling: 
Let's run this property now: 

```shell
 > test
 > [info] AddTest:
 > [info] + Add.identity: OK, passed 100 tests.
```
 
This test easily passed. There can be many wrong such implementations of a function on an integer that return the same integer back. What properties can make `add` fool-proof to test? 
Let's try putting one more property: 


- Flipping the order of inputs to add should return the same result. So: add(x,y) = add(y,x). We call this property **commutative**, which will help us distinguish the `add` from functions such as `subtract`. Looks like this should work. Let's try:

 
Running this now: 

```shell
 > test
 > [info] AddTest:
 > [info] + Add.identity: OK, passed 100 tests.
 > [info] + Add.commutative: OK, passed 100 tests.
```
 
Shockingly, our commutative property does not suffice. But why? Let's try printing the randomly generated tests here: 
Running tests now: 

```shell
 > test
 > [info] AddTest:
 x = -283328897 and y = 1735471989
 x = 2147483647 and y = 1
 x = 902184796 and y = 0
 x = 1761670528 and y = 2147483647
 x = -1 and y = 1
 x = -1766910549 and y = -2147483648
 x = -1079495038 and y = -306732024
 x = -1 and y = 1
 x = -1 and y = -595376862
 x = -1267109685 and y = 1221874588
 x = 1710402698 and y = 1
 x = 0 and y = 2147483647
 x = -1496107197 and y = 1555536417
 x = -1010882575 and y = 0
 x = -148217383 and y = 1785131788
 x = 2147483647 and y = 1
 x = -1032994959 and y = -1
 x = -207729455 and y = -1
 x = -1 and y = -2147483648
 x = -274047330 and y = 1
 x = 931105896 and y = 0
 x = -1 and y = 7392559
 x = -1629543210 and y = -505234372
 x = -2147483648 and y = -997498258
 x = 664666819 and y = -2147483648
 x = 0 and y = -1
 x = 1 and y = -601536489
 x = -2147483648 and y = -1
 x = 810956687 and y = 1
 x = 2147483647 and y = 1425588316
 x = -1599729503 and y = 2147483647
 x = -1 and y = 1
 x = 1 and y = -1994173278
 x = -1765121205 and y = -1
 x = -2147483648 and y = -444252352
 x = -94848801 and y = -418331736
 x = 2147483647 and y = -2147483648
 x = -1041475063 and y = -2066395354
 x = 1426790203 and y = -1
 x = -2147483648 and y = 1
 x = 1 and y = 579849916
 x = -1791008680 and y = -831946485
 x = 0 and y = -128557305
 x = -2147483648 and y = 0
 x = 1 and y = 2147483647
 x = -2108632480 and y = 1
 x = 2147483647 and y = 1
 x = -2100778803 and y = 1569433578
 x = 0 and y = 0
 x = 0 and y = -1321862054
 x = -2147483648 and y = 574473982
 x = 1992767230 and y = -235589010
 x = 2147483647 and y = 936713378
 x = 2147483647 and y = -2147483648
 x = 479454965 and y = 791321877
 x = 1673114886 and y = 32065938
 x = 1143030900 and y = 1157140989
 x = 1025857191 and y = 1355198771
 x = -2048789776 and y = -1
 x = 1790440328 and y = -173381408
 x = -1 and y = 1
 x = 368281449 and y = 1289228540
 x = -302533624 and y = -1550296909
 x = -2033588754 and y = 1
 x = -1 and y = -2147483648
 x = -2147483648 and y = -400996116
 x = -1 and y = 1531590967
 x = 0 and y = -2147483648
 x = 1 and y = 1
 x = -1682888892 and y = 951314722
 x = -921144956 and y = -2147483648
 x = 0 and y = 1257974224
 x = 0 and y = 1303946082
 x = 1642155181 and y = 2147483647
 x = -2147483648 and y = 2147483647
 x = 1 and y = -2147483648
 x = 0 and y = -397273960
 x = 924610080 and y = -2147483648
 x = 1 and y = 1
 x = -167739585 and y = -1
 x = -2018431545 and y = -597953303
 x = 1099702277 and y = -2034975121
 x = -791315953 and y = -1489117288
 x = -1708172828 and y = -911743133
 x = 1 and y = 2147483647
 x = -355069252 and y = 1
 x = -1367711777 and y = -523554244
 x = 2035562490 and y = -1
 x = -2147483648 and y = 0
 x = 749057419 and y = -2068921504
 x = -1 and y = 231975227
 x = -831717683 and y = -252453652
 x = -2147483648 and y = 2147483647
 x = 1799244601 and y = -1
 [info] + Add.identity: OK, passed 100 tests.
 x = 2147483647 and y = 2147483647
 x = 1 and y = -2147483648
 x = -2147483648 and y = -95933741
 x = 1 and y = 2147483647
 x = -2147483648 and y = 2147483647
 x = -2147483648 and y = -987661912
 [info] + Add.commutative: OK, passed 100 tests.
```
 
As we see here, a lot of random test cases are generated, but our implementation puts a default answer for all the test cases that it doesn't cover, i.e. 42. So if `x = 1099702277` and `y = -2034975121`, `add(1099702277,-2034975121)` = 42 = `add(-2034975121,2034975121)`. 
 
So is our property wrong? No, it isn't, but it's not sufficient. 


- So what can be other properties that `add` and only `add` can exhibit? One property can be: `the result of adding 2 positive integers is always greater than or equal to both the integers`. Now let's implement this property. Observe that here, we can not directly apply this property for all integers, rather for only positive integers. How do we achieve that?

Here comes the role of Generators. 
 


### Generators

Generators are used to generate a specific set of data. Let's try Generators for our use case: 
 
Here, `Gen.posNum[Int]` generates a set of positive integers. The `Gen` class has a lot more methods like this. For example, if you need your data to be positive integers greater than 1000 only: 
 
Testing this: 

```shell
 > test
 > [info] AddTest:
 [info] + Add.identity: OK, passed 100 tests.
 [info] + Add.commutative: OK, passed 100 tests.
 [info] ! Add.the result of adding 2 positive integers is always greater than or equal to both the integers: Falsified after 0 passed tests.
 [info] > ARG_0: 1
 [info] > ARG_0_ORIGINAL: 722748975
 [info] > ARG_1: 59
 [info] > ARG_1_ORIGINAL: 378231530
 [info] ScalaCheck
 [info] Failed: Total 3, Failed 1, Errors 0, Passed 2
```
 
One more thing to mention here. We see scala check mentions two cases, one like 
`ARG_0` and `ARG_1`, and other like `ARG_0_ORIGINAL` and `ARG_1_ORIGINAL`. This is a feature called Shrinking. 
 


### Shrinking

Shrinking is a mechanism by which we can simplify failure cases to present the minimal one, readable to the human eye. So as we see above, there are 2 sets of failed test cases presented, one with ARG_0 and ARG_1 and the other as ARG_0_ORIGINAL and ARG_1_ORIGINAL, where: 
 

```shell
 ARG_0: 1

 ARG_1: 59

 ARG_0_ORIGINAL: 722748975
 ARG_1_ORIGINAL: 378231530
```
 
The value of ARG_0 and ARG_1 is simplified as compared to the original one. 
 
We can disable shrinking using `forAllNoShrink` method: 
 
 

```shell
 [IJ]sbt:ScalacheckDemo> test
 [info] Compiling 1 Scala source to /home/ashukla/code/scala/ScalacheckDemo/target/scala-2.13/test-classes ...
 [info] Done compiling.
 [info] + Add.identity: OK, passed 100 tests.
 [info] ! Add.the result of adding 2 positive integers is always greater than or equal to both the integers: Falsified after 0 passed tests.
 [info] > ARG_0: 996337608
 [info] > ARG_1: 767214905
 [info] + Add.commutative: OK, passed 100 tests.
 [info] AddTest:
 [info] ScalaCheck
 [info] Failed: Total 3, Failed 1, Errors 0, Passed 2
```
 
Observe that here the failing test case given are huge integers, without further reduction. 
So that's all with the simple example. Let's go deeper and see how we would go about writing tests for a `Tree` data structure... 
 
To create properties using this data structure, we first need tree generators: 
 
Observe here that we need to specify the concrete type of `Tree` that we want to generate here, instead of generic types. 
 


### The Art of defining Properties

Throughout this post, we have gone through the process of defining properties for a simple `add` function. We have seen we might be sailing the Titanic if we are not able to define the right properties. Having incorrect/ insufficient test cases is infact more harmful as it gives an illusion of a perfect codebase. Here are a few suggestions when we start thinking about properties:

- For start, we can brainstorm (or look up Wikipedia) for some basic laws associated with the concerned function, data structure or algorithm. Some properties can directly be derived from their mathematical counterparts.
- Try `reverse`. Some properties can be derived by trying to reverse the order of inputs. Supose in case of sorting a list, the reverse of a list should produce the same output.
- Change the order of inputs. Some properties can be derived by changing the order of inputs/operations but arriving on the same output. This we have seen in the `add` function as well.
- Use Induction. Just like mathematical induction, we can verify if a property stands true for a smaller part, then it should work for the larger part as well.
- and... a lot more that I am not covering here.

There are many more ways in which we can think of defining properties. Still not able to? May be that is indicative of some deeper problem with the code itself. Maybe this is a call for abstracting general behaviours out of your program now. 


 
It's been a while that PBT has existed, and its poularity has been growing ever since. It is being used in a number of real world applications. I myself am using it at my work. PBT was originally developed as part of QuickCheck framework in Haskell and since then it has been developed in a number of languages. Give it a shot and you might never look back! 
 

