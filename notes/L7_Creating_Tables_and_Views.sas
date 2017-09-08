/*******************************************************************************

Creating Tables and Views

from Summary of Lesson 7: Creating Tables and Views
ECSQL193 - SAS SQL 1 - Essentials

- create a new table and add data by using a query
- create a new empty table by copying the column structure from an existing table
- create a new empty table by defining the column structure
- add data into a table
- create and verify a PROC SQL view
- decide whether it is best to reference a view or a table in specific situations
- reference PROC SQL views in SQL queries and other SAS procedures
- make a PROC SQL view portable
*******************************************************************************/


/*******************************************************************************
1. Creating Tables
*******************************************************************************/
/* 1.1 Methods of Creating Tables with the CREATE TABLE Statement */
/*
PROC SQL provides three methods of creating new tables:
1. If one or more existing tables have the data that you need, you can copy some or all of the existing columns and rows to a new table when you create it.
2. If you start with an existing table, you can also copy only the column structure to create a new table that has no rows—that is, an empty table. You'll need to add the data in a separate step.
3. If no existing table has the column structure that you want, you can define new columns in your code to create an empty table.
Each method of creating a table uses a different form of the CREATE TABLE statement. Each CREATE TABLE statement can create only one table.
*/
/* 1.2 Using a Query in the CREATE TABLE Statement */
/*
To create a table by copying columns and rows from one or more existing tables, you use a query in the CREATE TABLE statement.
  CREATE TABLE table-name AS
    SELECT ...;

Following the CREATE TABLE keywords and the name of the table that you want to create, you specify the keyword AS. Next, you specify a query that returns the columns and rows that you want from the existing table or tables. In addition to the required SELECT and FROM clauses, you can use any of the optional clauses from a SELECT statement. The entire statement contains only one semicolon, which appears at the end.

When you specify a query within the CREATE TABLE statement, the report output is suppressed. The CREATE TABLE statement generates only a table.

When you create a new table, it is a good idea to verify the contents of the table by using the DESCRIBE TABLE statement.

Using the LIKE Clause in the CREATE TABLE Statement

To create a table by copying columns and rows from one or more existing tables, you use a query in the CREATE TABLE statement.

CREATE TABLE table-name-2
      LIKE table-name-1;
Following the keywords CREATE TABLE, you specify the name of the table that you want to create (table-name-2). Table names must follow the rules for SAS names. The LIKE clause specifies the name of the existing table whose column structure you want to copy (table-name-1).

Defining Columns in the CREATE TABLE Statement

To create a new, empty table that is not based on an existing table, you can define the columns in the CREATE TABLE statement.

CREATE TABLE table-name
      (column-name type <column-modifier(s)>
      <,...column-name type <column-modifier(s)>>);
Following the CREATE TABLE keywords, you specify the name of the table you are creating. Then you specify a set of column definitions that, together, make up the table definition. The column definitions are separated by commas. The entire table definition is enclosed in parentheses.

Each column definition consists of a column name (which must follow the rules for SAS names), a type (also referred to as a data type), and (optional) column modifiers such as informats, formats, and labels.

In SAS data sets, a column's type can be either character or numeric. Columns are defined as follows:

To define a character column, you specify the CHARACTER keyword and, optionally, a column length in parentheses. In SAS, the default column length for character columns is eight characters.
To define a numeric column, you specify the NUMERIC keyword. In a SAS data set, PROC SQL creates all numeric columns with the maximum precision allowed by SAS, so there is no need to specify a length.
For ANSI compliance, PROC SQL accepts additional data types in column definitions. However, all additional types are converted to either character or numeric in the SAS data set. For example, in a SAS data set, a date column is a numeric column that has a date informat or format.
*/

