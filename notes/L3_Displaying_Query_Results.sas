/*******************************************************************************

Displaying Query Results - a collection of snippets

from Summary of Lesson 3: Displaying Query Results
ECSQL193 - SAS SQL 1 - Essentials

- order the rows in query results by the values of one or more columns
- create columns that contain the same constant character value in every row
- display column labels and titles and apply SAS formats to values in query output
- use PROC SQL options to control query output
- use summary functions to produce summary statistics
- group data by using the GROUP BY clause, and produce summary statistics for each group
- specify options to control whether PROC SQL remerges when processing queries
- subset groups by using the HAVING clause
*******************************************************************************/


/*******************************************************************************
1. Presenting Data
*******************************************************************************/
/* 1.1 Ordering Rows*/
/*

  SELECT object-item <, ...object-item>
        FROM from-list
        <WHERE sql-expression>
        <ORDER BY order-by-item <DESC>
                             <,... order-by-item <DESC>>;

The SQL processor determines the order in which PROC SQL writes the rows to the output. The processor might not output the rows in the same order as they are encountered in the table. To guarantee the order of the rows in the output, you must use an ORDER BY clause.

When you use an ORDER BY clause, you change the order of the output but not the order of the rows that are stored in the table. By default, PROC SQL sorts in ascending order from the lowest value to the highest. To sort in descending order, you specify the keyword DESC following the column name that you want to sort in descending order.

The ORDER BY clause treats missing values as the smallest possible value, regardless of whether the values are character or numeric. So, when you sort in ascending order, missing values appear first in query results.

When you specify multiple columns in the ORDER BY clause, PROC SQL sorts the rows by the values of the first column. The values of the following columns represent secondary sorts and PROC SQL sorts the rows that have the same value for the primary sort by using the secondary value.
*/
/* 1.2 Specifying Labels and Formats */
/*

'label'

By default, PROC SQL formats output by using column attributes that are already saved in the table or, if there are no permanent attributes, by using the default attributes. However, you can use the ANSI standard column modifier to create a label that is displayed as the heading for the column in the output. The label can be stored permanently when creating or altering a table. The text can be up to 256 characters and must be enclosed in quotation marks.

LABEL='label'

You can take advantage of SAS enhancements, such as the LABEL= column modifier. You can specify the LABEL= column modifier after any column name or expression that is specified in the SELECT clause. You can specify up to 256 characters for the text. Generally, using the SAS method makes your code easier to read and follow.

FORMAT=formatw.d

To make data values easier to read in output, you can use the FORMAT= column modifier to associate formats with column values. The FORMAT= column modifier is also a SAS enhancement. A format is an instruction that SAS uses to write data values. Formats specified in the SELECT clause affect only how the data values appear in the output, not how the actual data values are stored in the table.
*/
/* 1.3 Adding Titles, Footnotes, and Constant Text */
/*

  TITLE<n> 'text';

  FOOTNOTE<n> 'text';

Titles appear at the top and footnotes appear at the bottom of each page of SAS output. Titles and footnotes appear in both HTML output and listing output.

In HTML output, titles appear at the top and footnotes appear at the bottom of the output no matter how long the output is. Listing output is divided into pages of a specified size, and your titles and footnotes appear at the top and bottom of each page, respectively.

TITLE and FOOTNOTE statements remain in effect until they are redefined or cancelled. Redefining a title or footnote line with the same or smaller number cancels any highernumbered lines. To cancel all previous titles or footnotes, specify a null TITLE or FOOTNOTE statement. A null TITLE or FOOTNOTE statement has no line number and no text following the keyword.

In listing and HTML output, any lines for which you do not specify a title appear blank.

While the TITLE statement with the largest number appears on the last title line, footnote lines are "pushed up" from the bottom. The FOOTNOTE statement with the smallest number appears on top and the footnote statement with the largest number appears on the bottom line.

SELECT object-item <, ...object-item>
            'constant text' <AS alias> <'column label'>
      FROM from-list;

Remember that a constant, sometimes called a literal, is a number or character string that indicates a fixed value. The SELECT clause can use constants as expressions.
*/
/* 1.4 Controlling PROC SQL Output */
/*

  PROC SQL<option(s)>;

Options that are included in the PROC SQL statement are temporary and apply only to that PROC SQL step. If multiple queries are specified, PROC SQL applies the options to all of the statements in the step.

After you specify an option, it remains in effect until SAS encounters the beginning of another PROC SQL step or or you change the option.

RESET<option(s)>;

The RESET statement enables you to add, drop, or change the options in the PROC SQL step without restarting the procedure. The RESET statement is useful to change options and add additional options not previously listed in the PROC SQL statement.

OUTOBS=n

The OUTOBS= option restricts the number of rows that a query outputs to a report or writes to a table.

NONUMBER | NUMBER

The NUMBER or NONUMBER option controls whether the SELECT statement includes a column named ROW, which displays row numbers as the first column of query output.This option has no effect on the underlying table.

The NONUMBER option is the default setting.

NODOUBLE | DOUBLE

The DOUBLE or NODOUBLE option defines the spacing between lines for an output destination that has a physical page limitation. The DOUBLE option double-spaces the report, which places a blank line between the rows.

The NODOUBLE option single-spaces the report and is the default setting.

The DOUBLE|NODOUBLE option primarily affects the LISTING destination and has no effect on other output destinations such as PDF, RTF, and HTML.

NOFLOW | FLOW<=n<m>>

The FLOW or NOFLOW option defines whether character columns with long values wrap, or flow, within the column or the row wraps around to additional lines of output to display all columns. The FLOW option causes text to wrap or flow within column limitations rather than wrapping an entire row.

The NOFLOW option is the default setting.

The FLOW option affects output destinations with a physical page limitation.
*/


