/*******************************************************************************

Working with SQL Joins - a collection of snippets

from Summary of Lesson 4: Working with SQL Joins
ECSQL193 - SAS SQL 1 - Essentials

- combine data from multiple tables horizontally
- distinguish between inner and outer SQL joins
- describe the Cartesian product and its effect on processing joins
- join two or more tables on matching columns
- qualify column names to identify specific columns
- use a table alias to simplify the SQL code
- use in-line views and subqueries to simplify the coding of a complex join
*******************************************************************************/


/*******************************************************************************
1. Understanding SQL Joins
*******************************************************************************/
/* 1.1 Understanding SQL Joins*/
/*
If you’re working with tables that have different columns, you can combine tables horizontally to combine the columns that you want in your output.
  SELECT object-item <, ...object-item>
      FROM from-list
      <additional clauses>;

To combine tables horizontally, you can use either the SELECT statement in PROC SQL or the MERGE statement in the DATA step. The results of an SQL join and a DATA step merge are similar but not always identical.

Whatever method you use, you must also specify criteria for matching and combining the rows across the tables.
*/
/* 1.2 Inner joins and Outer joins*/
/*
PROC SQL supports two types of joins:
- Inner joins:
Inner joins return a result table that contains all of the matching rows in the input tables. The result of an inner join does not include any nonmatching rows.
- Outer joins:
Outer joins return a result table that contains all of the matching rows in the input tables and some or all of the nonmatching rows from one or both tables.

There are three types of outer joins:
- A full outer join returns all of the matching rows plus the nonmatching rows from both tables.
- A left outer join returns all of the matching rows plus the nonmatching rows from the first, or left, table.
- A right outer join returns all of the matching rows plus the nonmatching rows from the second, or right, table.

When performing an SQL join, the SQL processor first generates all possible combinations of all of the rows in the tables to be combined. An intermediate result table that contains all possible combinations of rows in the input tables is called a Cartesian product. From the rows in the Cartesian product, the SQL processor can then select the appropriate rows for an inner join or an outer join.
*/
/* 1.3 Cartesian product*/
/*
The number of rows in a Cartesian product is the product of the number of rows in the contributing tables.
  SELECT object-item <, ...object-item>
      FROM table-name, table-name
                 <,...table-name>;
A Cartesian product is rarely the result that you want when you join tables.

To create a Cartesian product, you use the SELECT statement without specifying any conditions for matching rows.
  SELECT object-item <, ...object-item>
      FROM table-1 CROSS JOIN table-2;
*/
/* 1.3.1 CROSS JOIN (Cartesian product)*/
/*
You can also use alternative syntax, called cross join syntax, to produce the Cartesian product of two tables.
  SELECT object-item <, ...object-item>
      FROM table-name-1 CROSS JOIN table-name-2;
In the FROM clause, the table names are separated by the CROSS JOIN keywords instead of by a comma.
*/


