---
title: '''C''ing again! - Use of double pointer in Linked List Insertion'
tags:
- C
- DATA STRUCTURES
author: Amita Shukla
date: '2015-12-22'
slug: cing-again-use-of-double-pointer-in
type: post
draft: false
showTableOfContents: true
---
As I was checking out some programming questions on the topic linked list, it was boring to just read the programs without implementing them. 
So, I decided to try out linked list again, trying to devise out some more efficient ways to solve a very simple problem. 
But before playing with the list, I needed to create a list. 
 
During the process, I revised an old concept: 
Why do we need to use double pointer whenever we need to change the head pointer? 
The function that I had to write was `insbgn()`. 
 
**Insertion at the beginning of the list:** 
 
Initial declarations: 

```c
struct node{ 
  int data; 
  struct node *next; 
}; 
 
typedef struct node *nodeptr; 
```
 
On can think of the following implementation: 

```c
void insbgn(nodeptr head, int data){ 
  nodeptr p = getnode(); 
  p->next = head; 
  head = p; 
}
``` 
 
But you will observe no changes if you make a call to this function: 

```c
  print(head); //output: 1 2 3 4 5 6 
  insbgn(head, 0); 
  print(head); //output 1 2 3 4 5 6 
```
 
This is because the head pointer is changing here. When `insbgn()` is called, the pointer 'head' points to the head of the list. 
Changes are made to the list accordingly but as soon as the function returns, the changes to the head are lost. 
 
To show this, if I call `print(head)` from inside `insbgn()`: 

```c
void insbgn(nodeptr head, int data){ 
  nodeptr p = getnode(); 
  p->next = head; 
  head = p; 
  print(head); 
} 
```
 
The output is: 

```c 
  print(head); //output: 1 2 3 4 5 6 
  insbgn(head, 0); //output: 0 1 2 3 4 5 6 
  print(head); //output 1 2 3 4 5 6 
```
 
Hence you need to pass double pointer, i.e. pointer to the head pointer. 
 
So, the correct way to define `insbgn()` is as follows: 
 

```c
void insbgn(nodeptr *headptr, int data){ //you get a pointer to the head pointer 
  nodeptr p = getnode(data); 
  p->next = *headptr; // p->next points to the value at headptr, i.e. the head of the list 
  *headptr = p; // the value at headptr is set to p, i.e., head = p. 
}
``` 
As we have the pointer to the head, we can easily dereference it and manipulate the real head. 
If you do not know any other example than the swap problem for pass by value and pass by reference, this is another one you can count on! 
But if you really want to use the previous version, you will need to return the new head back: 
 

```c
nodeptr insbgn(nodeptr head, int data){ 
  nodeptr p = getnode(data); 
  p->next = head; head = p; 
  printf("Linked list inside insbgn\n"); 
  print(head); 
  printf(\"\n\"); 
  return head; 
}
``` 
And call it like: 
`head = insbgn(head,data);` 
The problem with this approach is that you can assign the new head, and later go mad figuring where you got wrong.
