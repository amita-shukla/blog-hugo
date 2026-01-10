---
title: Writing ORC files using Map Reduce
tags:
- BIG DATA
- HIVE
- JAVA
- PROGRAMMING
author: Amita Shukla
date: '2017-01-04'
slug: writing-orc-files-using-map-reduce
type: post
draft: false
showTableOfContents: true
---
Let's talk about text files first. Storing data as text files is the simplest thing to do. But there are many, many other requirements that just cannot be fulfilled by that. Dealing with text data comes with its challenges... 


 


### Hey, why don't you text me?

#### Delimiters.

The delimiters give a hard time. When you have huge data to handle (we are talking about Big Data here), storing them as text files means we need to define a character that separates the data into columns and rows. But what if this special character is a part of the data itself? So, if you think that ^ is a character that is highly unlikely to occur in the data, you will most probably encounter it in the next batch! You do need data munging to make sure the data doesn't get messed up.

 


#### Performance.

Being Selective, suppose you have a huge dataset and you wish to query a small part of it. Let's say you write a query in Hive. But to answer your query on text data, hive now needs to read the whole data set until it finds the result. This incurs performance penalties.

 


### Column Oriented Formats

Then comes this thing called Column Oriented Formats. According to Tom White in Hadoop The Definitive Guide :

_A column-oriented layout permits columns that are not accessed in a query to be skipped._

So, if I need to read a single columns only, then also the whole row is loaded into the memory. But with column oriented formats you can escape that. Hence, it gives you performance benefits when we need to fire queries involving only a small number of columns.

Column oriented formats need to maintain row splits in buffer, hence they need memory for reading and writing purposes.

 


### ORC File Format

First thing first, ORC stands for Optimised Row Columnar. ORC is under the project Apache Hive, is used to efficiently store Hive data.It offers excellent compression ratios through the use of Run length encoding. Data stored in ORC format can be read through HCatalog so any Pig or MapReduce program can work with ORC format seamlessly.

 


### Writing ORC using MapReduce

ORC files can be written using Java MapReduce. For this, we need a Mapper class and a driver class.

Let us suppose we have data stored in the form of text files, in HDFS. We need to migrate that data to a hive table storing it in ORC format.

Consider the data first:
```
12,2013-07-25 00:00:00.0,1837,CLOSED,134,4,100.0,25.0,Hockey,Fitness
17,2013-07-25 00:00:00.0,2667,COMPLETEs,93,3,74.97,24.99,Lacrosse,Fitness
21,2013-07-25 00:00:00.0,2711,PENDING,37,0,69.98,34.99,Baseball & Softball,Fitness
116,20133-07-26 00:00:00.0,8763,CLOSED,135,3,66.0,22.0,Hockey,Fitness
117,2013-07-26 00:00:00.0,5812321,SUSPECTED_FRAUD,135,3,66.0,22.0,Hockey,Fitness
131,2013-07-26 00:00:00.0,10072,PROCESSING,9300,5,124.95,24.99,Lacrosse,Fitness
```
 
Now, it's time to write the mapper. 
```java
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hive.ql.io.orc.OrcSerde;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.typeinfo.TypeInfo;
import org.apache.hadoop.hive.serde2.typeinfo.TypeInfoUtils;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Mapper;

public class FileMapper extends Mapper<LongWritable, Text, NullWritable, Writable>{
	
	private OrcSerde serde;
	private String types;
	private TypeInfo typeInfo;
	private ObjectInspector objectInspector;
	private List<Object> struct;
	private ArrayList<ColumnDatatypeMapping> mapping;
	
	@Override
	protected void setup(Mapper<LongWritable, Text, NullWritable, Writable>.Context context){
		
		serde = new OrcSerde();
		types = "struct<order_id:int,order_date:date,order_customer_id:int,order_status:string,order_product_id:int,order_quantity:int,order_subtotal:double,order_product_price:double,sub_category:string,category:string>";
		typeInfo = TypeInfoUtils.getTypeInfoFromTypeString(types);
		objectInspector = TypeInfoUtils.getStandardJavaObjectInspectorFromTypeInfo(typeInfo);
		mapping = new ArrayList<ColumnDatatypeMapping>();
		
		//create mapping, in the same order as in the text file
		
		mapping.add(new ColumnDatatypeMapping("order_id", "int"));
		mapping.add(new ColumnDatatypeMapping("order_date", "date"));
		mapping.add(new ColumnDatatypeMapping("order_customer_id", "int"));
		mapping.add(new ColumnDatatypeMapping("order_status", "string"));
		mapping.add(new ColumnDatatypeMapping("order_product_id", "int"));
		mapping.add(new ColumnDatatypeMapping("order_quantity", "int"));
		mapping.add(new ColumnDatatypeMapping("order_subtotal", "double"));
		mapping.add(new ColumnDatatypeMapping("order_product_price", "double"));
		mapping.add(new ColumnDatatypeMapping("sub_category", "string"));
		mapping.add(new ColumnDatatypeMapping("category", "string"));		
	}
	
	@Override
	protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException{
		String delimiter = ",";
		String[] data = value.toString().split(delimiter);
		struct = TextParser.buildList(data, mapping);
		Writable row = serde.serialize(struct, objectInspector);
		context.write(NullWritable.get(),row);
	}
	
}
```
 
