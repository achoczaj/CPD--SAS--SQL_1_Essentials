/*******************************************************************************

Working with Set Operators
  to vertically combine the results from two queries - a collection of snippets

from Summary of Lesson 6:  Working with Set Operators
ECSQL193 - SAS SQL 1 - Essentials

- describe the default behavior of the four SQL set operators: UNION, OUTER UNION, EXCEPT, and INTERSECT
- use each set operator to combine queries, alone and with the modifiers ALL and CORR
*******************************************************************************/


/*******************************************************************************
1. Introducing Set Operators
*******************************************************************************/
/* 1.1 What Are Set Operators? */
/*
To vertically combine the results of two queries, you can use one of four set operators:
- UNION  (ANSI standard for SQL),
- OUTER UNION  (SAS enhancement),
- EXCEPT  (ANSI standard for SQL),
- INTERSECT  (ANSI standard for SQL).

To modify the default behavior of a set operator, you can also use
one or both of the modifiers ALL and CORR.

A set operator vertically combines the intermediate result sets from two queries to produce a final result set. Set operator acts on the intermediate result sets, not directly on the input tables.
*/

/* 1.2 How Set Operators Combine Rows and Columns by Default? */
/*
By default, the set operators handle the rows
in the intermediate result sets as follows:
The UNION operator - produces all UNIQUE rows from BOTH result sets.
The OUTER UNION operator - produces ALL rows from BOTH result sets.

The EXCEPT operator - produces UNIQUE rows from the FIRST result set that are NOT in the second.
The INTERSECT operator - produces UNIQUE rows from the FIRST result set that are in the second.

By default, the set operators handle the columns
in the intermediate result sets as follows:
The UNION, EXCEPT, and INTERSECT operators - align columns by their POSITION in both intermediate result sets.
The OUTER UNION operator - produces all columns from both result sets.
*/

/* 1.3 Modifying the Default Behavior of the Set Operators */
/*
To change the default behavior of the set operators, you can use one or both of the modifiers ALL and CORR (or CORRESPONDING) along with each set operator.

1.3.1 - ALL modifies the default behavior for rows

The UNION, EXCEPT, and INTERSECT set operators produce only the unique rows by default. To produce only the unique rows, PROC SQL must make a second pass through the data to eliminate the duplicate rows. When used with these three operators, the ALL modifier prevents this second pass, which means it does not suppress the duplicate rows.
ALL cannot be used with the OUTER UNION operator.

1.3.2 - CORR modifies the default behavior for columns

With the UNION, EXCEPT, and INTERSECT operators, the CORR modifier aligns columns that have the same NAME (not the same position) in both intermediate result sets instead of aligning columns by position.
With these three operators, CORR also SUPPRESSES any columns with names that do not appear in both intermediate result sets.

With the OUTER UNION operator, CORR aligns columns by NAME, like the other operators, instead of producing all columns. However, the final result set includes any columns that do not appear in both result sets.

Remember that you can use ALL and CORR separately or together, except when you are using the OUTER UNION operator.
*/

/* 1.4 Syntax of a Set Operation */
/*
A set operation consists of two sets of query clauses that are combined by one of the four set operators and, optionally, one or both modifiers.
  SELECT ...
  UNION | OUTER UNION | EXCEPT | INTERSECT
  <ALL> <CORR>
  SELECT ...;

A SELECT statement can contain more than one set operation.
  SELECT *
    FROM table-one
  UNION
  SELECT *
    FROM table-two
  UNION
  SELECT *
    FROM table-three;

No matter how many set operations a SELECT statement contains, it always produces one final result set.

When the same set operator is used multiple times, PROC SQL starts processing at the top and uses the first set operator to combine the first two queries. The final result from the first set operation then becomes the first query in the next set operation.
If a single statement contains different set operators, PROC SQL follows specific rules to determine the order in which to evaluate the set operations.

/*******************************************************************************
2. Using the UNION Operator
*******************************************************************************/
/* 2.1 Using the UNION Operator without Modifiers */
/*
By default, to process a set operation with the UNION operator, the SQL processor performs two main steps:

Vertically combines the rows from the two intermediate result sets. By default, the columns are aligned by position. In order to be aligned, the columns must have the same type.
Identifies and removes any duplicate rows from the combined result set.
The final result set consists of the remaining rows.
*/
/* 2.2 Using the UNION Operator with the CORR Modifier */
/*
When the CORR modifier is used with the UNION operator, the SQL processor performs two main steps:

Aligns columns by name and removes all columns that do not have a matching name in the other result set.
Removes the duplicate rows from the combined result set.
*/
/* 2.3 Using the UNION Operator with the ALL Modifier */
/*
In certain situations, you can increase the efficiency of your code by adding the ALL modifier to suppress the removal of duplicate rows.

It makes sense to use the ALL modifier when
the presence of duplicate rows in the final result set is not a problem,
or
duplicate rows are not possible (For example, a column might have a unique or primary key constraint.)
*/

