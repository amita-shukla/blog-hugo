---
title: Dynamic Programming
tags:
- ALGORITHMS
- DATA STRUCTURES
- PROGRAMMING
cover: Blog_DP_Quote.png
author: Amita Shukla
date: '2016-06-01'
slug: dynamic-programming-introduction
type: post
draft: false
---
Aah! Its been a long time since I last updated. Sorry my dear readers about that. College has ended, and that brought with it a lot many hassles to deal with. 
 
Now back to my home, I thought of writing my notes in this post. And what could be a better topic than Dynamic programming! So lets get started, the Cormen way. 
 


### What is Dynamic Programming?

Dynamic programming deals with optimization problems. This implies that this technique was developed to minimize the time, or space, or both of a problem, which, had it been solved in usual way could consume a lot of time/space. 
 
 


<re-img src="Blog_DP_Quote.png"></re-img>

 
 
 
The technique involves two basic approaches: 
 


- Top Down method with Memoization
- Bottom Up method

#### Top Down method with memoization

1. Write down the recursive solution to the problem.
2. This solution is generally inefficient.
3. Hence, to optimize it, save the result of each function call in a table.
4. This table can be an array (1-D or 2-D), map etc
5. Also, on each function call, first check if a solution is already saved in the table.
6. If so, then return the result.
7. If not, then continue the computation. (Step 3)

This approach is top down as it naturally goes on to solve a problem, attempting to solve the problem first and then its subproblems are solved during recursion.

 


Memoization is the term denoting the use of 'memo' or a table in this approach.

 


#### Bottom Up method

Bottom up method underlines the idea of solving sub problems first and then using these solutions to subproblems to find the solution to the actual problem.

1. Initialize an array (or a similar structure) that will be used to store the problems to the subproblems.
2. Solve the smallest subproblem whose result is obvious.
3. Use this solution to solve the suproblems in increasing order of size.

 


#### How is Bottom up method different from Divide And Conquer Approach?

Yes, both involve solving of subproblems. But there are differences:

1. The key in Dynamic programming is remembering. It saves the result of the subproblems it solves. Divide and Conquer Approach involves recursion.
2. The Divide and Conquer Approach does not need to save the result as each subproblem is different. However, in bottom up method, solution to a subproblem may be used in solution to any other problem. Hence, saving the result matters.

### Elements of Dynamic Programming

Problems that can be solved using Dynamic Programming tend to have the following properties:

#### Optimal Substructure

This means that the optimal solution to a problem contains within it the optimal solution to its subproblems. Hence, we build the optimal solutions to a problem from optimal solutions to its subproblems.

 


#### Overlapping Subproblems

If we observe that the recursive solution to a problem involves solving the same subproblems over and over again, it is an indicator that a DP solution might work.

 


A lot more can be written over this topic, which I will continue in my future posts.

Keep Reading!