The mapper contains two methods, `setup()`and `map()`. 
The `setup()` method contains the code that is run once for all the instances of `map()` that are launched. The ORC Serde requires to specify the type string - A string that specifies the column name and the corresponding data types. Next, I create a `mapping` object, a mapping between columns and their datatypes. This mapping is used in the `map()` method later. 
 
The `map()` method contains the code to read each line, process it, and write it in ORC format at the specified location. But, as seen from the signature, each line comes in `Text` format. For storing the data in respective data types, we spilt the line into columns and parse the data type according to the `mapping` object using the method `buildList()`. The `buildList()` method returns a list of objects, i.e. the parsed data in its respective data type. 
 
The Driver class for calling the mapper is written like this: 

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hive.ql.io.orc.OrcNewOutputFormat;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;



public class FileMapperDriver extends Configured implements Tool{
	public static void main(String[] args) throws Exception {
		ToolRunner.run(new FileMapperDriver(), args);
	}

	@Override
	public int run(String[] args) throws Exception {
		Configuration conf = this.getConf();
		Job job = Job.getInstance(conf);
		job.setJarByClass(FileMapperDriver.class);
		
		job.setMapperClass(FileMapper.class);
		job.setNumReduceTasks(0);
		
		job.setInputFormatClass(TextInputFormat.class);
		FileInputFormat.addInputPath(job, new Path(args[0]));
		
		job.setOutputFormatClass(OrcNewOutputFormat.class);
		OrcNewOutputFormat.setOutputPath(job, new Path(args[1]));
		
		job.setOutputKeyClass(NullWritable.class);
		job.setOutputValueClass(Writable.class);
		
		job.waitForCompletion(true);
		return 0;
	}

}
``` 
 
The method `setNumReduceTasks()` sets the number of reducers to 0. This is an indication that the output of the mapper goes as the final output. The input and the output path are taken as the arguments. For writing in ORC, we set the output key as `NullWritable` and output value as `Writable.` 


Let me now provide other POJOs used here : 
```java
public class ColumnDatatypeMapping {
	String colName;
	String colType;
	
	public ColumnDatatypeMapping(String colName, String colType) {
		super();
		this.colName = colName;
		this.colType = colType;
	}
	
}
```
```java
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class TextParser {

	public static List<Object> buildList(String[] data, List<ColumnDatatypeMapping> mapping) {
		
		List<Object> struct = new ArrayList<Object>();
		try{
		for (int i = 0; i < mapping.size(); i++) {
			String dataType = mapping.get(i).colType;
			String colData = data[i];
			if (dataType.toLowerCase().startsWith("tiny")) {
				struct.add(Integer.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("small")) {
				struct.add(Integer.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("int")) {
				struct.add(Integer.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("big")) {
				struct.add(Integer.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("double")) {
				struct.add(Double.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("decimal")) {
				struct.add(Float.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("string")) {
				struct.add(colData);
			} else if (dataType.toLowerCase().startsWith("varchar")) {
				struct.add(colData);
			} else if (dataType.toLowerCase().startsWith("char")) {
				struct.add(colData);
			} else if (dataType.toLowerCase().startsWith("bool")) {
				struct.add(Boolean.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("binary")) {
				struct.add(Byte.valueOf(colData));
			} else if (dataType.toLowerCase().startsWith("date")) {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
					struct.add(new java.sql.Date(formatter.parse(colData).getTime()));
			} else {
				struct.add(colData); //lets keep the default data type as string
			}
		}
		}catch (Exception e){
			System.err.println("Skipped row : " + data.toString()); 
			e.printStackTrace();
		}
		return struct;
	}

}
``` 
 
 
In the above method `buildList()`, I have caught the exception instead of throwing it so that the mapper doesn't stop entirely if the data is not according to its expected datatype (Suppose a null value). 
 
For running the application, export the class files in a jar archive, and then execute the hadoop jar command, providing the input and output HDFS locations: However, here it is important to export the `HADOOP_CLASSPATH`. Also, all external jars needed, like here, I included the hive jars under the libjars option. 


```shell
 $ classpath=`echo /usr/lib/hive/lib/* | sed 's/ /:/g'`
 $ export HADOOP_CLASSPATH=\"$classpath\"
 $ libjars=`echo /usr/lib/hive/lib/* | sed 's/ /,/g'`
 $ hadoop jar ORCWriter.jar FileMapperDriver -libjars $libjars /user/cloudera/in /user/cloudera/output 
```