/*******************************************************************************
2. Working with Inner Joins
*******************************************************************************/
/* 2.1 Performing an Inner Join*/
/*
Inner join returns only the matching rows. Another way to say this is that an inner join returns rows that meet certain join conditions that you specify.
SELECT object-item <, ...object-item>
      FROM table-name, table-name
      WHERE join-condition(s)
                  <AND sql-expression>
      <additional clauses>;

The syntax for an inner join requires a WHERE clause in addition to the SELECT and FROM clauses. In the WHERE clause, one or more join conditions specify the combined rows that the query should return.

Example:
  SELECT *
    FROM customers, transactions
    WHERE customers.ID=transactions.ID;

The join conditions are specified as expressions. The WHERE clause can also contain one or more additional expressions that subset the rows in additional ways.

The column or columns that are specified in join conditions are referred to as join keys.
Using PROC SQL, you can also specify join keys that have different names. However, by default, a DATA step merge requires the join keys to have the same name in both tables.

PROC SQL can join tables that are not sorted on the join keys, unlike a DATA step merge.

When you refer to columns in multiple tables that have the same name, you must qualify the column names to specify the location of each column. Qualified column names consist of the table name (a table qualifier), a period, and then the column name.

A join on an equal condition is called an equijoin. Using PROC SQL, you can also join tables on an inequality. However, DATA step merges can only join tables on an equality.

Conceptually, when PROC SQL processes an inner join, the SQL processor performs two main steps:
1. builds the Cartesian product of all tables listed in the FROM clause
2. eliminates the rows that don't meet the join conditions
A DATA step merge does not create a Cartesian product.

Unlike DATA step merges, SQL joins do not overlay columns that have the same name. By default, the result set contains all of the columns that have the same name.

To display columns that are the same as, or derived from, columns in multiple tables, you must use a join instead of a subquery.

By default, a DATA step merge builds a result set in the order of the join key values. PROC SQL does not order the rows in query results by default. To guarantee the order of the rows, you must use an ORDER BY clause.

SELECT object-item <, ...object-item>
      FROM table-name <AS> alias-1
                 table-name-2 <AS> alias-2
      WHERE join-condition(s)
      <additional clauses>;

You can simplify the syntax of your SQL joins by assigning aliases to tables in the FROM clause.
Example:
  SELECT c.ID, Name, Action, Amount
    FROM customers as c, transactions as t
    WHERE c.ID=t.ID;

After the table name, you can optionally specify the keyword AS and then the alias. The alias must follow the standard rules for SAS names.
In other clauses, you can reference each table by its alias instead of by its full name.
*/
/* 2.2. Using Alternative Syntax for an Inner Join */
/*
You can also perform an inner join by using the alternative syntax shown here.
  SELECT object-item <, ...object-item>
        FROM table-name-1 <<AS> alias-1>
                   INNER JOIN
                   table-name-2 <<AS> alias-2>
        ON join-condition(s)
        WHERE sql-expression
        <additional clauses>;
In the alternate syntax for an inner join, the FROM clause uses the INNER JOIN keywords to join two tables.
The alternate syntax uses the ON clause to specify the join conditions.
The alternate syntax allows additional clauses, so you can still use the WHERE clause to specify any additional subsetting conditions.

Example:
  SELECT c.ID, Name, Action, Amount
    FROM customers as c
      INNER JOIN transactions as t
        ON c.ID=t.ID;
*/


/*******************************************************************************
3. Working with Outer Joins
*******************************************************************************/
/* 3.1 Working with Outer Joins*/
/*

SELECT object-item <, ...object-item>
      FROM table-name <<AS> alias>
                 LEFT|RIGHT|FULL JOIN
                 table-name <<AS> alias>
      ON join-condition(s)
      <additional clauses>;

The syntax for outer joins is similar to the alternate syntax for inner joins. In an outer join, the FROM clause lists two table names with keywords that indicate the type of join in between: LEFT JOIN, RIGHT JOIN, or FULL JOIN. The left table is the first table listed, and the right table is the second table. The ON clause specifies the join conditions. As with inner joins, you can also add optional clauses, such as a WHERE clause, to subset the rows.

- Performing a Left Outer Join
Use a left outer join to select all the rows in the customers table and only the matching rows in the transactions table.
Example:
proc sql;
  SELECT *
    FROM customers as c
      LEFT JOIN
      transactions as t
        ON c.ID=t.ID;
quit;

- Performing a Right Outer Join
Use a right outer join to select all the rows in the transactions table
and only the matching rows in the customers table.
proc sql;
  SELECT *
    FROM customers as c
      RIGHT JOIN transactions as t
        ON c.ID=t.ID;
quit;

- Performing a Full Outer Join
We want the query to combine and return all matching rows and also to return the rows from both tables that do not match.
proc sql;
  SELECT *
    FROM customers as c
      FULL JOIN transactions as t
        ON c.ID=t.ID;
quit;

In a full outer join, the order of the tables affects the order of the columns in the result set. The columns from the left table appear before the columns from the right table.

Outer joins can only process two tables at a time. However, you can stack multiple outer joins in a single query.
  COALESCE(argument-1,argument-2<,argument-n>)

To overlay columns in SQL joins, you can use the COALESCE function, which is a SAS function. The COALESCE function returns the value of the first nonmissing argument from two or more arguments that you specify. An argument can be a constant, an expression, or a column name. All arguments must be of the same type.

Code Challenge:
In the SELECT clause, add a function to overlay the ID column in grades on the ID column in majors.
grades
ID	GPA
2136	3.8
2290	2.5
5619	3.7
8834	4.0
-----
majors
ID	Major
2136	PSY
3555	BIO
5619	BUS
6001	THE
-----

  select ... as ID, GPA, Major
    from grades full join majors
      on grades.ID=majors.ID;
Here are two ways to write the function that overlays the ID column in grades on the ID column in majors:
  coalesce(grades.ID, majors.ID)
  coalesce(majors.ID, grades.ID)
*/

