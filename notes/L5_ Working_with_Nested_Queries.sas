/*******************************************************************************

Working with Nested Queries - a collection of snippets

from Summary of Lesson 5:  Working with Nested Queries
ECSQL193 - SAS SQL 1 - Essentials

- define subqueries
- differentiate between correlated and noncorrelated subqueries
- subset data based on values returned from a subquery
- define in-line views
- create and use in-line views
- use in-line views and subqueries to simplify coding a complex query
*******************************************************************************/


/*******************************************************************************
1. Understanding Subqueries
*******************************************************************************/
/* 1.1 Subqueries*/
/*
A subquery is a query that resides inside an outer query, in a WHERE clause or a HAVING clause. The subquery returns values to be used in the outer query's clause.

A subquery can return only a single column, but it can return one value or multiple values from that column.

PROC SQL evaluates nested queries from the inside out, starting with the subquery, and processing the outer query last.
  SELECT ...
        FROM ...
        <WHERE ...>
                (SELECT only-a-single-column
                       FROM ...
                       <WHERE ...>) /*do not use ';' here in () */
        <GROUP BY ...>
        <HAVING ...>
        <ORDER BY ...>;

!!! a subquery must return only a single column !!!

PROC SQL always processes a subquery before the outer query.
*/


/*******************************************************************************
2. Types of Subqueries
*******************************************************************************/
/* 2.1 noncorrelated subqueries*/
/*
There are two types of subqueries: noncorrelated and correlated.
*/
/* 2.2 Noncorrelated Subquery*/
/*
A noncorrelated subquery is a self-contained subquery. It executes independently of the outer query before it passes one or more values back to the outer query.
Example:
  proc sql;
    select Job_Title,
           avg(Salary) as MeanSalary
       from orion.staff
       group by Job_Title
       having avg(Salary) > (select avg(Salary) as CompanyMeanSalary
       							from orion.staff); /*noncorrelated subquery */
  quit;

Using a noncorrelated subquery enables you to build and test your code in pieces.
*/
/* 2.3 Correlated Subquery*/
/*
A correlated subquery is dependent on the outer query. A correlated subquery requires one or more values to be passed to it by the outer query before the subquery can be resolved.
Example:
  proc sql;
    select Employee_ID,
           Employee_Name as Manager_Name length=25
       from orion.Employee_Addresses
       where 'AU' =
          (SELECT Country
            FROM work.supervisors
            WHERE employee_addresses.Employee_ID=
                supervisors.Employee_ID);
  quit;
This PROC SQL step creates a report that lists the employee ID and name of all Orion Star managers in Australia.
The outer query selects the Employee_ID and Employee_Name columns from the employee_addresses table, which contains information about all Orion Star employees.
However, employee_addresses has no column that indicates which employees are managers.
Instead, the outer query's WHERE clause uses a subquery to identify the managers.

The subquery references the work.supervisors table, which contains information about only the managers.
Notice that the subquery's WHERE clause matches the rows in the two tables by the values of Employee_ID. To do this, the outer query must pass each Employee_ID value to the subquery before the subquery can return a value to outer query.
This subquery is dependent on the outer query, so it cannot stand alone. It is a correlated subquery.
*/

/*******************************************************************************
3. Operators That Accept Multiple Values
*******************************************************************************/
/* 3.1 Operators That Accept Multiple Values*/
/*
The operator that precedes a subquery ... (SELECT ...) indicates whether the outer query will accept only a single value or multiple values.

Example:
  proc sql;
      select Employee_Name, City, Country
         from orion.Employee_Addresses
         where Employee_ID IN /*use IN operator for a list of values*/
            (SELECT Employee_ID
              FROM orion.Employee_Payroll
              WHERE month(Birth_Date)= 2)
         order by Employee_Name;
    quit;

If a subquery returns multiple values, you must use the IN operator, or a comparison operator with either the ANY or ALL keyword.

