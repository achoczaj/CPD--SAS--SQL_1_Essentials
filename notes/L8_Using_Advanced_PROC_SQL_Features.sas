/*******************************************************************************

Using Advanced PROC SQL Features

from Summary of Lesson 8: Using Advanced PROC SQL Features
ECSQL193 - SAS SQL 1 - Essentials

- use dictionary tables and views to obtain information about SAS files
- use SQL procedure options to control processing details
- create and use SAS macro variables in PROC SQL
*******************************************************************************/


/*******************************************************************************
1. Querying Dictionary Information and Views
*******************************************************************************/
/* 1.1 Exploring Dictionary Tables */
/*
At initialization, SAS creates special read-only dictionary tables and views that contain information about each SAS session or batch job. Dictionary tables contain data or metadata about the SAS session.

SAS assigns the special reserved libref Dictionary to the dictionary tables.

Within the dictionary tables, SAS stores library and table names in uppercase. But, SAS stores column names in the dictionary tables in the same case in which they were defined when created. So, the column names can be all lowercase, all uppercase, or mixed case.

When you query a dictionary table, SAS gathers information that is pertinent to that table. The dictionary tables are only accessible with PROC SQL. Because dictionary tables are read-only, you cannot insert rows or columns, alter column attributes, or add integrity constraints to them.

SAS provides PROC SQL views, based on the dictionary tables, that can be used in other SAS programming steps such as the DATA or PROC step. These views are stored in the SASHelp library and are commonly called SASHELP views.
*/
/* 1.2 Querying Dictionary Information */
/*
To prepare for writing a specific query, you can use a DESCRIBE statement to explore the structure of dictionary tables.
  DESCRIBE TABLE table-1<, ... table-n>;

The output from the DESCRIBE TABLE statement is a CREATE TABLE statement written to the log that contains the column names and attributes.

Because the libref dictionary is automatically assigned, you don't need to use a LIBNAME statement to run this code.

Category:
 Table	--> Contents
1. Commonly used dictionary tables:
Dictionary.Dictionaries	--> Data about the dictionary tables that are created by SAS
Dictionary.Tables	--> Data about the contents of all the tables available in this SAS session
Dictionary.Columns	--> Information such as name, type, length, and format about all columns in all tables that are known to the current SAS session

2. SAS libraries and the contents of libraries:
Dictionary.Members	--> General information about the members of a SAS library
Dictionary.Views	--> Detailed information about all views available in this SAS session
Dictionary.Catalogs	--> Information about catalog entries

3. Indexes and integrity constraints:
Dictionary.Indexes	--> Information about indexes defined for all tables available in this SAS session
Dictionary.Table_Constraints	--> Information about the integrity constraints in all tables available in this SAS session
Dictionary.Check_Constraints	--> Information aabout check constraints in all tables available in this SAS session
Dictionary.Referential_Constraints	--> Information about the referential constraints in all tables available in this SAS session
Dictionary.Constraint_Column_Usage	--> Information about the columns that are referenced by integrity constraints
Dictionary.Constraint_Table_Usage	--> Information about tables that use integrity constraints

4. Global macro variables, SAS system options, and more:
Dictionary.Macros	--> Information about macro variables’ names and values
Dictionary.Options	--> Information about the current settings of SAS system options
Dictionary.Titles	--> Information about the text currently assigned to titles and footnotes
Dictionary.Extfiles	--> Information about currently assigned filerefs

*/
/* 1.3 Displaying Specific Metadata */
/*

SELECT object-item <, ...object-item>
      FROM table-1<, ... table-n>;

If you only want to select information about specific columns, you indicate the specific columns in the SELECT clause.

If you only want to display results from specific tables, not all tables currently available in this SAS session, you subset the tables using a WHERE clause in the query.
  SELECT object-item <, ...object-item>
      FROM table-1<, ... table-n>;
      WHERE libname='LIB-NAME';
When you query dictionary tables, you supply values to the WHERE clause in the appropriate case. Remember that library names are stored in dictionary tables in uppercase.

Because different dictionary tables might store similar data using different cases, you might be tempted to use SAS functions, such as UPCASE or LOWCASE. But, the WHERE clause won't process most function calls, such as UPCASE. The functions prevent the WHERE clause from optimizing the condition, which could degrade performance.
*/
/* 1.4 Using Dictionary Tables in Other SAS Code */
/*
In SAS procedures and the DATA step, you must refer to sashelp instead of dictionary.
Remember that PROC SQL views based on the dictionary tables are stored in the sashelp library.

In addition, in PROC and DATA steps, the libref cannot exceed eight characters. Most of the sashelp library dictionary view names are similar to dictionary table names, but they are shortened to eight characters or fewer. They begin with the letter v, and do not end in s. So to run correctly, you change dictionary.tables to sashelp.vtable.
*/
/* 1.5 Using Dictionary Views */
/*
To use a dictionary table in a DATA or PROC step, you can reference the views of the dictionary tables, which are available in the SASHelp library.

You can browse the library to determine the name or use the name of the dictionary table to extrapolate the view name.

The names of the views in SASHelp are similar to the dictionary table names, start with the letter v, are eight characters or less, and generally don't have an s on the end.
*/


