---
title: "Enter Big Data"
date: '2026-06-15'
tags: 
- BIG DATA
- DATABASE
type: post
draft: true
slug: data-evolution-enter-big-data
author: Amita Shukla
showTableOfContents: true
---
In previous post ()[], we discussed about OLTP and OLAP systems, and how they defined the early data landscape. Organizations relied on a combination of OLTP systems for operational workloads and data warehouses for analytics. This model worked well when data was primarily structured, generated at predictable rates, and could be processed in periodic batches. 

However, the growth of the internet fundamentally changed the nature of data. Organizations were no longer dealing with just transactional records and reporting tables. Websites, mobile applications, sensors, machine logs, clickstreams, and social media platforms began generating data at unprecedented scale.

Traditional systems struggled to keep up. Storing petabytes of data on expensive proprietary hardware became impractical. ETL pipelines grew increasingly complex, and analytical queries took longer to run. At the same time, businesses wanted insights faster, often in near real time.

The challenge was no longer just managing data — it was managing massive volumes of data, arriving at high velocity, in a variety of formats, while remaining cost-effective and scalable.

This gave rise to a new generation of technologies collectively referred to as **Big Data** -- instead of relying on larger and more powerful machines, these systems embraced horizontal scaling, distributing storage and computation across clusters of commodity hardware.

## Separation of Storage and Compute

Early databases and data warehouses were built on a simple assumption: the machine storing the data would also process it. To scale a sucha a system, an organization had to scale the entire machine - where the storage and compute resources were tightly coupled.

As organizations accumulated more data, however, a fundamental problem emerged. Storage and compute rarely grew at the same rate. For example, an organization might need to retain years of historical data, requiring additional storage capacity, but the computational requirements for querying that data might remain unchanged. Conversely, a team running a complex analytical workload might need more CPU and memory for a few hours, without requiring any additional storage.

The rise of distributed storage systems and cloud object stores made it possible to decouple these concerns. Data could be stored in a shared, durable storage layer, while compute resources could be provisioned independently and scaled according to demand. One of the earliest large-scale attempts at solving this problem was **Hadoop**, which introduced a distributed architecture for storing and processing data across clusters of commodity machines. Before understanding Hadoop, however, it is worth examining the programming model that inspired much of the early Big Data ecosystem: MapReduce.