/*******************************************************************************
3. Using the OUTER UNION Operator
*******************************************************************************/
/* 3.1 Using the OUTER UNION Operator Alone and with the CORR Modifier */
/*
By default, the OUTER UNION operator vertically combines the rows from both intermediate result sets.

However, unlike the UNION operator, OUTER UNION does not align common columns by default or remove duplicate rows.

When CORR is used with OUTER UNION, it overlays common columns. However, with UNION, the CORR modifier does not suppress columns that have different names, as it does with the other set operators.

OUTER UNION Set Operation versus Traditional SAS Programming

There are several methods of using SAS to vertically combine all of the rows and columns in two results sets. The most common alternative to the OUTER UNION set operator with the CORR modifier is the SET statement in the DATA step.
*/

/*******************************************************************************
4. Using the EXCEPT Operator
*******************************************************************************/
/* 4.1 Using the EXCEPT Operator without Modifiers */
/*
By default, the EXCEPT operator vertically combines two intermediate result sets as follows:

After producing the two intermediate result sets, PROC SQL removes any duplicate rows within the first result set. None of the rows in the second result set will appear in the final result, so there is no need to look for duplicates there.
Aligns the columns by their position in the intermediate result sets. In order to be aligned, the columns must be the same type.
Identifies and removes any rows in the first result set that match any rows in the second result set.
The final result set contains the rows and columns that remain in the first result set.
*/
/* 4.1Using the EXCEPT Operator with Modifiers */
/*
When ALL is used with the EXCEPT operator, duplicate rows are not removed from the intermediate result sets.

With CORR, the columns are aligned by name instead of by position in order to identify matching rows. Columns that do not have the same name in both intermediate result sets are eliminated from the final result set.
*/

/*******************************************************************************
5. Using the INTERSECT Operator
*******************************************************************************/
/* 5.1 Using the INTERSECT Operator without Modifiers */
/*

By default, the INTERSECT operator vertically combines two intermediate result sets as follows:

After producing the two intermediate result sets, PROC SQL removes any duplicate rows within each of the intermediate result sets.
Aligns the columns by their position in the intermediate result sets. In order to be aligned, the columns must be the same type.
Identifies any rows in the first result set that match any rows in the second result set.
The final result set contains the matching rows in the first result set. The column names in the final result set are determined by the first result set.

Using the INTERSECT Operator with Modifiers

When ALL is used with the INTERSECT operator, duplicate rows are not removed from the intermediate result sets.

With CORR, the columns are aligned by name instead of by position in order to identify matching rows. Columns that do not have the same name in both intermediate result sets are eliminated from the final result set.

Order of Evaluation of Set Operators

By default, within a single statement, PROC SQL evaluates the INTERSECT operator first. The other three operators (UNION, OUTER UNION, and EXCEPT) have the same order of precedence, so PROC SQL will evaluate them in the order in which they appear in the statement. If your set operation contains multiple instances of the same set operator, PROC SQL processes the set operations in order, from top to bottom.

To override the default order in which PROC SQL evaluates the set operators, you can add parentheses to your code. PROC SQL combines any queries that are enclosed in parentheses first.
*/


/*******************************************************************************
  Sample Programs
*******************************************************************************/
/* 1. Using the UNION Operator with the CORR Modifer */
proc sql;
select *
   from orion.train_a
union corr
select *
   from orion.train_b
   where Edate is
         not missing;
quit;

/* 2. Combining Three Queries with the UNION Operator and the ALL Modifier
title 'Payroll Report for Level I, II,';
title2 'and III Employees';

proc sql;
select 'Total Paid to ALL Level I Staff',
       sum(Salary) format=comma12.
   from orion.staff
   where scan(Job_Title,-1,' ')='I'
union all
select 'Total Paid to ALL Level II Staff',
       sum(Salary) format=comma12.
   from orion.staff
   where scan(Job_Title,-1,' ')='II'
union all
select 'Total Paid to ALL Level III Staff',
       sum(Salary) format=comma12.
   from orion.staff
   where scan(Job_Title,-1,' ')='III';
quit;

title;

/* 3. Using the OUTER UNION Operator with the CORR Modifer
proc sql;
select *
   from orion.train_a
outer union corr
select *
   from orion.train_b
   where EDate is
         not missing;
quit;

/* 4. Using the EXCEPT Operator with the ALL and CORR Modifers
proc sql;
select *
   from orion.train_a
except all corr
select *
   from orion.train_b
   where EDate is
         not missing;
quit;

/* 5. Using a Set Operator in an In-Line View
title 'Number of Employees Who Completed';
title2 'Training A, But Not Training B';
proc sql;
select count(ID) as Count
   from (select ID, Name from orion.train_a
         except
         select ID, Name from orion.train_b
            where EDate is not missing);
quit;
title;

/* 6. Using the INTERSECT Operator with the ALL Modifier
proc sql;
select ID, Name
   from orion.train_a
intersect all
select ID, Name
   from orion.train_b
   where EDate is
         not missing;
quit;

/* 7. Combining Set Operators
title "Who on Bob's Team Has Not";
title2 'Started Any Training';
proc sql;
select ID, Name from orion.team
except
(select ID, Name from orion.train_a
 union
 select ID, Name from orion.train_b);
quit;
