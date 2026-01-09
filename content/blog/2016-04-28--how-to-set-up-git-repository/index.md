---
title: How to set up Git Repository
tags:
- GIT
- PROGRAMMING
- PROJECT
cover: Github.png
author: Amita Shukla
date: '2016-04-28'
slug: how-to-set-up-git-repository
type: post
draft: false
---
<re-img src="Github.png"></re-img>

 
Its been a while I have been working with git and Github. But I almost forgot how confused I got at the the starting! I could understand all the theory and command, but how to start? This was a big question back then. 
 
In this article, I would like to discuss about as to how you can set up your git repository and get going. 
Its simple, you can merge any of your coding activities with git, enjoy a better control over your code and save yourself if anything gets messed up! 
 
I will discuss the theory , commands and other aspects in probably some other article. For this one, I am focusing on the basic setup (as the heading says). 
 


### Prerequisites

#### Git installed in your system

<https://git-scm.com/downloads>

 


I use git in both my operating systems, Ubuntu and Windows. And the command line is my favourite tool. 
In debian systems, the command is as simple as:

 


`sudo apt-get install git` 
 
For windows, I have downloaded the Git Bash desktop app ( woohoo! ). Sorry Git GUI I will touch you some other time!

 


#### GitHub Account

We need a remote repository too. I have worked on other ones like BitBucket, but GitHub is good to go with.

 


### Let's Start

#### Create Online Repository

Log in your GitHub account and click the '**+**' sign. This is the first thing that GitHub asks you to do.

 


Create a repository. Let's say you name it 'hello-world'.

 


Observe the pattern of naming. Lowercase letters and spaces marked by hyphens.

You can give it the description you want, as it says, it is optional.

 


Let all other things remain as it is. If you wish, though, you can add a README.md file here as well, but I prefer creating it afterwards (just a preference).

 


You are done here until now.

 


#### Configure Account

Lets move to you local machine. The local machine is the system on which you will be working, on which you save your code and have installed git.

 


First of all, Configure Your Account on your computer. Enter the commands: 
 
`git config --global user.name \"your-user-name\"`

`git config --global user.email \"your-email\"`

 


This is how you have informed the git as to what your user name is and by what name should it recognize you.

 


#### Create Local Repository

Now its the time to set up your local workspace, i.e. the directory where you will be working.

Create a local directory at your preferred location with the same name as your online repository name (again, a preference, nothing else).

 


`mkdir hello-world`

 


Move to this newly created directory

 


`cd hello-world`

 


Now your are in the directory. I have been calling it a directory and not arepository because it is not yet. Let's initialize it as a git repo.

 


`git init`

 


You will observe a hidden directory named '.git' here. This indicates you have initialized it.

 


#### Work now!

Now you can work on this repository the way you like and code as many files you want. When you create a file, just add it:

 


`git add \"file name\"`

 


or your can add all files in a go

 


`git add .`

 


This let's the git to monitor changes. You call this action as 'Staging'

 


Now that your files are staged, you can work on it and want to permanently store the changes. Do it by using the git commit command:

 


`git commit -m 'commit message'`

 


The commit message tells about the reason of commit .

 


Do not worry if you have done something wrong, you can always revert back to any previous commit anytime.

 


#### Connect To remote Repository

Let the git know that to which remote repository you want it to point to:

 


`git remote add origin \"link to GitHub repository\"`

 


This link is mentioned at the side of your repository page. Make sure you choose http version. We will try the ssl way some other day!

 


#### Push Changes To GitHub

You can push the changes to your remote repository from time to time.

 


`git push origin master`

 


The command asks you your user name and password. Don't worry if the password is not shown typed. It is an excellent feature of Linux systems.

 


If an error is displayed like:

 


`ssl certificate problem:self signed certificate in certificate chain`

 


Try the command:

 


`git config --global http.sslVerify false`

 


 


Explore More

A lot more can be done with git. We can fork, branch, merge and what not!

 


I have a repository that is a cheat sheet for git at the following link:

<https://github.com/amita-shukla/git-guide>

 