/*******************************************************************************
2. Using SQL Procedure Options
*******************************************************************************/
/*
PROC SQL options give you finer control over your SQL processes by providing features that allow you to control your processing and your output.
*/
/* 2.1 SQL Options: Controlling Processing */
/*
Option	--> Effect
OUTOBS=n	--> Restricts the number of rows that a query outputs.
INOBS=n	--> Sets a limit of n rows from each source table that contributes to a query.
NOEXEC	--> Checks syntax for all SQL statements without executing them.
*/
/* 2.2 SQL Options: Controlling Display */
/*
Option	--> Effect
PRINT | NOPRINT	--> Controls whether the results of a SELECT statement are displayed as a report.
NONUMBER | NUMBER	--> Controls whether the row number is displayed as the first column in the query output.
NOSTIMER | STIMER	--> Controls whether PROC SQL writes resource utilization statistics to the SAS log.
NODOUBLE | DOUBLE	--> Controls whether the report is double-spaced.
NOFLOW | FLOW	--> Controls text wrapping in character columns.
*/
/* 2.3 SQL Options: Limiting the Number of Rows That SAS Writes or Reads */
/*
OUTOBS=n

INOBS=n

To limit the number of output rows, you can use the PROC SQL option OUTOBS=. The value n is an integer that specifies the maximum number of rows that PROC SQL writes to output.

To limit the number of rows that PROC SQL reads as input, you can use the INOBS= option in the PROC SQL statement. n is an integer that specifies the maximum number of rows that PROC SQL reads from each source table.

The INOBS= option is generally more efficient than the OUTOBS= option. However, the INOBS= option might not always produce the desired results.

If you use an inner join to combine large tables, it's most efficient to use the INOBS= option, if possible. If the join produces no output, try increasing the value of n.

If you use an inner join to combine small tables, using the OUTOBS= option to limit the output rows ensures that you'll get output when matches exist.
*/


/*******************************************************************************
3. Using the Macro Language with PROC SQL
*******************************************************************************/
/* 3.1 The Macro Facility */
/*
The SAS macro facility consists of the macro processor and the SAS macro language. It is a text processing tool that enables you to automate and customize SAS code.

The SAS macro facility enables you to assign a name to character strings or groups of SAS programming statements. Then, you can work with the names rather than the text itself. SAS inserts the new value of the macro variable throughout your PROC SQL statements automatically. After all macro variables are resolved, the PROC SQL statement executes with the values from those macro variables.

The macro facility is a programming tool that you can use to substitute text in your SAS programs to automatically generate and execute code and write SAS programs that are dynamic.
*/

/* 3.2 PROC SQL and Macro Variables */
/*
In PROC SQL, you can use macro variables to store values returned by a query. You can then reference these macro variables in other PROC SQL statements and steps. Using macro variables in your program enables quick and easy updates, because you need to make the change in only one place.

Macro variables are sometimes referred to as symbolic variables because SAS programs can reference macro variables as symbols for SAS code.

Macro variables can supply a variety of information, including operating system information, SAS session information, or user-defined values. The information is stored as a text string value that remains constant until you change it. The text can include complete or partial SAS steps, as well as complete or partial SAS statements.

There are two types of macro variables. SAS provides automatic macro variables. You create and define user-defined macro variables.

The name and value of a macro variable are stored in an area of memory called a global symbol table, which is created by SAS at initialization.
*/
/* %PUT statement */
/* You can use the %PUT statement to write your own messages, including macro variable values, to the SAS log.
  %PUT text;

The macro processor processes %PUT. Remember that the macro processor does not require text to be quoted.

You can follow the keyword %PUT with optional text, and then the reference to the macro variable. %PUT statements are valid anywhere in a SAS program. The %PUT statement writes only to the SAS log and always writes to a new log line, starting in column one.

You can follow the keyword, %PUT, with optional text, and then the reference to the macro variable.
*/
/* %put _all_ statement*/
/*
To display all macro variables in the global symbol table, use the statement %put _all_;. This report will be written to the SAS log.

To create a report of just the automatic macro variables, use the statement %put _automatic_;.
*/

