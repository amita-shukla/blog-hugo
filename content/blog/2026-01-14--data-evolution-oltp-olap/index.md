---
title: Foundations of Data Systems: OLTP, OLAP, and What Came Next
date: '2026-01-14'
tags: 
- BIG DATA
- DATABASE
type: post
draft: false
slug: data-evolution-oltp-olap
author: Amita Shukla
showTableOfContents: true
---
# Since time immemorial…

... humans have recorded data — we started almost five thousand years ago and never stopped. This data was primarily of 2 types — structured and unstructured data. People were making records of transactions in everyday life, be it trade, ownership, inventory, and events. As societies grew, these records naturally took **structured forms**: ledgers, tables, and predefined formats that made tracking and reconciliation possible. 

Fast forward to the era of digitization - with the rise of computing systems, organizations inherited these same assumptions. Early business applications dealt almost exclusively with structured, well-defined data — orders, users, payments, inventory. This data had to be:

- accurate
- consistent
- durable

Managing such data reliably led to the emergence of **Database Management Systems (DBMSs)**. These systems organized data into databases and tables, enforced relationships, and guaranteed correctness through transactional guarantees. Their primary purpose was to support day-to-day business operations — recording transactions, updating state, and serving user requests. These systems later came to be known as **Online Transaction Processing (OLTP)** systems. 

As organizations matured, the same operational data began serving a different purpose. Businesses wanted to analyze historical trends, generate reports, and support decision-making. These analytical workloads had very different characteristics: large scans, aggregations, and long-running queries, often across months or years of data. This requirement led to a new branch of **Online Analytical Processing (OLAP) systems**, also known as **Data Warehouses**, which were fundamentally different in how they processed data. Let’s understand these in detail.

# Database Management Systems - OLTP

- Used by applications to record day to day transactions. e.g. PostgreSQL, MySQL, SQL Server, Oracle and many more.
- The definition of data is clearly defined (schema) and organized into databases, tables and the relationships between them, also known as Relational Database Management Systems (RDBMSs).
- These were relatively simple transactions which needed to be efficient, as well as maintain consistency in real time. This led to the support of ACID properties: Atomicity, Consistency, Isolation, Durability.
- Structured Query Language (SQL) is used to fetch the data from these systems.

# Data Warehouses - OLAP

- Used to analyze data to support in decision making. Some popular ones are, Teradata, IBM Netezza, Bigquery, Snowflake, Redshift.
- These systems store historical data. The data is stable and not updated in real time, unlike operational data.
- These analytical workloads are separate from operational workloads, which allow for tracking performance or trends over months and years. These queries run for longer periods of time.
- The data is structured, but they are stored in the form of facts (measures/metrics) and dimensions (context/attributes).

## OLTP v/s OLAP

As discussed above, while OLTP systems are used by applications for day to day operations, OLAPs are used to analyze data to support decision making. This difference in requirement led to fundamental differences between the queries that are run on these applications, as well as how the data is organized for both.

### Transactions v/s no Transaction Support

As the name suggests, the primary purpose of OLTP systems is to process database transactions. OLTP systems are used for tasks such as processing orders, updating inventory, managing customer accounts etc. Hence it becomes imperative for these systems to support ACID properties at all times. 

Since analytical queries in OLAP do not usually modify data or depend on strict ordering of concurrent updates, enforcing full ACID semantics (especially fine-grained locking and immediate consistency) would add unnecessary overhead and reduce query performance. Instead, OLAP systems prioritize throughput and query efficiency over transactional isolation at the row level.

### Normalization v/s Denormalization

For OLTP systems, data was kept normalized to remove redundancy and maintain consistency. e.g. for an application there would be tables such as users table, products table, transactions table. The transaction table contains `transaction_id`, `user_id`, `product_id`, `timestamp`. This is a normalized schema. No information is duplicated.

On the other hand, for OLAP systems, keeping data normalized soon becomes a problem. The queries are long and may span over hundreds of tables. That meant joins over these tables. This made the queries hugely inefficient. Consistency carries less importance here as the results are often aggregated over columns, so inconsistent data over a few rows in inconsequential. So, it was better to keep data at one place, denormalized. e.g. this could mean there is a single table `clickstream_data` , with all columns at one place. The query starts with a simple select statement and only the columns that need to be selected are mentioned in the query (so only the relevant data is pulled in). 

