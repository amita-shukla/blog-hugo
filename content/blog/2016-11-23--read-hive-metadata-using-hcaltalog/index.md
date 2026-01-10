---
title: Read Hive metadata using HCatalog
tags:
- BIG DATA
- HCATALOG
- HIVE
- PROGRAMMING
author: Amita Shukla
date: '2016-11-23'
slug: read-hive-metadata-using-hcaltalog
type: post
draft: false
showTableOfContents: true
---
Apache Hive is a client side library that is used to provide an abstraction of the data in HDFS, in the form of tables. Hive jobs are internally converted to MR plan, submitted to Hadoop cluster for execution. Now let's move on to know what is the Hive metastore. 
 


### The Metastore

The Hive table definitions and mappings are stored in what is called the Hive Metastore. The metastore is nothing but two of its components : 


- A service to which the Hive Driver connects to and queries the database schema.
- A relational database to hold metadata, suppose MySQL.

So what if we have some hive tables, and we want to work on this metadata while, suppose, using Pig? We can either make a way out to query metadata using our own tool, or we can make use of the Hive metadata that is already stored.

 


Here comes the job of HCatalog.

 


### HCatalog

As discussed, HCatalog makes Hive metadata available to users of other Hadoop tools like Pig, MapReduce, Hive (yes! why not!). It provides connectors for MR and Pig so that users can read/write from/to hive metastore. HCatalog provides read and write interfaces for Pig and MapReduce and uses Hive’s command line interface for issuing data definition and metadata exploration commands. Once you have the HDFS data stored in Hive, then you do not need to rewrite the schema when using other tools. You can directly access metadata of tables using HCatalog.

 


HCatalog has some other functions as well:

- Users do not need to worry about the data format being used. Table abstraction presents users a relational view of data. HCatalog supports reading and writing files in any format for which a Hive SerDe (serializer-deserializer) can be written.
- It also presents a REST interface to allow external tools access to Hive DDL (Data Definition Language) operations, such as “create table” and “describe table”.
- Notification service : Notifies workflow tools, e.g. Oozie that some data has changed.

Today we will discuss using HCatalog in Java.

### Why not JDBC?

Now that you know that hive metastore is stored in a relational database, why not make a simple JDBC connection? Why not directly query this meta table stored in MySQL using simple SQL queries? I too had the same doubt, but there can be a few reasons for not doing so.