/* 3.3 Creating User-Defined Macro Variables */
/*
You use the %LET statement to create a user-def %LET statements are global statements and are valid anywhere in a SAS program.
  %LET variable=value;

After the keyword %LET, you specify the name of the macro variable, an equal sign, and then the value of the macro variable.

Macro variable names must start with letters or underscores. The rest of the name can be letters, digits, or underscores. You don't need to enclose the value of the macro variable in quotation marks. SAS considers everything that appears between the equal sign and the semicolon to be part of the macro variable value.

You can assign any valid SAS variable name to a macro variable as long as the name isn't a reserved word. If you assign a macro variable name that isn't valid, SAS issues an error message in the log.

Value can be any string of 0 to 65,534 characters. Value can also be a macro variable reference.

SAS stores all macro variable values as text strings, even if they contain only numbers. SAS doesn't evaluate mathematical expressions in macro variable values. SAS stores the value in the case that is specified in the %LET statement. SAS stores quotation marks as part of the macro variable value.

The %LET statement removes leading and trailing blanks from the macro variable value before storing it. The %LET statement doesn't remove blanks within the macro variable value.

SAS stores the user-defined macro variable's name and value in the global symbol table until the end of your SAS session, when they are deleted from memory. Unlike column names in a data table, SAS stores the macro variable names in uppercase, regardless of how the name was created. SAS stores the values as mixed-case text depending on how they were created. But, remember that the values are all character types, even when the characters are digits.
*/

/* 3.4 Resolving User-Defined Macro Variables */
/*
To reference the macro variable, you precede the name of the macro variable with an ampersand.
  &macro-variable-name

Although macro variables are stored in uppercase, references to macro variable names aren't case sensitive.

You can reference a macro variable anywhere in a SAS program.

If you need to reference a macro variable within quotation marks, such as in a title, you must use double quotation marks. The macro processor won't resolve macro variable references that appear within single quotation marks. Instead, SAS interprets the macro variable reference as part of the text string.

After the program code is submitted and before the program executes, the macro processor searches for macro triggers such as &. The macro processor finds the stored value for the named macro variable in the global symbol table. Then the macro processor substitutes that value into the program in place of the reference. Finally, the program executes and creates the report.
*/

/* 3.5 Displaying Macro Variable Values */

*3.5.1 %PUT statement
You can use the %PUT statement to write your own messages, including macro variable values, to the SAS log. The macro processor processes %PUT. Remember that the macro processor does not require text to be enclosed in quotation marks.
  %PUT text;

%PUT statements are valid anywhere in a SAS program. The %PUT statement writes only to the SAS log and always writes to a new log line, starting in column one.

You can follow the keyword, %PUT, with optional text, and then the reference to the macro variable.

/* 3.5.2 SYMBOLGEN global system option */
The SYMBOLGEN global system option enables SAS to display the value of the macro variable in the SAS log as it is resolved.
  OPTIONS SYMBOLGEN;

The default setting for this system option is NOSYMBOLGEN.

Because SYMBOLGEN is a system option, its setting remains in effect until you modify it or until you end your SAS session.

/* 3.5.3 FEEDBACK option */
You can use the FEEDBACK option to display the query in the SAS log after it has expanded references, such as macro variables.
  FEEDBACK;

The default option is NOFEEDBACK.

FEEDBACK PROC SQL option writes the query with the substituted macro variable values to the SAS log.
When you activate the FEEDBACK PROC SQL option, SAS writes a message to the log displaying the query with the references expanded.
*/

/* 3.6 Using a Query to Generate Macro Values */
/*
You can use a PROC SQL query to generate values that are sent to the symbol table for later use.
  SELECT column-1 <, ...column-n>
        INTO :macro-variable-1 <, ... :macro-variable-n>
        FROM table|view
        <additional clauses>;

PROC SQL creates macro variables or updates existing macro variables using an INTO clause. The INTO clause is located between the SELECT clause and the FROM clause. It cannot be used in a CREATE TABLE or CREATE VIEW statement.

You list the names of the macro variables to be created in the INTO clause. Each macro variable name is preceded with a colon. PROC SQL generates the values that are assigned to these variables by executing the query.

/* 3.6.1 Creating a Single Macro Variable */
This syntax of the INTO clause places values from the first row returned by an SQL query into a macro variable.
  SELECT column-1 <, ...column-n>
        INTO :macro-variable-1 <, ... :macro-variable-n>
        FROM table|view
        <additional clauses>;

The value from the first column in the SELECT list is placed in the first macro variable listed in the INTO clause. The second column in the SELECT list is placed in the second macro, and so on.

When storing a single value into a macro variable, PROC SQL preserves leading or trailing blanks. If the macro variable already exists, the INTO clause replaces the existing value with a new value from the SELECT clause. Data from additional rows returned by the query is ignored. This method is used most often with queries that return only one row.

