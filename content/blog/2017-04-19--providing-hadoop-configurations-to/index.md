---
title: Providing Hadoop Configurations to MapReduce Application using ToolRunner
tags:
- BIG DATA
- HADOOP
- JAVA
- MAPREDUCE
- PROGRAMMING
author: Amita Shukla
date: '2017-04-19'
slug: providing-hadoop-configurations-to
type: post
draft: false
---
Let's talk about Map Reduce Programming. It is simple in the first go. In fact, dealing with distributed systems has never been simpler. Design your job into Map and Reduce tasks. Implement these functions, create a jar, and run the hadoop jar command on your Hadoop cluster. Voila! A whole lot of things done on any amount of data. 
But, Map Reduce runs with its default set of configurations, and these defaults may not fit your particular case. When it comes to dealing with big data over a distributed environment, we need some tweaks every now and then. 
 


### Let's take an example.

The number of Reducers. If the number of reducers is more, then it results in a lot of reshuffling over the network and reduces performance. If it turns out to be less, then it anyways results in overloading each reducer with too much of map data. So what is the solution? Make the number of reducers configurable, on each run, depending on the data you are dealing with. 
 
The above example was just one of the configs. You may require a lot more : 
```
-conf : specify an application configuration file 
-D : use value for given property 
-fs : specify a namenode 
-jt : specify a job tracker 
-files : specify comma separated files to be copied to the map reduce cluster 
-libjars : specify comma separated jar files to include in the classpath. 
-archives : specify comma separated archives to be unarchived on the compute machines.
```

 


So, there has to be a way to plug in these configurations into the code from outside. Now, for running our Map Reduce job, we need to fire the hadoop jar command : 


`hadoop jar <jar-path> <class-name> <options>`

We know that the options passed through command line are directly treated as arguments to the java program. Here is where the role of Tool Runner comes to play.


> _The ToolRunner is a command interpreter. It works in conjunction with GenericOptionsParser to parse the generic hadoop command line arguments and modifies the Configuration of the Tool. The application-specific options are passed along without being modified._


Let's see the difference with this small program : 
```java
public class Test extends Configured implements Tool {

  public static void main(String[] args) throws Exception {
      System.out.println("Arguments in main method : ");
      for(String arg : args)
        System.out.println(arg);
      
      int statusCode = ToolRunner.run(new Configuration(),new Test(), args);
      System.exit(statusCode);
    }
    
  @Override
	public int run(String[] args){
      System.out.println("Arguements in run method : ");
      for(String arg : args)
          System.out.println(arg);

      return 0;
  }

}
``` 


 
I trigger the following command : 

`hadoop jar tool.jar Test -Dmapred.reduce.tasks=0 arg1 args2`
 
The output of the above program is as follows: 
 
```
Arguments in main method : 
-Dmapred.reduce.tasks=0
arg1
args2
Arguements in run method : 
arg1
args2
```

 
As we can see, all the arguments are taken as it is by the main method. However, when the run method is called the ToolRunner magic happens. It interprets the configurations passed to the program and separates them out of the other arguments. 
 


## How ToolRunner works?

To get a deeper understanding of what happens under the hood, let's have a look at the source code of the ToolRunner class : 
 
```java
public class ToolRunner {

 /**
Runs the given Tool by Tool.run(String[]), after parsing with the given generic arguments. Uses the given Configuration, or builds one if null. Sets the Tool's configuration with the possibly modified version of the conf.
Parameters:
conf Configuration for the Tool.
tool Tool to run.
args command-line arguments to the tool.
Returns:
exit code of the Tool.run(String[]) method.
**/

public static int run(Configuration conf, Tool tool, String[] args) 
  throws Exception{
  if(conf == null) {
    conf = new Configuration();
  }
  GenericOptionsParser parser = new GenericOptionsParser(conf, args);
  //set the configuration back, so that Tool can configure itself
  tool.setConf(conf);
  
  //get the args w/o generic hadoop args
  String[] toolArgs = parser.getRemainingArgs();
  return tool.run(toolArgs);
}
```

It's pretty simple. The run method internally calls the GenericOptionsParser : the class that does the command line arguments parsing, and parses the options. The call to run() at the last calls the run() of the Tool class, that is responsible for triggering the job. 
 
Now that we have our Hadoop settings as well as our arguments handled pretty well, we can focus on the rest of our MapReduce application!

