---
title: Find all possible subsets of a given set
tags:
- ALGORITHMS
- JAVA
- PROGRAMMING
author: Amita Shukla
date: '2015-12-25'
slug: find-all-possible-subsets-of-given-set
type: post
draft: false
showTableOfContents: true
---
The problem is: Given a set of distinct integers, S, return all possible subsets.

Elements in a subset must be in non-descending order.

The solution set must not contain duplicate subsets.

Also, the subsets should be sorted in lexicographic order.

 


For example: For the set `[1,2,3]`,

The solution would be:

```
[
[],
[1],
[1, 2],
[1, 2, 3],
[1, 3],
[2],
[2, 3],
[3],
]
```
 


This problem can be approached by visualizing a tree:

``` 
     [       ] 
    /    \   \ 
  [1]    [2]  [3] 
  /  \     \
[1,2][1,3] [2,3] 
   | 
[1,2,3] 
```

Start with an empty node. Then, take one element. Let it be at an index `i` of the given set.

The tree can be constructed by trying out the elements at the indexes after `i`.

Each possibility makes a new branch.

The branching ends when we have tried out all the possibilities.

 


The following code explains the above lines: 
 

```java
import java.util.ArrayList;
import java.util.Collections;

public class FindSubsets {
  static ArrayList<ArrayList<Integer>> sets;

  public ArrayList<ArrayList<Integer>> subsets(ArrayList<Integer> set) {

    Collections.sort(set);
    sets = new ArrayList<ArrayList<Integer>>();
    sets.add(new ArrayList<Integer>());
    backtrack(set, 0, new ArrayList<Integer>());

    return sets;
   }

  public static void backtrack(ArrayList<Integer> set, int index, ArrayList<Integer> partial) {

    for (int i = index; i < set.size(); i++) {
      ArrayList<Integer> subset = new ArrayList<>(partial);
      subset.add(set.get(i));
      sets.add(subset);
      backtrack(set, i + 1, subset);
    }
  }
}
```
 
Get the code at: <https://github.com/amita-shukla/programs/blob/master/FindSubsets.java>