### Joins v/s no Joins

The above normalization v/s denormalization directly expands to this, but it's worth mentioning separately.
- OLTP systems are designed to execute frequent, low-latency joins efficiently, often involving a small number of rows identified by indexes or primary keys.
- Aggregation-heavy workloads in OLAP systems benefit far more from columnar storage and compression than from complex join optimization.
- Joins exist but aren’t the primary optimization target in OLAP. Data warehouse schemas are often designed to reduce join depth, favoring star or snowflake schemas over deeply normalized relational models.

### Row based v/s Column based

The OLTP queries typically fetch an entire row (or part of it) against a primary key. e.g. if we hit a users table, we would use a query like

```sql
select user_id, user_name, user_status from users where user_id = 123;
```

Here, the query receives multiple columns in a row across the users table against the user_id `123`.

On the other hand, OLAP queries span across a column in the entire table. e.g. an analytical query might be something like:

```sql
select count(user_id) from users where user_status = 'inactive';
```

Here, the aim is to count the number of inactive users.

As we can observe, the intent of the queries on these systems is different, and hence it makes sense that the underlying storage of this data is saved differently. As OLTP queries mostly span across rows in the table, the data is stored row-wise, i.e., the entire row is stored together. For OLAP, the queries span across columns, so the data also is stored column-wise, i.e. each column is stored together.

Because the access patterns are different, the underlying storage layout is optimized differently:

- **Row-based storage** stores all columns of a row together, making it efficient for point lookups and transactional workloads (OLTP).
- **Column-based storage** stores values of the same column together, enabling high compression and fast scans for analytical workloads (OLAP).

```java
// representational purposes only
// row wise storage of users table
(1,bob,active),(2,alice,inactive),(3,chris,active)...

// column-wise storage of users table
user_id:      1,2,3
user_name:    bob,alice,chris
user_status:  active,inactive,active
```

A few more pointers worth mentioning for row and column based storage:

- Column-wise storage enables high compression and efficient vectorized execution, which makes large-scale aggregations much faster.
- OLAP systems can fetch rows, and OLTP systems can do aggregations — it’s about what they are *optimized for*, not what they *can do*.

### Performance

OLAP processing times can vary from minutes to hours depending on the type and volume of data being analyzed. To update an OLAP database, you periodically process data in large batches then upload the batch to the system all at once. Data update frequency also varies between systems, from daily to weekly or even monthly.

In contrast, you measure OLTP processing times in milliseconds or less. OLTP databases manage database updates in real time. Updates are fast and short. Stream processing is often used over batch processing.

## Problems with traditional Data Warehouses

Traditional data warehouses were designed for a world where data was structured, predictable, and relatively slow-growing. As data volume and usage patterns evolved, several fundamental limitations became apparent.

- Scaling traditional warehouses usually meant scaling up, not out. This involved expensive proprietary hardware, specialized storage systems, and licensed software.
- With huge amount of data they got slower and resource intensive, with ETL pipelines becoming slow and brittle.
- Traditional data warehouses meant for processing structured data. These fell short for the rising demands of analysis over unstructured data, such as logs, text, images.

Despite their strengths, early OLTP and OLAP systems were fundamentally constrained by assumptions about data shape, scale, and access patterns.

- **Semi-Structured and Unstructured Data:** Traditional systems expected well-defined schemas and relational structures. Data such as logs, events, text, images, and JSON did not fit naturally into these models, making ingestion and analysis difficult or inefficient.
- **Cheap Horizontal Scaling:** Most systems scaled vertically by adding more powerful hardware. Scaling horizontally across commodity machines was either unsupported or extremely complex, limiting how economically systems could grow with data volume.
- **Real-Time Analytics at Scale:** Combining high ingestion rates with low-latency analytical queries was largely infeasible. Systems were optimized either for transactions or for batch analytics, but not both at scale.

These unresolved challenges created the conditions for a new class of systems — ones that favoured distributed storage, flexible schemas, and horizontal scalability — setting the stage for the rise of Big Data platforms.

Together, OLTP and OLAP defined the early data landscape — both operating on structured data, both essential, but each shaped by fundamentally different requirements. Understanding these constraints explains why early data systems were designed the way they were, and also hints at the limitations that would later push the industry toward new paradigms.
