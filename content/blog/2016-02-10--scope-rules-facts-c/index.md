---
title: Scope Rules In C
tags:
- C
author: Amita Shukla
date: '2016-02-10'
slug: scope-rules-facts-c
type: post
draft: false
---
Variables to programming is the same as words to a language. These are probably the first thing that we start to deal with as soon as we start making programs. But as we go on more and more, we get to face an issue: 
\"To what parts of the program is this variable accessible?\" 
 
Even if we get the answer to the above question, we may not be satisfied. 
What if I want this variable to be accessible to only a few functions of the file? 
What if I want this variable to be accessible outside this file as well? 
What if I want this variable to never change? 
What if I want this variable to be accessed faster? 
 
When we start write a program, we want to govern the way it works, instead of being governed by it! Understanding the scope rules helps us to handle the behaviour of variable easily. 
 


### What is a Scope?

A scope of a name is the part of the program within which the name can be used. 
 
So, if you use a variable 'a' as follows: 

```c
if(condition){
	int a = 1;
	printf("%d", a); //works
}
	printf("%d", a); //compilation error
```     
 
then you can access the variable in the scope of the `if` section and no where else. 
 


### Local Variables : Automatic

The variables described as above are called automatic variables, aka local variables. 
For an automatic variable declared at the beginning of the function, the scope is the function in which it is declared. It is recreated every time the function is called. Local variables of the same name in different functions are unrelated. 
 
The parameters of a function are also regarded as local variables to that function. 
Automatic variables are the simplest ones we deal with. We can declare them as 
 
`auto int a;` 
 
or simply, 
 
`int a;` 
 


#### 

#### Register Variables

Some variables can be declared as register. This declaration 'advises' the compiler to place the variable in machine register, for faster access (may be due to very frequent use). However, the compiler can ignore this advice as well. If that is the case, the register variables are treated similar to automatic variables.

 


Register variables come with some restrictions:

- A limited number of variables can be placed in registers,
- A register declaration can be applied to automatic variables and formal parameters to a function,
- It is not possible to know the address of a register, hence & operator cannot be applied.

The above restrictions may vary from machine to machine. 
 


What if we want a variable to be accessed outside a function?

### Global Variables: External

If we declare a function at the beginning of the file, it is accessible all throughout the file. If we place it somewhere in between the definitions of two functions, it is accessible to all functions following the declaration. 
As beautifully illustrated in K&R : if we want some variables to be common to the `push()` and `pop()` functions, but not visible to other functions such as `main()`, then we can declare them after the `main()` function and before the `push()` and `pop()` functions.

```c
main() { ... }
	
int sp = 0;
double val[MAXVAL];
	
void push(double f) { ... }
	
double pop(void) { ... }
``` 
 


The variables `top` and `val` are called external variables. 
But what if we want to use a variable before it is defined?

or,what if it is defined in a different source file other than in which it is being used?

In such case, we need to declare the variable extern: 
```c
In file 1:
	extern int sp;
	extern double val[];
	
	void push(double f) { ... }
	double pop(void) { ... }
	
In file 2:
	int sp = 0;
	double val[MAXVAL];
```
 
Here, the variables `sp`, `val` are defined in file 2, so to use them in file 1, we need to declare these variables as `extern` to be accessed by `push()` and `pop()` functions. 
 


### Static Variables

The static keyword is used to modify scope in several ways 


#### External static

There are a few variables or function that we may want to use privately in that file. The static keyword, applied to an external variables, limits the scope of that object to the rest of the source file being complied. Similarly, if a function is declared as static, then the name is only visible to the file in which it is declared, instead of being visible to the entire program (as functions are global). 
 


#### Internal static

If a variable is declared as static inside a function, they are local to the function (like the automatic variables), but its value persists through the entire life of the program. This means that internal static variables provide private, permanent storage within a single function. 
 
 
The external and static variables are restricted to be assigned only constant and initialized only once, whereas automatic and register variables may be constant, or a part of expression, or can be assigned to the result of a function call. 
 