/*******************************************************************************
2. Methods of Adding Data to a Table with the INSERT Statement
*******************************************************************************/
/*
PROC SQL provides the following methods of adding data to an existing table:
1. Specify column name-value pairs.
2. Specify an ordered list of values.
3. Specify a query that returns one or more rows.
If the table already contains rows, the new rows are appended.

Each method uses a different form of the INSERT statement. The first part of this statement is always the same: the keywords INSERT INTO are followed by the name of the table into which you are adding data. The rest of the INSERT statement varies by method. Each INSERT statement can add data to only one table.
*/
/* 2.1 Specifying Column Name-Value Pairs in the SET Clause */
/*
In the INSERT statement, the SET clause specifies or alters the values of one or more columns in a row.
  INSERT INTO table-name
        SET column-name=value,
               column-name=value ... ;
The SET clause contains one or more pairs of column names and values. In each pair, the column name and the value are joined by an equal sign. Multiple pairs are separated by commas. The column names can be listed in any order. Character values are enclosed in quotation marks.
To insert values into multiple rows, you can specify multiple SET clauses in the INSERT statement. Multiple SET clauses are not separated by commas. Multiple SET clauses do not need to list the same columns or list columns in the same order.
*/
/* 2.2 Specifying an Ordered List of Values in the VALUES Clause */
/*
In the INSERT statement, the VALUES clause adds values to the columns in a single row.
  INSERT INTO table-name
         <(column<, ... column>)>
        VALUES(value,value, ... );
After the VALUES keyword, you specify a list of one or more values in parentheses.
Within the list, you separate multiple values with commas. To add more than one row of values to the table, you specify additional VALUES clauses.
Multiple VALUES clauses are not separated by commas.

By default, in each VALUES clause, you specify values for all of the columns in the table, in the order that the columns appear in the table. If you want to specify values in an order that is different from the column order in the table, or if you want to specify values for only a subset of the columns in the table, you must add an optional column list in parentheses after the table name. The order of the columns in the column list is independent of the order of the columns in the table. When you specify a column list, the order of the values in each VALUES clause must match the order of the columns in the column list. Any columns that are in the table but do not appear in a column list are given missing values.
*/
/* 2.3 Specifying a Query in the INSERT Statement */
/*
To add data from one existing table to another, you can specify a query in the INSERT statement.
  INSERT INTO table-name
         <(column<, ... column>)>
        SELECT column(s)
               FROM table-name
               <additional clauses>;
By default, the SELECT clause specifies values for every column in the target table, and the order of the values must match the order of the columns in the target table.
If you want to specify values in a different order or for only a subset of the columns in the target table, you can add an optional column list in parentheses after the table name in the INSERT statement.
The order of the columns in the column list is independent of the order of the columns in the table.
*/

/*******************************************************************************3. Creating PROC SQL Views
*******************************************************************************/
/* 3.1 Understanding PROC SQL Views */
/*
A SAS view that is created by PROC SQL is called a PROC SQL view. A PROC SQL view is a stored query that can be based on one or more tables or any kind of SAS view: PROC SQL views, DATA step views, or SAS/ACCESS views. So, a PROC SQL view contains query code but no actual data.

Unlike an empty table, a view is not a physical table. Instead, a PROC SQL view is sometimes referred to as a virtual table because it can be referenced in queries and other SAS programs in the same manner as a physical table.

Like a table, a PROC SQL view has a name. When a SAS program runs, each time a view is referenced, the stored query executes and extracts the most current data from the underlying data source.

ANSI standards specify that a PROC SQL view must reside in the same library as the source table or tables. However, a PROC SQL view cannot have the same name as a table stored in the same library. Nor can you create a table that has the same name as an existing view in the same library.

There is a SAS enhancement in PROC SQL that enables you to create a view that can reside in a different library than its data source.

The main advantages and disadvantages of referencing PROC SQL views instead of tables in your SAS programs are listed below.
-------------------------------------------------------------------------
Advantages:
Avoid storing copies of large tables.
Avoid a frequent refresh of table copies.
When the underlying data changes, a view surfaces the most current data.
Combine data from multiple database tables and multiple libraries or databases.
Simplify complex queries.
Prevent other users from inadvertently altering the query code.
Prevent other users from viewing data that they should not be able to see.
-------------------------------------------------------------------------
Disadvantages:
Might produce different results each time they are accessed if the data in the underlying data sources changes.
Can require significant resources each time that they execute. With a view, you save disk storage space at the cost of extra CPU and memory usage.
-------------------------------------------------------------------------

To help you decide whether to use a view or a table, keep this guideline in mind: When accessing the same data several times in a program, use a table instead of a view. This ensures consistent results from one step to the next and can significantly reduce the use of certain resources.
*/

/* 3.2 Understanding PROC SQL Views*/
/*
To create a PROC SQL view, you use the CREATE VIEW statement. Unlike the CREATE TABLE statement, the CREATE VIEW statement has only one form, which contains a query. When you submit the CREATE VIEW statement, the query's report output is suppressed.
  CREATE VIEW proc-sql-view AS
  SELECT ... ;
Following the CREATE VIEW keywords, you specify the name of the PROC SQL view that you want to create. View names must follow the rules for SAS names. You cannot specify the name of an existing table or view in the same SAS library. Then you specify the keyword AS, followed by the query clauses.

According to ANSI standards, a view must reside in the same library as the contributing table or tables.
In PROC SQL, the default libref for the table (or tables) in the FROM clause is the libref of the library that contains the view. When the view and data source are in the same location, you can specify a one-level name for the table (or tables) in the FROM clause. In this situation, the one-level name does not designate temporary tables in the SAS work library.

Technically, you can use any of the optional query clauses in the CREATE VIEW statement. However, for the sake of efficiency, it is recommended that you avoid using the ORDER BY clause in a query that defines a view. Using the ORDER BY clause in a view definition forces PROC SQL to sort the data every time the view is referenced. Instead, you can use an ORDER BY clause in queries that reference the view.
*/