The EQUAL operator does not accept multiple values. So, when a subquery returns multiple values and the EQUAL operator is used, an error message appears in the log and the query cannot be processed.
*/
/* 3.2 use of the ANY keyword with a comparison operator */
/*
The ANY keyword specifies that at least one of a set of values obtained from a subquery must satisfy a given condition in order for the expression to be true.

Suppose you’re working with a subquery that returns the three values 20, 30, and 40.
  WHERE column-name =ANY (SELECT ...)
This expression is true if the value of the specified column is equal to any one of the values that the subquery returns: 20, 30, or 40.

  WHERE column-name >ANY (SELECT ...)
This expression is true when the value of the specified column is greater than any value returned by the subquery: 20, 30, or 40.
In other words, the expression is true when any value of the column is greater than the smallest value returned by the subquery — in this example, 20.

  WHERE column-name <ANY (SELECT ...)
This expression is true when the value of the specified column is less than any value returned by the subquery: 20, 30, or 40.
In other words, the expression is true when any value of the column is less than the largest value returned by the subquery — in this example, 40.
*/
/* 3.3 use of the ALL keyword with a comparison operator */
/*
The ALL keyword specifies that all of the values from a subquery must satisfy a given condition in order for the expression to be true.

  WHERE column-name >ALL (SELECT ...)
This expression is true when the value of the specified column is greater than all of the values returned by the subquery: 20, 30, or 40.
In this example, the value of the column must be greater than the highest value that the subquery returns, which is 40.

  WHERE column-name <ALL (SELECT ...)
This expression is true when the value of the specified column is less than all of the values returned by the subquery: 20, 30, or 40.
In this example, the value of the column must be less than the smallest value that the subquery returns, which is 20.


/*******************************************************************************
4. Multiple Levels of Subquery Nesting
*******************************************************************************/
/* 4.1 Multiple Levels of Subquery Nesting*/
/*
Subqueries can be nested so that the innermost subquery returns a value or values to be used by the next outer query.

Evaluation always begins with the innermost subquery and works outward.
*/


/*******************************************************************************
5. Understanding In-Line Views
*******************************************************************************/
/* 5.1 */
/*
An in-line view is a query that is nested in the FROM clause of another query.
  SELECT ...
        FROM ...
               (SELECT ...
                       FROM ...
                       <WHERE ...>)
        <WHERE ...>
        <GROUP BY ...>
        <HAVING ...>
        <ORDER BY ...>;

It acts as a virtual table, which the query uses instead of a physical table.

An in-line view can contain any of the clauses in a SELECT statement except for the ORDER BY clause.

Unlike a subquery, an in-line view can return a single column or multiple columns to the outer query.

An in-line view must be enclosed in parentheses.
An in-line view can be referenced only in the query in which it is defined.


/*******************************************************************************
Sample Programs
*******************************************************************************/
/* 1. Using a Subquery That Returns a Single Value */
proc sql;
select Job_Title,
       avg(Salary) as MeanSalary
   from orion.staff
   group by Job_Title
   having avg(Salary) > (38041.51);
quit;

/* 2. Using a Subquery That Returns Multiple Values */
proc sql;
select Employee_Name, City, Country
   from orion.employee_addresses
   where Employee_ID in
      (select Employee_ID
          from orion.employee_payroll
          where month(Birth_Date)=2)
   order by Employee_Name;
quit;

/* 3. Using a Subquery That Returns Multiple Values */
proc sql;
title 'Level IV Sales Reps Who Earn Less Than';
title2 'Any Lower Level Sales Reps';
select  Employee_ID, Salary
   from orion.staff
   where Job_Title='Sales Rep. IV'
      and Salary < any
      (select Salary
          from orion.staff
          where Job_Title in
             ('Sales Rep. I','Sales Rep. II',
             'Sales Rep. III'));
quit;
title;

/* 4. Multiple Levels of Subquery Nesting */
proc sql;
title 'Home Phone Numbers of Sales Employees';
title2 'Who Made Donations';
select Employee_ID, Phone_Number as Home_Phone
   from orion.employee_phones
   where Phone_Type='Home' and
         Employee_ID in
      (select Employee_ID
       from orion.employee_donations
          where Employee_ID in
             (select Employee_ID
              from orion.sales));
quit;
title;

/* 6. Using an In-Line View */
proc sql;
title  'Employees with Salaries less than';
title2 '95% of the Average for their Job';
select Employee_Name, emp.Job_Title,
       Salary format=comma7., Job_Avg format=comma7.
   from (select Job_Title,
                avg(Salary) as Job_Avg format=comma7.
            from orion.employee_payroll as p,
                 orion.employee_organization as o
            where p.Employee_ID=o.Employee_ID
                  and Employee_Term_Date is missing
                  and Department="Sales"
            group by Job_Title) as job,
        orion.salesstaff as emp
   where emp.Job_Title=job.Job_Title
         and Salary < Job_Avg*.95
		 and Emp_Term_Date is missing
   order by Job_Title, Employee_Name;
quit;
title;

/* 7. Using an In-Line View and a Subquery */
proc sql;
select Employee_Name format=$25. as Name, City
   from orion.employee_addresses
   where Employee_ID in
       (select Manager_ID
           from orion.employee_organization as o,
           (select distinct Employee_ID
               from orion.order_fact as of,
	               orion.product_dim as p
               where of.Product_ID=p.Product_ID
               and year(Order_Date)=2011
               and Product_Name contains
                   'Expedition Zero'
               and Employee_ID ne 99999999) as ID
            where o.Employee_ID=ID.Employee_ID);