/*******************************************************************************
2. Producing Summary Statistics
*******************************************************************************/
/* 2.1 Understanding Summary Functions*/
/*
Using PROC SQL, you can summarize data in a variety of ways: across rows, down a column across an entire table, or down a column by groups of rows.

To summarize data, your query must create one or more summary columns that appear in the output.

To calculate summary columns in your query output, you add summary functions to expressions in the SELECT clause. Summary functions are also called aggregate functions. Summary functions reduce all the values in each row or column in a table to one summarizing or aggregate value.

Some of the most commonly used summary functions are shown below:

ANSI	      | SAS	   | Returned Value:
---------------------------------------------------
AVG	        | MEAN	 | Mean (average) value
COUNT, FREQ	| N	     | Number of nonmissing values
MAX	        | MAX	   | Largest value
MIN	        | MIN	   | Smallest nonmissing value
SUM	        | SUM	   | Sum of nonmissing values
            | NMISS	 | Number of missing values
            | STD	   | Standard deviation
            | VAR	   | Variance

SAS and ANSI summary functions do not work exactly the same way. The main difference is in the number of arguments that each can accept. An argument of a summary function is often a column name, although there are other types of arguments as well.

  SUM(argument)
  SUM(argument-1 <,argument-n>)

Both ANSI functions and SAS summary functions can accept a single argument. If a summary function specifies only one column as an argument, the summary function calculates a single summary value for that column, using the values from one or more rows.

SAS summary functions can accept multiple arguments, but ANSI summary functions cannot. If a SAS summary function specifies multiple columns as arguments, the summary function calculates the statistic across each row, using the values in the listed columns. ANSI summary functions cannot summarize across rows.

When you specify one argument for a summary function that has the same ANSI and SAS name, PROC SQL executes the ANSI summary function.

When you specify multiple arguments for a summary function that has the same ANSI and SAS name, PROC SQL executes the SAS summary function.

If you specify multiple arguments for an ANSI summary function, PROC SQL does the following:
If a SAS function has the specified name, PROC SQL runs it.
If no SAS function exists, PROC SQL generates an error.
*/

/* 2.2 Producing Summary Statistics */
/*

  COUNT(argument)

  FREQ(argument)

  N(argument)

To count the number of rows in a table or in a subset, you can use the ANSI COUNT function, the ANSI FREQ function, or the SAS N function.

The COUNT function argument can be either a column name or an asterisk:
If you specify a column name, the COUNT function counts the number of rows in the table or in a subset of rows that have a nonmissing value for that column.
If you specify an asterisk, the COUNT function returns the total number of rows in a table or in a group of rows.
The FREQ and N functions cannot accept an asterisk as an argument.
*/

