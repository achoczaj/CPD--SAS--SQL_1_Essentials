/*******************************************************************************

Measuring Efficiencies - a collection of snippets

from Summary of Lesson 1: Measuring Efficiencies
ECSQL193 - SAS SQL 1 - Essentials

- write a basic query that displays all of the columns in a table
- display the attributes of all of the columns in a table
- specify columns by name to display in output
- create and populate a table by using a query
- select a subset of rows to display in output
- eliminate duplicate rows in output
*******************************************************************************/


/*******************************************************************************
1. Specifying Columns Directly from a Table
*******************************************************************************/
/* 1.1 Viewing the Contents and Structure of a Table */
Topic Summaries

Overview of Computing Resources You should consider various programming techniques based on their ability to conserve specific resources, such as CPU time, I/O, and memory. In some cases, data storage space or network bandwidth might be an issue. The following table shows the resources that SAS programs require:

Term	Definition
CPU	The amount of time that the central processing unit, or CPU, uses to perform tasks such as calculations, reading and writing data, conditional logic, and iterative logic
I/O	A measurement of the Read and Write operations that the computer performs as it copies data and programs from a storage device to memory (input and output)
memory	The size of the work area in volatile memory the computer requires for holding executable program modules, data, and buffers
data storage space	Physical space on mass storage devices
network bandwidth	The available throughput for data communications

To determine which efficiency trade-offs to make, you’ll have to consider your SAS programs, the data that you read and create, and the characteristics of your site. Examples of trade-offs include the following:
Saving disk space by compressing data requires more CPU time to uncompress data the next time it’s read.
Reducing I/O by increasing buffer size requires more memory to hold the buffers.
Assessing Your Site's Efficiency Needs No single set of programming techniques is most efficient in all situations. Before you can select the most efficient programming techniques, you need to understand your site’s technical environment and resource constraints, and then decide for yourself what your critical resources are. Here are some factors to consider.
Hardware: In terms of hardware, you can analyze the amount of available memory, the number of CPUs, the number and type of peripheral devices, the communications hardware, network bandwidth, storage capacity, I/O bandwidth, and the capacity to upgrade.
System Load: To determine system load, you can look at the number of users or jobs sharing system resources, the expected network traffic, and the predicted increase in load over time.
Operating Environment: You should also understand how your operating environment allocates resources, schedules jobs, and performs I/O.
SAS Environment: You should know which SAS software products are installed, the number of CPUs and amount of memory allocated for SAS programs, and which methods are available for running SAS programs at your site.
It is important to understand your programs and data. The number of times the program is executed affects whether saving more resources is worth the time and effort. As either programs or data increase in size, your potential for savings improves. You should focus on improving the efficiency of large programs, programs that read large amounts of data, or programs that read many data sets. Knowing whether your data is mostly character or numeric, whether it contains missing values, and whether and how it is sorted will help you choose programming techniques.
Using Benchmarks to Compare Techniques To decide which technique is most efficient for a given task, you can benchmark, or measure and compare, the resource usage of each technique. Here are some guidelines for benchmarking SAS programs:
Run your SAS programs against the actual data to determine which technique is the most efficient.
Run your tests under the conditions that your final program will use.
Here is the benchmarking process and a few more guidelines:
Turn on the appropriate SAS options to report resource usage.
Test only one technique or change at a time, with as little additional code as possible. You should start at the beginning and make one change at a time to pinpoint resource usage.
Run each program three to five times and base your conclusions on averages, not on a single execution. Averaging is particularly important when you benchmark elapsed time.
Test each technique in a separate SAS session. SAS can look ahead to the next step; for instance, if two steps are the same type, SAS can determine not to unload and reload the same SAS procedure.
When you finish testing, turn off the options that report resource usage, because they consume resources.
When you analyze your results, you should exclude outliers. Data from outliers might lead you to tune your program to run less efficiently than it should.
Using SAS System Options to Track Resources The following options control the resource usage statistics that SAS writes to the log for each SAS step:
STIMER: On by default in all operating environments. This option prints the familiar statistics for real time and CPU time in the SAS log after each step.
FULLSTIMER (called FULLSTATS in z/OS): More useful than STIMER for benchmarking; writes all available system performance statistics to the SAS log. The statistics shown vary by SAS version and operating environment.
STATS and MEMRPT (z/OS only): Used to control the statistics that are printed. STATS controls whether any statistics are listed, and MEMRPT specifies whether memory usage statistics are written to the SAS log.
Here’s the syntax for specifying options to track resource usage in different operating environments:

Windows and UNIX
OPTIONS STIMER | NOSTIMER;

OPTIONS FULLSTIMER | NOFULLSTIMER;

z/OS
OPTIONS FULLSTATS | NOFULLSTATS;

OPTIONS STATS | NOSTATS;

OPTIONS MEMRPT | NOMEMRPT;

STIMER | NOSTIMER (invocation only)
