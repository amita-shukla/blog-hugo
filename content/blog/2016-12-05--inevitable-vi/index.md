---
title: Inevitable Vi
tags:
- PROGRAMMING
- SHELL
- TECHNOLOGY
cover: main-qimg-f157a9584f79e958652338eae9a28fc9.png
author: Amita Shukla
date: '2016-12-05'
slug: inevitable-vi
type: post
draft: false
---
Ok I confess, I had heard like a hundred times that you just can't escape Vi, the powerful text editor of all times. But even when I had worked on Ubuntu or to say, Linux machine for a while, I never felt that dire need to work on Vi. Oh common, you have GEdit! Or Nano -- I had used it a number of times. And then, of course, I knew a few commands (I know only some even now), and my favourite was `:q!` , just in case I accidently get to use Vi. 


 


But it has been a while that I have been using Vi. It was never that I had any kind of aversion from it, so when I had to access some distant server using Putty that offers you no GUI support for Gedit, or no Nano, you had to venture into the Vi world. So from `:q!` , I moved to `:wq`.

 


<re-img src="main-qimg-f157a9584f79e958652338eae9a28fc9.png"></re-img>

 


 


I am not going to write the regular stuff that I read when I was learning to use Vi. I am just going to jot down a few commands that I keep handy while using Vi. This list will be expanding definitely.

 


### History Repeats Itself

And when such situation arises, just type `:` or `/` to navigate or edit to the previous command you used. The command `:his` lists the command history, and `:his/` lists the search history.

### Arrow keys work, check.

My Ubuntu machine gave me a tough time using Vi. Why? Because I was not even able to navigate! This was because arrow keys are not enabled in Vi. You need to use `hjkl` instead. And this is because arrow keys are 'far' in the keyboard. Well, I had a deadline to meet, so I used `:set nocompatible` to deal with it.

 


### Insert Mode

Yes, though it happened only initially, I would forget to go into insert mode and start typing, and something else will happen to my file! Yes, some commands get executed. Oh God why! I finally learnt my lesson. The best way was to be in insert mode only when typing. Any pause in typing, I press `esc` and then press `i` when resuming.

 


### Line numbers

You won't get your script right on running the script the first time. All you get is a line number!

Press `esc`, and then use the command `:set nu` for displaying the line numbers.

I used the `goto` command for moving to a particular line number. Press `esc`, then type your line number (yes, the line number you type won't show) and then press `shift+g`. Your cursor will move to that location. If you do not specify a line number, it moves to the end of file.

 


### Undo

Tried some command and whoosh! a disaster happened. Haha! `ctrl+z` is not going to work. press `esc+u`. Thank god this exists.

 


### Redo

With undo comes redo (is it because they rhyme?) . press `esc` and then a dot (`.`) .

 


### Find and Replace

- `:%s/from/to` does it.
- `/word` highlights all the word in the document.
- Press `n` for find next and `N` for find previous.

The special characters, like `.` and `\_` should be used with a back slash `\\` .

 


### Highlighting

It is similar to finding all occurrences of a word. If highlighting is enabled, the `*` key will highlight all occurrences of the word that is under the cursor. I stumbled into doing this by mistake, but it made me realize that Vi is no less than any other recently developed text editor. 
And obviously, following the above find options does our job of highlighting. 
 


### Moving To the First Line

Just pressing `gg` (key `g` two times) places the cursor on the first line.

 


There is a lot to learn, and a lot to explore. [This](http://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118) post on StackOverflow is a must read for those who want to grasp the power of Vi. And though the list seems short now, I will keep adding up more and more as I keep on working on Vi.