/* 2.3 Calculating Summary Statistics for Groups of Data */
/*
PROC SQL processes non-summarized columns and summarized columns differently:

For non-summarized columns, PROC SQL generates one row of output for each row that the query processes.
For summarized columns, PROC SQL reduces multiple input rows to a single row of output.
When the SELECT clause list contains at least one column that a summary function creates and a column that is not summarized, and the query has no GROUP BY clause to group the output data by the non-summarized column, PROC SQL remerges the data by default.

Remerging data requires two passes through the table, which takes additional processing time. Here is a simplified description of the process of remerging:

In the first pass through the data, PROC SQL calculates the value of any summary functions for the subset of rows specified in the WHERE clause, and then returns a single value for each summary column.
In the second pass, PROC SQL selects any non-summarized column values from the rows specified in the WHERE clause. PROC SQL then appends the summary column values to each row to create the output.
There is one type of non-summarized column that you can combine with a summarized column in the SELECT clause to generate one row of output: a column that contains a constant value.

OPTIONS SQLREMERGE | NOSQLREMERGE;

PROC SQL REMERGE | NOREMERGE;

Although SAS remerges summary statistics by default, most database management systems do not. Instead, these other systems generate an error.

To prevent SAS from remerging summary statistics in every PROC SQL step in the current session, you can specify the SAS system option NOSQLREMERGE in the OPTIONS statement. Remember that SAS system options remain in effect until you change them or until the end of your session.

If you want to prevent SAS from remerging summary statistics in individual queries or individual PROC SQL steps, you can specify the NOREMERGE option in the PROC SQL statement instead of using the SAS system option. Remember that PROC SQL options remain in effect until you change or reset them, or until PROC SQL reaches a step boundary, such as a QUIT statement.
*/

/* 2.4 Grouping Data */
/*
  SELECT object-item <, ...object-item>
        FROM from-list
        <WHERE sql-expression>
        <GROUP BY object-item <, ... object-item>>
        <ORDER BY order-by-item <DESC>
                             <,... order-by-item <DESC>>;

To summarize data by groups, you use a GROUP BY clause. In the GROUP BY clause, you specify one or more columns that you want to use to categorize the data for summarizing. As in the ORDER BY clause, you can specify a column name, a column alias, or an expression. You separate multiple columns with commas.

In the GROUP BY clause, you can specify columns that are calculated in the SELECT clause, except for columns that are created by a summary function.

To select a set of rows before the query processes them, you use a WHERE clause.

You cannot use a WHERE clause to subset grouped rows by referring to a summary column that is calculated in the SELECT clause.

In a WHERE clause, you cannot use summary functions that specify a single argument.

SELECT object-item <, ...object-item>
      FROM from-list
      <WHERE sql-expression>
      <GROUP BY object-item <, ... object-item>>
      <HAVING sql-expression>
      <ORDER BY order-by-item <DESC>
                           <,... order-by-item <DESC>>;

To select groups to appear in the output, you use the HAVING clause. PROC SQL processes the HAVING clause after grouping rows. Following the keyword HAVING is an expression that PROC SQL uses to subset the grouped rows that appear in the output. Expressions in the HAVING clause follow most of the same rules as expressions in the WHERE clause.

Unlike the WHERE clause, the HAVING clause can refer to the following:
- the column alias of a calculated column without using the keyword CALCULATED
- the column alias of a column that was created by a summary function with a single argument

Unlike the GROUP BY clause, the HAVING clause can use an expression that contains a summary function or that references a column that a summary function created.

  FIND(string, substring <, modifier(s)> <,startpos>)

The FIND function searches for a specific substring of characters within a character string and then performs one of the following actions:
- If the FIND function finds all of the characters in the specified substring, the function returns an integer that represents the starting position of the substring within the string.
- If the FIND function does not find the substring, the function returns a value of 0.

The FIND function has four arguments, which are separated by commas. The first two arguments – string and substring – are required, and the other two are optional. The arguments are described below:
- string is what the function searches to locate the first occurrence of the substring. string can be a constant, a variable, or an expression that resolves to a character string.
- substring is what you're looking for. Like the string, the substring can be a constant, a variable, or an expression that resolves to a character string.
- There are two modifiers, and you can specify one or both of them.
  The modifier i tells the FIND function to ignore case when searching for a substring.
  The modifier t tells the FIND function to trim any trailing blanks from both the string and the substring before searching. If you specify both modifiers, you enclose them in a single set of quotation marks. The modifiers are not case sensitive.
- startpos is an integer that specifies both a starting position for the search and the direction of the search. A positive integer causes the FIND function to search from left to right. A negative integer causes the FIND function to search from right to left. By default, if you do not specify startpos, the FIND function starts at the first position in the string and searches from left to right.

Boolean expressions are expressions that evaluate to one of two values:
TRUE (or 1)
FALSE (or 0)

/*******************************************************************************
Sample Programs
*******************************************************************************/
/* 1. Ordering Rows */
proc sql;
select Employee_ID,
       max(Qtr1,Qtr2,Qtr3,Qtr4)
   from orion.employee_donations
   where Paid_By="Cash or Check"
   order by 2 desc, Employee_ID;
