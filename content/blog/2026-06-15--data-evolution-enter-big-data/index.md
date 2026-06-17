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

The challenge was no longer just managing data — it was managing **massive volumes of data, arriving at high velocity, in a variety of formats**, while remaining cost-effective and scalable.

This gave rise to a new generation of technologies collectively referred to as Big Data: instead of relying on larger and more powerful machines, these systems embraced horizontal scaling, distributing storage and computation across clusters of commodity hardware.

## Separation of Storage and Compute