- What if you do not get the credentials? We know that to connect using JDBC, we need to provide the username and password. But what if you are not given access to that? Have a look at [this](http://stackoverflow.com/questions/22964302/is-there-a-way-to-access-hive-metastore-tables-from-hcatalog) StackOverflow question to understand what I am talking about. HCatalog gives you good info about metadata, without the need to directly access it.
- Just a connection to HCatClient does it all. One does not need to go into further details of the connection or provide any other configuration settings. HCatalog abstracts it all for us.

### The Code

Now let us see how we can code HCatalog to get Hive metadata.

First of all, we need the required dependencies :

```xml
 <dependency>
	<groupId>org.apache.hive.hcatalog</groupId>
	<artifactId>hive-hcatalog-core</artifactId>
	<version>0.13.0</version>
</dependency>

<dependency>
	<groupId>org.apache.hive.hcatalog</groupId>
	<artifactId>webhcat-java-client</artifactId>
	<version>0.12.0</version>
</dependency>
```


 
Apart from these, we may need other dependencies as well, so as to be able to run the complete application. 
Now, let's start writing our main program. In this example, I have attempted to extract the column details of a table in hive. Therefore, I have put the result in a HashMap that maps column name to the extracted information. 
 
```java
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hive.hcatalog.api.HCatClient;
import org.apache.hive.hcatalog.api.HCatTable;
import org.apache.hive.hcatalog.data.schema.HCatFieldSchema;

import com.shukla.pojo.Metadata;

public class ReadTableMetadata {

	public static Map<String, Metadata> getMetadata(String databaseName,
			String tableName) throws SQLException {

		Map<String, Metadata> metadata = new HashMap<String, Metadata>();
		Writer writer = null;
		try {
			writer = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream("metadata.txt"), "utf-8"));
			Configuration conf = new Configuration();
			conf.addResource(new Path("file:////etc/hive/conf/hive-site.xml"));
			HCatClient client;
			client = HCatClient.create(conf);
			HCatTable hcatTable = client.getTable(databaseName, tableName);
      
			List<HCatFieldSchema> fields = hcatTable.getCols();
			for (HCatFieldSchema field : fields) {
				Metadata m = new Metadata();
				m.setTableName(tableName);
				m.setColumnName(field.getName());
				m.setDataType(field.getTypeString());
				metadata.put(field.getName().toUpperCase(), tm);
				writer.write(field.getName().toUpperCase() + "=" + tableName
						+ "," + field.getName());
				writer.write('\n');
			}
			writer.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return metadata;
	}

	public static void main(String[] a) {
		try {

			Map<String, Metadata> metadata = getMetadata("default",
					"orders");
			//do somthing with metadata
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
}
```

Here, class `Metadata` contains the extracted metadata. 
 
```java
public class  Metadata{
	@Override
	public String toString() {
		return tableName + ", "
				+ columnName + ", " + dataType + ", "
				+ isPrimary;
	}

	private String tableName;
	private String columnName;
	private String dataType;
	private boolean isPrimary;

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getColumnName() {
		return columnName;
	}

	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}

	public String getDataType() {
		return dataType;
	}

	public void setDataType(String dataType) {
		this.dataType = dataType;
	}

	public boolean isPrimary() {
		return isPrimary;
	}

	public void setPrimary(boolean isPrimary) {
		this.isPrimary = isPrimary;
	}
}
```

The output is stored in metadata.txt file, as follows: 
```
ORDER_ID=orders,order_id,int
ORDER_DATE=orders,order_date,date
ORDER_CUSTOMER_ID=orders,order_customer_id,int
ORDER_STATUS=orders,order_status,string
ORDER_PRODUCT_ID=orders,order_product_id,int
ORDER_QUANTITY=orders,order_quantity,int
ORDER_SUBTOTAL=orders,order_subtotal,float
ORDER_PRODUCT_PRICE=orders,order_product_price,float
```

Also, as we discussed the other approach, let's see its code as well : 

```java
import java.util.List;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import org.apache.hadoop.hive.conf.HiveConf;
import org.apache.hadoop.hive.conf.HiveConf.ConfVars;

import org.apache.hadoop.fs.Path;

public class ReadHiveMetaDataJdbc {

	private static String driverName = "org.apache.hive.jdbc.HiveDriver";

	public static void main(String[] args) throws SQLException {
		try {
			Class.forName(driverName);
			HiveConf conf = new HiveConf();
			conf.addResource(new Path("file:////etc/hive/conf/hive-site.xml"));

			Class.forName(conf.getVar(ConfVars.METASTORE_CONNECTION_DRIVER));
			Connection conn = DriverManager.getConnection(
					conf.getVar(ConfVars.METASTORECONNECTURLKEY),
					conf.getVar(ConfVars.METASTORE_CONNECTION_USER_NAME),
					conf.getVar(ConfVars.METASTOREPWD));

			Statement st = conn.createStatement();
			ResultSet res = st.executeQuery("Select * from db_name.name_of_metadata_table");
			List<Metadata> metadata = new ArrayList<>();
			while (res.next()) {
				Metadata m = new Metadata();
				m.setTableName(res.getString("Table_Name"));
				m.setColumnName(res.getString("Column_Name"));
				m.setDataType(res.getString("Data_Type"));
				m.setPrimary("Y".equals(res.getString("Is_Primary")));
				metadata.add(m);
				System.out.println(m.toString());
			}

			conn.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.exit(1);
		}
	}
}
``` 
 
As we can see, here we require the connection and configuration settings. These settings may change over time and that is the reason I prefer the first approach. 
The effort to use HCatalog pays off. On one hand, we access data in the file system, copy/paste data, keep it in different file formats, run jobs on that data, and what not. On the other hand, HCatalog relieves us from the worries of dealing with data stored in any format, any schema. This makes us developers really powerful. We can now harness the full potential of data while sticking to the Hadoop framework.
