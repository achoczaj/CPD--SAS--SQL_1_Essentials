/*******************************************************************************

Getting Started with the SQL Procedure - a collection of snippets

from Summary of Lesson 1: Getting Started with the SQL Procedure
ECSQL193 - SAS SQL 1 - Essentials

- describe the key features of the SQL procedure
- describe the inputs and outputs of the SQL procedure
- describe the differences between the SQL procedure and the DATA step
- compare the basic terminology of SAS, data processing, and the SQL procedure
- describe the key features of PROC SQL syntax
- describe the clauses in a SELECT statement
*******************************************************************************/


/*******************************************************************************
1. Understanding the Basics about PROC SQL
*******************************************************************************/
/*
PROC SQL is a procedure in Base SAS that implements Structured Query Language. PROC SQL conforms to the ANSI standard for SQL and also extends beyond that standard. In PROC SQL, you can take advantage of SAS enhancements such as formats, labels, and functions.

PROC SQL is a tool for retrieving, manipulating, and managing data. One of the main tasks that you perform by using PROC SQL is to retrieve data by selecting the variables and observations that you want to analyze (query the data).

PROC SQL can read two types of SAS data sets – SAS data files and SAS data views – as well as database management system (DBMS) tables.

PROC SQL complements but does not replace the DATA step. Each method has advantages.

SQL and SAS use different terminology, as shown below:

SAS	    | Data Processing	| SQL
data set	    | file	    | table
observation	  | record	  | row
variable	    | field	    | column

When you use PROC SQL in your SAS programs, you follow the same basic process that you use to create any SAS program:
1. Define the business need.
2. Plan the output.
3. Identify the data.
4. Write the program.
5. Run the program.
6. Review the results.
7. Debug or modify the program.


/*******************************************************************************
2. Understanding PROC SQL Syntax
*******************************************************************************/
/*

  PROC SQL<options>;
        <additional statement(s);>
  QUIT;

There are some differences between the syntax of a PROC SQL step and the syntax of other PROC steps.

To start the SQL procedure, you specify the PROC SQL statement.

Following the PROC SQL statement are one or more other statements that perform tasks such as querying data.

When SAS executes the PROC SQL statement, the SQL procedure starts to run. SAS executes each statement in the PROC SQL step immediately, so no RUN statement is needed.

PROC SQL continues to run until it encounters a step boundary and stops running. At the end of a PROC SQL step, you can specify a QUIT statement as an explicit step boundary. The beginning of another step – a PROC step or a DATA step – is also a step boundary.
  SELECT object-item <, ...object-item>
        FROM from-list
        <WHERE sql-expression>
        <GROUP BY object-item <, ...object-item>>
        <HAVING sql-expression>
        <ORDER BY order-by-item <DESC>
                            <, ...order-by-item>>;

The SELECT statement, also called a query, retrieves data from one or more tables and creates a report that displays the data.

The SELECT statement can contain a combination of two to six clauses, which must appear in the order shown above. The first two clauses – SELECT and FROM – are the only required clauses. The function of each clause is listed below:

The SELECT clause specifies the columns that you want to appear in the output and indicates the order in which you want them to appear.
The FROM clause specifies one or more tables that contain the data you need.
The WHERE clause selects a subset of rows to be processed. o The GROUP BY clause classifies the data into groups. o The HAVING clause subsets groups of data.
The ORDER BY clause sorts rows by the values of one or more columns.
The SELECT statement ends in a semicolon – there is only one semicolon in an entire SELECT statement.

The SELECT statement generates a report by default.

When you submit a PROC SQL query, the SQL processor analyzes your query and determines the most efficient way to process it.

/* 2.2 Checking Query Syntax without Executing the Program */

To check your program syntax efficiently, you can tell SAS to compile a PROC SQL statement or step without executing it. To check PROC SQL syntax without executing a statement or step, you can use the VALIDATE statement or the NOEXEC option.

The VALIDATE statement must appear just before a SELECT statement, followed immediately by a query-expression. If your PROC SQL program contains multiple queries, you must specify the VALIDATE statement before each query that you want to validate.

VALIDATE query-expression;
To check the syntax of all statements in your PROC SQL program without executing the program, you can specify the NOEXEC option in the PROC SQL statement.

PROC SQL NOEXEC;
Like all PROC SQL options, the NOEXEC option stays in effect until PROC SQL encounters a step boundary or until you issue a RESET statement within the PROC SQL step.

/*******************************************************************************
Sample Programs
*******************************************************************************/
/* 1. Checking Query Syntax by Using the VALIDATE Statement */
proc sql;
validate
select Employee_ID, Job_Title
   from orion.staff;
validate
select Employee_ID, Employee_Name,
       Postal_Code
   from orion.employee_addresses
   where Postal_Code contains '33'
   order by Postal_Code;
quit;

/* 2. Checking PROC SQL Syntax by Using the NOEXEC Option */
proc sql noexec;
select Order_ID, Product_ID
   from orion.order_fact
   where Order_Type=1;
select Product_ID, Product_Name
   from orion.product_dim;
quit;
