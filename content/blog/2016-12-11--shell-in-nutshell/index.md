---
title: Shell In A Nutshell
tags:
- PROGRAMMING
- SHELL
cover: m1rI9.png
author: Amita Shukla
date: '2016-12-11'
slug: shell-in-nutshell
type: post
draft: false
---
It looks like I am getting quite proverbial these days. For those who didn't understand, I was talking about the title. I am working on automation of my project in office, and it involved a lot of SHELL scripting. Oh yes, you got it now. Please don't kill me.

 


![image](m1rI9.png)

 


Back a few years I took up shell scripting in college, did some of it and then forgot it. I still have those programs somewhere in my backup drive, with a few loops and a few commands like echoing date, your name, etc. I made another modification that the script asked for your name and then echo,`\"Hi <your name> ! Nice to meet you! \"` . Then I got bored, as studying the syntax without any actual purpose did not interest me. But that knowledge definitely helped me understanding how Linux commands work and how I can play around with them.

 


I claimed I know some of shell scripting, and so was handed a two days deadline to automate the whole thing. Looks like even the experts claim to know 'some' shell scripting. I learnt a lot while I was on it, that I am going to write here.

 


### The Variables

Of course, declaration of a variable was never difficult. Where can I go wrong here?

`path = \"/path/to/some/directory/that/I/will/use/a/lot/many/times\"`

on using the command `cat $path/some-fancy-name-of-dir/some-fancy-name-of-a-file`

I get a \"no such file or directory\" error. After an hour of toil and reading shell scripting basics, I realized the problem was the spaces : before and after '`=`' . After writing lots of neat and formatted code, I was subconsciously doing it. No unnecessary spaces Amita, No.

 


### The Quotes

Single quotes for string. Double quotes for variables in string.

 


### The Curly Braces for Isolating a Variable

If I have a variable `$var` and I want to append '`_temp`' to `$var` and assign it to another variable `$var2`, I would write it as :

`var2=${var}_temp` , instead of confusing the shell by writing `$var_temp`.

 


### Indirect Expansion using !

! is used for indirect expansion, that is, introducing one level of expansion of variable. Let me illustrate:

```shell 
var1=first
var2=second
i=1
readvar=var$i
echo $readvar #prints var1
echo ${!readvar} #prints first, i.e. the value of $var1
```
 
### Replace command

The replace command comes handy whenever I want to replace string in-place in files. As simple as:

`replace from to from to <input-file >output-file`

It is really convenient as I used it for replacement of multiple strings. But I had to be careful that I had to use different files for input and output.

 


### Sed

Yes, this is the time. Finally got my hands dirty with sed.

Sed is a stream editor, comes handy when you want to modify files, or do some complex manipulation in each line of each file. Just write the script, or use it directly, to one or more files. Sed does what the replace does, and much more than that. I dealt mainly with the substitution command, and delete command.

- My purpose : to replace one string with another string. As simple as:`sed 's/from/to/g' <input-file >output-file`
- Here, the 's' stands for substitution, and 'g' defines it global. If used without the 'g'. Sed will replace only the first occurrence of each line.
- Use double quotes instead of single if you want to use variables instead of the actual string.
- The/is a delimiter. If there is a / in the string itself, we can use any other delimiter, such as colon ( : )
- Similar to s, you can use 'd' to delete the line in which the string matched.
- One of my tasks was to remove anything that occurs after a string in each line. For this, we can simply use sed :`sed 's/word*/word'`

 


The list seems too short for now. Possibly it is rather the experience that counts. We can learn a hundred facts from books, as I did in college, but it is its application that brings that confidence in you.
