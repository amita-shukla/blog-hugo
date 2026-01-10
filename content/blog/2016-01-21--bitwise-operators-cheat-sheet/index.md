---
title: 'Bitwise Operators Cheat Sheet: Little Programming Tricks using Bit Operations'
tags:
- PROGRAMMING
author: Amita Shukla
date: '2016-01-21'
slug: bitwise-operators-cheat-sheet
type: post
draft: false
showTableOfContents: true
---
Here is the list that I use when dealing with bit-wise operations. 
Bit-wise operations are considered to be slightly faster than corresponding multiplication/division operations. 
Also, Bit-wise operations make the code cleaner at a few places, such as, when we have to check if a number is even or odd. 
 
However, my personal opinion is to code in such a way that it easily showcases your intent. So, one should not use bit-wise operators deliberately as it can make the code a bit vague at some places. 
 


- Subtraction of 1 from a number toggles all the bits (from right to left) till the rightmost set bit(including the righmost set bit)

 


- A >> 1 division by 2

A &lt;&lt; 1 multiplication by 2 
 


- if ((x & 1) == 0) x is even, else odd

 


- if (x & (1&lt;&lt;n)) n-th bit is set

 


- y = x | (1&lt;&lt;n) set the nth bit x and save as y

y = x & ~(1&lt;&lt;n) unset(clear) the nth bit of x and save as y 
 
 
 


- y = x ^ (1&lt;&lt;n) toggle the nth bit of x and save as y


- x & (x-1) will clear the lowest set bit of x or, turns off the rightmost set bit.


- x & ~(x-1) extracts the lowest set bit of x (all others are clear). Pretty patterns when applied to a linear sequence.

 
 


- x & (x + (1 &lt;&lt; n)) x with the run of set bits (possibly length 0) starting at bit n cleared.
- x & ~(x + (1 &lt;&lt; n)) the run of set bits (possibly length 0) in x, starting at bit n.

 
 
 


- x | (x + 1) x with the lowest cleared bit set

 
 
 


- x | ~(x + 1) extracts the lowest cleared bit of x (all others are set)

 
 
 


- x | (x - (1 &lt;&lt; n)) x with the run of cleared bits (possibly length 0) starting at bit n set.

 
 
 


- x | ~(x - (1 &lt;&lt; n)) the lowest run of cleared bits (possibly length 0) in x, starting at bit n are the only clear bits.

 
 


#### Properties of Bit-wise Operations:

x^x =0

x^y^x = y 
 
x^y = (~x & y) | (x & ~y) 
 


#### Swap two numbers x and y

x = x ^ y ; 
y = x ^ y ; 
x = x ^ y ; 
 
 


