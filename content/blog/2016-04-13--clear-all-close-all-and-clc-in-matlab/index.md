---
title: Clear all, close all and clc in MATLAB
tags:
- MACHINE LEARNING
- MATLAB
- PROJECT
author: Amita Shukla
date: '2016-04-13'
slug: clear-all-close-all-and-clc-in-matlab
type: post
draft: false
showTableOfContents: true
---
I was studying some machine learning projects I glanced over the following startup lines: 


 


clc;

close all;

clear;

 


I myself have used these commands several times assuming that they clear the workspace, and the command window. But what actually happens?

 


#### clc

As the documentation says, the clc command :

> clc clears all input and output from the Command Window display, giving you a \"clean screen.\"

As the screen is cleared, we can still have a look at the commands used by using the up arrow key. 
 


#### close all

The close all command deletes all figures from the screen.

 


#### clear

The clear command removes all the variables from current work space thus releasing up the system memory.

 


Also there is the function:

 


#### clear all

There is also the command clear all. This command as the documentation says, clears items from the memory and resets the MuPAD Engine.

 


Instead of the clear all command, the clear command must be used. This is because it takes a longer time to startup as it clears the cache memory as well. Here, the MuPAD engine is the part of the Symbolic Toolbox.

 


The difference between clear all and clc is explained in [this](http://stackoverflow.com/q/36575677/3858467) Stack Overflow question I asked.

 