/* 3.3 differences between a PROC SQL join and a DATA STEP merge*/
/*
The table below shows the differences between a PROC SQL join and a DATA STEP merge.

Key Points	                                | SQL Join	    | DATA Step Merge
Explicit sorting of data before join/merge	| Not required	| Required
Same-name columns in join/merge expressions	| Not required	| Required
Equality in join or merge expressions	      | Not required	| Required

The table below shows the differences between inner and outer joins.

Key Points	| Inner Join	| Outer Join
Table Limit	| 256	| 256
Join Behavior	| Returns matching rows only	| Returns matching and non-matching rows
Join Options	| Matching rows only	| LEFT, FULL, RIGHT

Syntax Changes  - Inner Join:
Multiple tables in the FROM clause (separated by commas)
WHERE clause that specifies join criteria
Syntax Changes  - Outer Join:
ON clause that specifies join criteria
*/


/*******************************************************************************
4. Working with Complex SQL Joins
*******************************************************************************/
/* 4.1 Performing a Complex Join*/
/*
Even if the information you need for your report is located in only two tables, you may need to read the same table twice, or even more times.
  FROM table-name-1 <AS> alias-1,
      table-name-1 <AS> alias-2,
In order to read from the same table twice, it must be listed in the FROM clause twice. A different table alias is required for each listing to distinguish the different uses.

This is called a self-join, or a reflexive join.
*/


/*******************************************************************************
  Sample Programs
*******************************************************************************/
/* 1. Creating a Cartesian Product */
proc sql;
select *
   from customers, transactions, inventory;
quit;

/* 2. Performing an Inner Join */
proc sql;
select c.ID, Name, Action, Amount
   from customers as c, transactions as t
   where c.ID=t.ID;
quit;

/* 3. Using Alternative Syntax for an Inner Join */
proc sql;
select c.ID, Name, Action, Amount
   from customers as c
        inner join
        transactions as t
   on c.ID=t.ID;
quit;

/* 4. Performing a Left Outer Join */
proc sql;
select *
   from customers as c
        left join
        transactions as t
   on c.ID=t.ID;
quit;

/* 5. Performing a Right Outer Join */
proc sql;
select *
   from customers as c
        right join
        transactions as t
   on c.ID=t.ID;
quit;

/* 6. Performing a Full Outer Join */
proc sql;
select *
   from customers as c
        full join
        transactions as t
   on c.ID=t.ID;
quit;

/* 7. Using the COALESCE Function to Overlay Columns */
proc sql;
select coalesce(c.ID,t.ID) as ID,
       Name, Action, Amount
   from customers c full join transactions t
   on c.ID=t.ID;
quit;

/* 8. Performing a Complex Join */
proc sql;
select e.Employee_ID "Employee ID",
          e.Employee_Name "Employee Name",
          m.Employee_ID "Manager ID",
          m.Employee_Name "Manager Name",
          e.Country
   from orion.employee_addresses as e,
           orion.employee_addresses as m,
           orion.employee_organization as o
   where e.Employee_ID=o.Employee_ID and
              o.Manager_ID=m.Employee_ID and
              Department contains 'Sales'
   order by Country,4,1;
quit;