quit;

/* 2. Specifying Labels and Formats */
proc sql;
select Employee_ID 'Employee ID',
       max(Qtr1,Qtr2,Qtr3,Qtr4)
          label='Maximum' format=dollar5.
   from orion.employee_donations
   where Paid_By="Cash or Check"
   order by 2 desc, Employee_ID;
quit;

/* 3. Adding Titles, Footnotes, and Constant Text */
proc sql;
title 'Annual Bonuses for Active Employees';
select Employee_ID label='Employee Number',
       'Bonus is:',
       Salary *.05 format=comma12.2
   from orion.employee_payroll
   where Employee_Term_Date is missing
   order by Salary desc;
quit;
title;


/* 4. Controlling PROC SQL Output */
proc sql flow=5 20 double number outobs=10;
title "Sample Report";
select *
   from orion.employee_organization;
quit;
title;

/* 5. Summarizing Across a Row */
proc sql;
select Employee_ID
       label='Employee ID',
       Qtr1,Qtr2,Qtr3,Qtr4,
       sum(Qtr1,Qtr2,Qtr3,Qtr4)
   from orion.employee_donations;
quit;

/* 6. Summarizing Down a Column */
proc sql;
select sum(Qtr1)
       'Total Quarter 1 Donations'
   from orion.employee_donations;
quit;

/* 7. Calculating Multiple Summary Columns */
proc sql;
select sum(Qtr1)
       'Total Quarter 1 Donations',
       sum(Qtr2)
       'Total Quarter 2 Donations'
   from orion.employee_donations;
quit;

/* 8. Counting the Number of Rows That Have a Missing Value */
proc sql;
select Employee_ID
   from orion.employee_information
   where Employee_Term_Date is missing;
quit;

/* 9. Combining Summarized and Non-Summarized Columns */
proq sql;
select Employee_Gender as Gender, avg(Salary) as Average
   from orion.employee_information
   where Employee_Term_Date is missing;
quit;

/* 10. Using Remerged Summary Statistics */
proc sql;
title "Male Employee Salaries";
select Employee_ID, Salary format=comma12.,
       Salary / sum(Salary)
       'PCT of Total' format=percent6.2
   from orion.employee_payroll
   where Employee_Gender='M'
         and Employee_Term_Date is missing
   order by 3 desc;
quit;
title;

/* 11. Grouping Data by Using the GROUP BY Clause */
proc sql;
select Employee_Gender as Gender,
       Marital_Status as M_Status,
       avg(Salary) as Average
   from orion.employee_information
   where Employee_Term_Date is missing
   group by Employee_Gender,
             Marital_Status;
quit;

/* 12. Selecting Groups with the HAVING Clause */
proc sql;
select Department, count(*) as Count
   from orion.employee_information
   group by Department
   having Count ge 25;
quit;

/* 13. Identifying Rows That Meet a Criterion by Using the FIND Function */
proc sql;
select Department, Job_Title,
       find(Job_Title,"manager","i")
          as Position
   from orion.employee_organization;
quit;

/* 14. Counting Rows by Using Boolean Expressions */
proc sql;
select Department,
       sum(find(Job_Title,"manager","i")>0)
          as Managers,
       sum(find(Job_Title,"manager","i")=0)
          as Employees
   from orion.employee_information
   group by Department;
quit;