/* 3.6.2 Creating Multiple Macro Variables */
You can use the same syntax of the INTO clause to create multiple macro variables from a single row. To do this, you separate each name with a comma in the INTO clause.
  SELECT column-1
        INTO :macro-variable-1 <, ... :macro-variable-n>
        FROM table|view
        <additional clauses>;
Remember that macro variables can hold only character values. So, numeric values are converted to character values by using the BEST8. format and are right aligned.


/* 3.6.3 Second Syntax form */
  SELECT column-a <, column-b, ...>
        INTO :macro-variable-a_1 - :macro-variable-a_n
             <, :macro-variable-b_1 - :macro-variable-b_n>
        FROM table-1|view-1 <table-x|view-x>
        <additional clauses>;

/* 3.6.4 Third Syntax form */
  SELECT column-1 <, column-2, ...>
        INTO :macro-variable-1 SEPARATED BY 'delimiter'
             <, :macro-variable-2 SEPARATED BY 'delimiter'>
        FROM table-1|view-1 <, ... table-x|view-x>
        <additional clauses>;

*/


/*******************************************************************************
  Sample Programs
*******************************************************************************/
/* 1. Querying Dictionary Information */
proc sql;
describe table dictionary.tables;
quit;

/* 2. Displaying Specific Metadata */
title 'Tables in the ORION Library';
proc sql;
select memname 'Table Name',
       nobs,nvar,crdate
   from dictionary.tables
   where libname='ORION';
quit;
title;

/*3. Using Dictionary Tables in Other SAS Code */
title 'Tables in the ORION Library';
proc print data=sashelp.vtable label;
   var memname nobs nvar;
   where libname='ORION';
run;
title;

/* 4. Using Dictionary Views */
title 'SAS Objects by Library';
proc tabulate data=sashelp.vmember format=8.;
   class libname memtype;
   keylabel N=' ';
   table libname, memtype/rts=10
         misstext='None';
   where libname in ('ORION','SASUSER','SASHELP');
run;
title;


/* 5. Limiting the Number of Rows That SAS Writes */
proc sql outobs=10;
title "10 Most Profitable Customers";
select Customer_ID, sum(Unit_Sales_Price-Unit_Cost_Price)
       as Profit_2011 format=comma8.2
   from orion.price_list as p,
        orion.order_fact as o
   where p.Product_ID=o.Product_id
         and year(Order_date)=2011
   group by Customer_ID
   order by Profit_2011 desc;
quit;
title;

/* 6. Limiting the Number of Rows That SAS Reads */
proc sql inobs=10;
title "orion.price_list - INOBS=10";
select Product_ID,
       Unit_Cost_price format=comma8.2,
       Unit_Sales_Price format=comma8.2,
       Unit_Sales_Price-Unit_Cost_Price
       as Margin format=comma8.2
   from orion.price_list;
quit;
title;


/* 7. Creating User-Defined Macro Variables */
%let DataSetName=employee_payroll;
%let BigSalary=100000;
%let Libname='orion';

/* 8. Resolving User-Defined Macro Variables */
proc sql;
   select Employee_ID, Salary
      from orion.&DataSetName
      where Salary>&BigSalary;
quit;

/* 9. Displaying Macro Variable Values */
%put The value of BigSalary is &BigSalary;
%let DataSetName=Employee_Payroll;
%let BigSalary=100000;
options symbolgen;
proc sql;
title "Salaries > &bigsalary";
   select Employee_ID, Salary
      from orion.&DataSetName
      where Salary > &BigSalary;
quit;
title;

%let DataSetName=Employee_Payroll;
%let BigSalary=100000;
proc sql feedback;
title "Salaries > &bigsalary";
   select  Employee_ID, Salary
      from orion.&DataSetName
      where Salary > &BigSalary;
quit;
title;

/* 10. Using a Query to Generate Macro Values */
/* Creating a Single Macro Variable */
%let Dept=Sales;
proc sql noprint;
select avg(Salary)
	into :MeanSalary
	from 	orion.employee_payroll as p,
		  	orion.employee_organization as o
	where p.Employee_ID=o.Employee_ID
		and Department=propcase("&Dept");

reset print number;
title  "&Dept Department Employees Earning";
title2 "More Than The Department Average "
       "Of &MeanSalary";
select p.Employee_ID, Salary
   from orion.employee_payroll as p,
        orion.employee_organization as o
   where p.Employee_ID=o.Employee_ID
         and Department=Propcase("&Dept")
         and Salary > &MeanSalary;
quit;
title;

/* Creating Multiple Macro Variables */
proc sql noprint;
select avg(Salary),min(Salary),max(Salary)
   into :MeanSalary, :MinSalary, :MaxSalary
   from orion.employee_payroll;
%put Mean: &MeanSalary Min: &MinSalary
     Max: &MaxSalary;
quit;
