---
title: Cell Arrays in MATLAB
tags:
- MACHINE LEARNING
- MATLAB
- PROJECT
author: Amita Shukla
date: '2016-04-22'
slug: cell-arrays-in-matlab
type: post
draft: false
showTableOfContents: true
---
As I dig deeper and deeper into the MATLAB world, I learn new concepts everyday. I must say, MATLAB is very flexible. After working on languages like JAVA and C for long, working on MATLAB has given me a new sense of freedom : I have got rid of the braces ! I am so habitual of defining scope in the form of curly braces {} , that I tend to use them in MATLAB without realizing it to the point of compilation error. 
 
But hey! Who says the braces have gone? The are here to stay. This time they have come in a rather more dramatic way. In the form of The Notation of Cell Arrays. 
 


Until now, I was happily working with the following form of indexing:

 

```
If A = \[1 2; 3 4; 5 6],

then A(2,4) = 4.
```
 


Just the normal way of indexing.

But reading more into machine learning projects, I encountered this notation:

 

```
A{1,2} ...
```
 


Now what was this? Soon I found out it is a data type in MATLAB known as Cell Arrays.

 


### What are Cell Arrays?

A Cell Array is made up of cells (of course). You can say these are containers, which can contain any type of data. Yes, any type, a character, a piece of text, a small matrix, any other big matrix and so on. 
 
 


### Referencing a Cell Array

Now here came the mind bender. I came across different kinds of notations, such as

 

```
A{1,2} = {1,2,3}; and

A(1,2) = {1,2,3};
```
 


I assumed it is indexing in the same way in both cases. But there is a huge difference.

 


If you enclose the indices in smooth parenthesis, i.e. `()` you mean to say that the value being assigned is a set of cells. Whereas, if you enclose them in curly braces, i.e.,`{}` you are actually referring to the content in individual cells.

 


An example would make it clear.

Suppose, I have

```matlab
A = {1 2 3; 'Hello' 'Amita' 'Shukla'; 7 8 9}
A = 
{
  [1,1] =  1
  [2,1] = Hello
  [3,1] =  7
  [1,2] =  2
  [2,2] = Amita
  [3,2] =  8
  [1,3] =  3
  [2,3] = Shukla
  [3,3] =  9
}
```

The two notations act in the same way if a single cell has to be updated: 

```matlab
A{2,2} = 'Ms'
A = 
{
  [1,1] =  1
  [2,1] = Hello
  [3,1] =  7
  [1,2] =  2
  [2,2] = Ms
  [3,2] =  8
  [1,3] =  3
  [2,3] = Shukla
  [3,3] =  9
}
A(2,2) =  'Amita'
A = 
{
  [1,1] =  1
  [2,1] = Hello
  [3,1] =  7
  [1,2] =  2
  [2,2] = Amita
  [3,2] =  8
  [1,3] =  3
  [2,3] = Shukla
  [3,3] =  9
}
```


But as said above, smooth brackets can be used to refer to a set of cells and hence we can change the values of set of cells in a single sentence:

```matlab
A(3,1:3) = {11,12,13}
A = 
{
  [1,1] =  1
  [2,1] = Hello
  [3,1] =  11
  [1,2] =  2
  [2,2] = Amita
  [3,2] =  12
  [1,3] =  3
  [2,3] = Shukla
  [3,3] =  13
}
```

All these things look simple, but it took me a lot of time to debug these errors in my code. So beware! 
 
For greater insight into it, you can look into the official [MATLAB page](http://in.mathworks.com/help/matlab/matlab_prog/access-data-in-a-cell-array.html). 
 
On a side note, I used the [Online Octave Tool](http://octave-online.net/) to test the above code, as MATLAB is proprietary, Octave is suitable for most of the purposes.
