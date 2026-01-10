---
title: Undo everything in Git - Part 1
tags:
- GIT
cover: git.png
author: Amita Shukla
date: '2019-12-14'
slug: undo-everything-in-git-part-1
type: post
draft: false
showTableOfContents: true
---
I use git for most of my projects now, at work and off work. While I am easily able to save history on git, I need to get back to man pages to be able to manoeuvre through the git history backwards. So I decided to jot down how to rewind your git history, and undo the changes at several stages. 
 


![image](git.png)

 
Let's go bottom-up: 


- [Undo git init](#undo-git-init)
- [Undo unstaged work](#undo-unstaged-work)
- [Undo staged work](#undo-staged-work)
  - [git rm --cached v/s git reset HEAD \<file\>](#git-rm---cached-vs-git-reset-head-file)
- [Undo commit - change commit message and other info](#undo-commit---change-commit-message-and-other-info)
- [Undo a commit by making another commit](#undo-a-commit-by-making-another-commit)
- [Undo a commit - and erase its history](#undo-a-commit---and-erase-its-history)
  - [Undo the commit and get your changes back on staging area](#undo-the-commit-and-get-your-changes-back-on-staging-area)
  - [Undo the commit and don't keep the changes](#undo-the-commit-and-dont-keep-the-changes)
- [Undo not the latest commit](#undo-not-the-latest-commit)
  - [Rebase](#rebase)
- [Delete a branch](#undo-all-work-in-a-branch)
    - [Safe delete](#if-the-branch-has-no-unmerged-changes)
    - [Force delete](#if-the-branch-has-unmerged-changes)

### Undo git init

I created a git repository inside a directory using the git init command. A git repository can be created in an empty repository or can be created with files already in it. 
 

```shell
 $ git init
 Initialized empty Git repository in /home/ashukla/git_repo_demo/.git/
```
 
But I decided I did not want git, or I just initialized git repo at a completely wrong place. To undo creating a git repository, you simply delete the .git repository. 
 

```shell
 $ rm -r .git/
```
 
The `.git/` directory is the git database that contains all the necessary information about the repo. Deleting the repo deletes the existence of git all altogether and your directory loses all its versioning superpower. 
 


### Undo unstaged work

But I hope you went ahead with git. You created some files to code on and then some work on them. But your code is like poetry, and you would rather throw it away and start afresh. You have not done anything using git on these files till now. 
 

```shell
 $ git status
 On branch master
 No commits yet
 Untracked files:
 (use \"git add ...\" to include in what will be committed)
 file1
 file2
 file3
 nothing added to commit but untracked files present (use \"git add\" to track)
```
 
As you see above, we have 3 files which have not yet been touched by git. Git calls these files **untracked**. It simply means that these files have not yet started to be tracked by git. At this stage, anything you do with these files is not tracked by git, and cannot be reverted using git also. 
To delete these files, just delete these files. 
 

```shell
 $ rm file1 file2 file3
```
 


But, at some point, you may be at a stage where some of your files are tracked, and some are not. Overall, you have added the work that was going to be committed, and only want to delete the work that was left untracked. For that, you may run the `clean` command. It is recommended that you first see what all would be deleted using -n flag and only then continue deleting: 
 

```shell
 $ git clean -n
 Would remove file1
 Would remove file2
 Would remove file3

 $ git clean -f
 Removing file1
 Removing file2
 Removing file3

 $ git status
 On branch master
 No commits yet
```
 


### Undo staged work

So after doing a number of deletions and additions, you finally end up with some work that is up for commit. You stage these changes by using git add command. All the work that is staged goes as a part of the next commit. At this point, note that, it has only been staged and not been commited. 
 

```shell
 $ git status
 On branch master
 No commits yet
 Changes to be committed:
 (use \"git rm --cached ...\" to unstage)
 new file: file1
 new file: file2
 new file: file3
```
 
But what if some changes did not need to go to the next commit? Suppose we need to unstage file3. Git has always been helpful in suggesting the next possible steps, so here we do the same. 
 

```shell
 $ git rm --cached file3
 rm 'file3'

 $ git status
 On branch master
 No commits yet
 Changes to be committed:
 (use \"git rm --cached ...\" to unstage)
 new file: file1
 new file: file2
 Untracked files:
 (use \"git add ...\" to include in what will be committed)
 file3
```
 
Note here we did what was suggested by git for us to do. There is however another suggestion that is sometimes made by git that is to do a `git reset`. So what's the difference? For that, we first need to understand what the command `git rm` does: 


 


_Remove files from the index, or from the working tree and the index. git rm will not remove a file from just your working directory_

 
Here working tree is the tree of committed files, and index is the staging area. In simpler terms, git rm is used to remove a file from a Git repository. It is a convenience method that combines the effect of the default shell rm command with git add . This means that it will first remove a target from the filesystem and then add that removal event to the staging index. Let's try it on terminal: 
 

```shell
 $ git rm file3
 error: the following file has changes staged in the index:
 file3
 (use --cached to keep the file, or -f to force removal)
```
 
As we have not committed anything yet, so there is no working tree. Therefore we get a warning.

Now if I go via the shell `rm` command: 
 

```shell
 $ rm file3
 $ git status
 On branch master
 No commits yet
 Changes to be committed:
 (use \"git rm --cached ...\" to unstage)
 new file: file1
 new file: file2
 new file: file3
 Changes not staged for commit:
 (use \"git add/rm ...\" to update what will be committed)
 (use \"git checkout -- ...\" to discard changes in working directory)
 deleted: file3
```
 
As you see above, git suggests us to record the deletion event of file3 separately by using `git add` or `git rm` 

```shell
 $ git rm file3
 rm 'file3'
 $ git status
 On branch master
 No commits yet
 Changes to be committed:
 (use \"git rm --cached ...\" to unstage)
 new file: file1
 new file: file2
```
 
This way, we have deleted the file from filesystem as well as from staging area. Please note at this point that our original intent was to just unstage the file, i.e. undo the add, and not delete the file completely. I have gone a little ahead to understand `git rm` at the first place. Now that we know `git rm`, `git rm --cached` simply means:

 


_--cached_
_Use this option to unstage and remove paths only from the index. Working tree files, whether modified or not, will be left alone._

All this means that by using --cached option with git rm, we only remove the file from the staging area (or index) and keep it in the file system. 
 

#### git rm --cached v/s git reset HEAD &lt;file>

Let's move on to commit a file here:

```shell
 $ git commit -m \"commit file1\"
 [master (root-commit) f4585bb] commit file1
 1 file changed, 1 insertion(+)
 create mode 100644 file1



 $ git status
 On branch master
 Changes to be committed:
 (use \"git reset HEAD ...\" to unstage)
 new file: file2

``` 


We have committed file1 here, having left with file2. Observe git suggestion here, instead of suggesting `git rm --cached` as it did before, it now suggests `git reset HEAD`. This is because before committing anything, there was no `HEAD` commit altogether. If we had gone ahead with `git reset` at that point, we would have gotten the error: `fatal: Failed to resolve 'HEAD' as a valid ref.` 
 
So why not use `git rm --cached` all the time? I actually don't know any definite answer to that, other than that if we forget `--cached` option, we might end up deleting our precious files forever. 
 
In short, do what git suggests, it's probably for the best. However, we should understand what is the meaning behind its suggestions, for that reason you can bookmark this blog post! 
 
We'll be moving on to commits next. Let's take some rest and revisit the commands... 
 


<!-- ![image](take_a_break_git.gif) -->

 
 


- Undo git init: rm -r .git/
- Undo unstaged/untracked files: git clean -n ; git clean -f
- Undo staging or unadd: git rm \[-r] --cached &lt;file> if no commits made, else git reset HEAD &lt;file>

 


### Undo commit - change commit message and other info

In the last section, we went a little ahead and made a commit.

 

```shell
 $ git log
 commit f4585bbdcce4ffb4c04fbac1fb0796c3ac3a2726 (HEAD -> master)
 Author: Amita Shukla <amita.shukla0906@work.com>
 Date: Fri Nov 1 00:14:37 2019 +0530

 commit file1
```
 
But wait! Now that I look at it, I realize that my commit message is not very helpful, and I would rather make it more descriptive. Also, I was using my work account here, instead of using my personal account. That's a mistake and I gotta amend it. The relief is, **this commit still lies on my local computer, i.e. this commit has not been pushed and it's guaranteed that I am the only one using it.** The --amend option can help me change the commit message: 
 

```shell
 $ git commit --amend
```

A new editor opens up. The top line is the commit message, which can be edited now:

```shell
 commit file1 to demonstrate the difference between git rm --cached and git reset
 # Please enter the commit message for your changes. Lines starting
 # with '#' will be ignored, and an empty message aborts the commit.
 #
 # Date: Fri Nov 1 00:14:37 2019 +0530
 #
 # On branch master
 #
 # Initial commit
 #
 # Changes to be committed:
 # new file: file1
 #
 # Untracked files:
 # file2
 #
```

Let's move on to change the author's email address. This can be done inline as: 

```shell
 $ git commit --amend --author=\"amita-shukla<amitashukla0906@gmail.com>\"

 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.

 # Please enter the commit message for your changes. Lines starting
 # with '#' will be ignored, and an empty message aborts the commit.
 #
 # Author: amita-shukla <amitashukla0906@gmail.com>
 # Date: Fri Nov 1 00:14:37 2019 +0530
 #
 # On branch master
 #
 # Initial commit
 #
 # Changes to be committed:
 # new file: file1
 #
 # Untracked files:
 # file2
 #
```
 
Let's have a look at out commit now: 


```shell
 $ git log
 commit 76ee43a95a3b56f7890c8d54e82ea931b916136b (HEAD -> master)
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Fri Nov 1 00:14:37 2019 +0530

 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.
```

Note that by using the `--amend` option, we are playing with the history of your commits. The official documentation for the amend option says: 
 


\--_amend_

_Replace the tip of the current branch by creating a new commit. ... You should understand the implications of rewriting history if you amend a commit that has already been published._


So... there are implications. Observe that, the SHA id generated after the amend is different from the one before. So this is effectively a new commit. So as I put it on bold above, it is important that the commit you are going to commit is not shared with other people. 
 


### Undo a commit by making another commit

Till now, we have added file1 and committed this file. Only now to realize this was a mistake and this commit should have never happened. So we need to undo the effects of the previous commit, and we want to be clear about it, by creating another commit. For this we run git revert HEAD:

```shell
 $ git revert HEAD
```
 
An editor window opens up: 


```shell
 Revert \"commit file1 to demonstrate the difference between git rm --cached and git reset\"
 This reverts commit 76ee43a95a3b56f7890c8d54e82ea931b916136b.
 # Please enter the commit message for your changes. Lines starting
 # with '#' will be ignored, and an empty message aborts the commit.
 # On branch master
 # Changes to be committed:
 # deleted: file1
 # Untracked files:
 # file2
```
Checking the git and filesystem status: 
 

```shell
 $ git status
 On branch master
 Untracked files:
 (use \"git add <file>...\" to include in what will be committed)
 file2
 nothing added to commit but untracked files present (use \"git add\" to track)

 $ ls
 file2
```
 
The previous commit resulted in the addition of file1, and hence reverting it resulted in the deletion of file. The commit logs clearly log the commits having this: 
 

```shell
 $ git log
 commit 071133e449b7dde9fced704d3bd88911440a3c62 (HEAD -> master)
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Fri Nov 1 19:26:47 2019 +0530
 Revert \"commit file1 to demonstrate the difference between git rm --cached and git reset\"
 This reverts commit 76ee43a95a3b56f7890c8d54e82ea931b916136b.

 commit 76ee43a95a3b56f7890c8d54e82ea931b916136b
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Fri Nov 1 00:14:37 2019 +0530
 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.

``` 


### Undo a commit - and erase its history

Well, you never really erase anything in git, once you have committed it. But here you are, you have made an embarrassing mistake and so you want to undo it, without it popping up in git log.

Let's start with the commits we had above:

```shell
 $ git log
 commit 071133e449b7dde9fced704d3bd88911440a3c62 (HEAD -> master)
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Fri Nov 1 19:26:47 2019 +0530
 Revert \"commit file1 to demonstrate the difference between git rm --cached and git reset\"
 This reverts commit 76ee43a95a3b56f7890c8d54e82ea931b916136b.

 commit 76ee43a95a3b56f7890c8d54e82ea931b916136b
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Fri Nov 1 00:14:37 2019 +0530
 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.

```
 


And suppose we want to undo the latest commit (here, this commit was deleting the file named file1). There are 2 ways of doing this: 
 


#### Undo the commit and get your changes back on staging area

For this we use `git reset`: 


```shell
 $ git reset --soft HEAD^

 $ git status
 On branch master
 Changes to be committed:
 (use \"git reset HEAD <file>...\" to unstage)
 deleted: file1
 Untracked files:
 (use \"git add <file>...\" to include in what will be committed)
 file2

 $ ls
 file2

 $ git log
 commit 76ee43a95a3b56f7890c8d54e82ea931b916136b (HEAD -> master)
 Author: amita-shukla <amitashukla0906 gmail.com>
 Date: Fri Nov 1 00:14:37 2019 +0530

 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.
```
 
**`git reset --soft` puts the changes made by the commit back to staging area**. The commit that we have undone here, deleted file1. On doing soft reset, it has gotten back to staging area, and being shown as deleted. The file system doesn't contain the file, because, as said earlier it was deleted. The `git log` only shows the previous commit now. 
 


#### Undo the commit and don't keep the changes

For this we use `git reset --hard`. Back to the state where we have to undo the latest commit:

 
```shell
 $ git reset --hard HEAD^
 HEAD is now at 76ee43a commit file1 to demonstrate the difference between git rm --cached and

 $ git status
 On branch master
 Untracked files:
 (use \"git add <file>...\" to include in what will be committed)
 file2
 nothing added to commit but untracked files present (use \"git add\" to track)

 $ ls
 file1 file2

 $ git log
 commit 76ee43a95a3b56f7890c8d54e82ea931b916136b (HEAD -> master)
 Author: amita-shukla <amitashukla0906 gmail.com>
 Date: Fri Nov 1 00:14:37 2019 +0530
 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.
```
 


As can be seen in the above snippet, on doing hard reset, we lose the changes made by the commit at all. So, we should use hard reset when we don't want changes done by the commit lurking around. So in our case, the commit performed the action of deletion, therefore on doing hard reset, file1 is back as a committed file, back in the filesystem, and the commit disappears from the log. 
 
Observe a small difference here in the syntax between reset and revert. We **write revert command as `git revert HEAD` but reset as `git reset HEAD^`**. So if you have to undo the `HEAD` commit, for revert you supply the last commit, but for reset you supply the one before the last commit. This is because `git reset` resets the commit to the supplied state. 
 


### Undo not the latest commit

We have been trying to rever the latest commit, denoted by HEAD. But what if we made a misguided commit, and then went on to do a series of commits? How to pick one commit from middle and revert those changes?

We can go with git revert. As described in the last section, git revert picks up the changes made by the commit, and reverts those changes into a new commit.

Or we call out the mighty rebase...

 


#### Rebase

Suppose we have the following 4 commits and I need to revert the commit with SHA ending with a6db3e (the 3rd commit): 
 

```shell
 $ git log
 commit 12ba23fd90a161b7762c82a6127bb9eecb0853ce (HEAD -> master)
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Sat Nov 2 22:32:34 2019 +0530
 create file4

 commit 0753b7231a33deba65afbbb0f364161bfea6db3e
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Sat Nov 2 22:32:03 2019 +0530
 create file3

 commit c4a38cb0b16d97cc60280d162a89576a3a153811
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Sat Nov 2 22:29:47 2019 +0530
 create file2

 commit 76ee43a95a3b56f7890c8d54e82ea931b916136b
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Fri Nov 1 00:14:37 2019 +0530
 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.
```
 
Execute the rebase command for a commit before: 
 

```shell
 $ git rebase -i c4a38cb0b16d97cc60280d162a89576a3a153811
```
 


This opens up an editor like this: 


```shell
 pick 0753b72 create file3
 pick 12ba23f create file4

 # Rebase c4a38cb..12ba23f onto c4a38cb (2 commands)
 #
 # Commands:
 # p, pick = use commit
 # r, reword = use commit, but edit the commit message
 # e, edit = use commit, but stop for amending
 # s, squash = use commit, but meld into previous commit
 # f, fixup = like \"squash\", but discard this commit's log message
 # x, exec = run command (the rest of the line) using shell
 # d, drop = remove commit
 #
 # These lines can be re-ordered; they are executed from top to bottom.
 #
 # If you remove a line here THAT COMMIT WILL BE LOST.
 #
 # However, if you remove everything, the rebase will be aborted.
 #
 # Note that empty commits are commented out
```
 
To delete the commit \"create file3\", we simply delete that line altogether. Save and quit the file. The logs now show up as: 
 

```shell
 $ git log
 commit 7a79af7ddbfb2ddba4624f63bed36ea89f4edfd7 (HEAD -> master)
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Sat Nov 2 22:32:34 2019 +0530
 create file4

 commit c4a38cb0b16d97cc60280d162a89576a3a153811
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Sat Nov 2 22:29:47 2019 +0530
 create file2

 commit 76ee43a95a3b56f7890c8d54e82ea931b916136b
 Author: amita-shukla <amitashukla0906@gmail.com>
 Date: Fri Nov 1 00:14:37 2019 +0530
 commit file1 to demonstrate the difference between git rm --cached and
 git reset command.


 $ ls
 file1 file2 file4
```

As we can see above, the commit doesn't exist anymore, and also no file3 exists in the filesystem. Remember, I called the rebase 'mighty' for this reason. If not careful, rebase changes history and you may lose your work. Rebase is like a swiss knife for git, and comes with a lot of powerful features (as listed in the editor window that opens up during interactive rebase), which if we discuss here may take this post off track. 

### Undo all work in a branch
If things are bad enough, you may want discard all work in that branch entirely.
#### If the branch has no unmerged changes
```git
git checkout master # you can't delete currently selected branch
git branch -d <branch name>
```
`-d` is an alias for `--delete`. This lets you delete the branch safely.
#### If the branch has unmerged changes
Deleting a branch that has unmerged changes would lead to forever losing your work. If you still wish to move ahead:
```git
git checkout <another branch>
git branch -D <branch name>
```
`-D` which stands for `--delete --force`, which forcibly deletes a branch regardless of whether it has been merged.

In this post, I have tried to put up all the undo steps that we may need on our local system, and for a single branch. A lot more is possible beyond the above list, and I have covered in the next post: [Undo everything in Git - part 2](https://amitashukla.in/blog/undo-everything-in-git-part-2/) .
 




