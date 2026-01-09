---
title: Database Performance - Concatenated Indexes and Order of Columns
tags:
- DATABASE
author: Amita Shukla
date: '2022-07-20'
slug: database-performance-notes-concatenated-index
type: note
draft: false
---
## Concatenated Indexes
Sometimes the primary key of a table may not be unique, defining an index on a single column as such will not be the most optimal use of an index. This is because if we define an index over a non-unique column, it will have to do a less performant RANGE SCAN instead of UNIQUE SCAN to access all the results. In this case, we can define an index over multiple columns over which uniqueness is guaranteed. Such an index is called a **Concatenated Index**. e.g. we can have our primary key defined as (`employee_id + sub_division_id`), and can define an index over these two columns.

Hence, a unique scan happens for a query like:
```sql
SELECT first_name, last_name
  FROM employees
 WHERE employee_id   = 123
   AND subsidiary_id = 30
```

But, now if we want to search over a single column like below:
```sql
SELECT first_name, last_name
  FROM employees
 WHERE subsidiary_id = 20
```
Here, the index will not be useful, and instead, a FULL TABLE SCAN will be done.

For making the above query use an index, we can define the index in reverse order of columns (`subsidiary_id +  employee_id`). Now, all the nodes with the same `subsidiary_id` are next to each other in the index, and hence the database can use the index now.

#### Use Concatenated Index:
- When uniqueness is guaranteed over multiple columns.
- When search is done using the leftmost columns. An index with three columns can be used when searching for the first column, when searching with the first two columns together, and when searching using all columns.
- Over creating multiple indexes to save space. 
- To save maintenance overhead. **The fewer indexes a table has, the better `insert`, `delete` and `update` performance.**

Hence it is important to not only know how an index works, but also to know what will be the most frequently used queries, to be able to define an index that will actually be useful.