/* 3.3 Creating and Validating a PROC SQL View*/
/*
The DESCRIBE VIEW statement prints a description of the view in the log. The syntax of the DESCRIBE VIEW statement is similar to the syntax of the DESCRIBE TABLE statement.
*/

/* 3.4 Making a View Portable with the USING Clause*/
/*
By using a SAS enhancement to the ANSI standard for SQL, you can create a usable view that is stored in a different physical location than its source tables. In other words, you can make the view portable. To create a portable view, you add a USING clause to the query in the CREATE VIEW statement.
CREATE VIEW proc-sql-view AS
  SELECT ...
        USING LIBNAME-clause<, ... LIBNAME-clause>;
In the USING clause, an embedded LIBNAME statement enables you to assign a libref that is used for the source tables. In the syntax, this is called a LIBNAME clause because it appears within another clause. To reference source tables in multiple libraries, you can specify multiple LIBNAME clauses. In the FROM clause, you use two-level names for the tables.

The library definition in the USING clause is local to the view so it does not interfere with any other location that is assigned to that libref in the same SAS session. This means that the USING clause defines the library only while the view is executing. The USING clause libref is deassigned when the stored query finishes running.

In general, when you create a permanent PROC SQL view based on data in one or more permanent tables, it is a good practice to make the view portable by adding the USING clause.
*/


/*******************************************************************************  Sample Programs
*******************************************************************************/
/* 1. Creating a Table by Copying Columns and Rows, and Validating the Table */
proc sql;
create table work.birthmonths as
select Employee_Name as Name format=$25.,
       City format=$25.,
       month(Birth_Date) as BirthMonth
          'Birth Month' format=3.
   from orion.employee_payroll as p,
        orion.employee_addresses as a
   where p.Employee_ID=a.Employee_ID
         and Employee_Term_Date is missing
   order by BirthMonth,City,Name;
describe table orion.birthmonths;
quit;

/* 2. Creating a Table by Copying the Column Structure */
proc sql;
create table work.new_sales_staff
   like orion.sales;
quit;

/* 3. Creating a Table by Defining the Columns */
proc sql;
create table discounts
   (Product_ID num format=z12.,
    Start_Date date,
    End_Date date,
    Discount num format=percent.);
quit;


/* 4. Using the SET Clause to Add Data to a Table */
proc sql;
insert into discounts
   set Product_ID=230100300006,
       Start_Date='01MAR2013'd,
       End_Date='15MAR2013'd,
       Discount=.33
   set Product_ID=230100600018,
       Start_Date='16MAR2013'd,
       End_Date='31MAR2013'd,
       Discount=.15;
quit;

/* 5. Using the VALUES Clause to Add Data to a Table */
proc sql;
insert into discounts
   values (230100300006,'01MAR2013'd,
          '15MAR2013'd,.33)
   values (230100600018,'16MAR2013'd,
          '31MAR2013'd,.15);
quit;

/* 6. Specifying a Query in the INSERT Statement */
proc sql;
insert into discounts
   (Product_ID,Discount,Start_Date,End_Date)
   select distinct Product_ID,.35,
          '01MAR2013'd,'31MAR2013'd
      from orion.product_dim
      where Supplier_Name contains
           'Pro Sportswear Inc';
quit;


/* 7. Creating, Validating, and Referencing a PROC SQL View */
proc sql;
create view orion.tom_zhou as
   select Employee_Name as Name format=$25.0,
          Job_Title as Title format=$15.0,
          Salary 'Annual Salary' format=comma10.2,
          int((today()-Employee_Hire_Date)/365.25)
             as YOS 'Years of Service'
      from employee_addresses as a,
           employee_payroll as p,
           employee_organization as o
      where a.Employee_ID=p.Employee_ID and
            o.Employee_ID=p.Employee_ID and
            Manager_ID=120102;
describe view orion.tom_zhou;
quit;

proc sql;
title "Tom Zhou's Direct Reports";
title2 "By Title and Years of Service";
select *
   from orion.tom_zhou
   order by Title desc, YOS desc;
quit;

title "Tom Zhou's Group - Salary Statistics";
proc means data=orion.tom_zhou min mean max;
   var salary;
   class title;
run;
title;


/* 8. Making a View Portable with the USING Clause */
/* Note: To run the following program, you must first replace file-path-1 with the location in which you want to create the view, and file-path-2 with the physical location in which the source data is stored. You must also have write access to the location specified as file-path-1. */

libname orion 'file-path-1';
proc sql;
create view orion.tom_zhou as
   select Employee_Name as Name format=$25.0,
          Job_Title as Title format=$15.0,
          Salary "Annual Salary" format=comma10.2,
          int((today()-Employee_Hire_Date)/365.25)
             as YOS 'Years of Service'
      from orion.employee_addresses as a,
           orion.employee_payroll as p,
           orion.employee_organization as o
      where a.Employee_ID=p.Employee_ID and
            o.Employee_ID=p.Employee_ID and
            Manager_ID=120102
      using libname orion 'file-path-2';
quit;
