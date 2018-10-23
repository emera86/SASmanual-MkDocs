## Understanding Subqueries

A subquery is a query that resides inside an outer query, in a `WHERE` clause or a `HAVING` clause. The subquery returns values to be used in the outer query's clause.

A subquery can **return only a single column**, but it can return one value or multiple values from that column. `PROC SQL` **evaluates nested queries from the inside out**, starting with the subquery, and processing the outer query last.  Subqueries can be nested so that the innermost subquery returns a value or values to be used by the next outer query.

```
  SELECT ...
        FROM ...
        <WHERE ...>
                (SELECT only-a-single-column
                       FROM ...
                       <WHERE ...>) /* do not use ';' here in () */
        <GROUP BY ...>
        <HAVING ...>
        <ORDER BY ...>;
```

**Example:** Multiple Levels of Subquery Nesting
```
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
```

## Types of Subqueries

### Noncorrelated Subquery

A noncorrelated subquery is a **self-contained subquery**. It executes independently of the outer query before it passes one or more values back to the outer query.

**Example:**
```
proc sql;
    select Job_Title, avg(Salary) as MeanSalary
       from orion.staff
       group by Job_Title
       having avg(Salary) > (select avg(Salary) as CompanyMeanSalary from orion.staff); /* noncorrelated subquery */
quit;
```

Using a noncorrelated subquery enables you to build and test your code in pieces.

### Correlated Subquery

A correlated subquery is **dependent on the outer query**. A correlated subquery requires one or more values to be passed to it by the outer query before the subquery can be resolved.

**Example:**

```
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
```

This `PROC SQL` step creates a report that lists the employee ID and name of all Orion Star managers in Australia. The outer query selects the `Employee_ID` and `Employee_Name` columns from the `employee_addresses` table, which contains information about all Orion Star employees. However, `employee_addresses` has no column that indicates which employees are managers. Instead, the outer query's `WHERE` clause uses a subquery to identify the managers.

The subquery references the `work.supervisors` table, which contains information about only the managers. Notice that the subquery's `WHERE` clause matches the rows in the two tables by the values of `Employee_ID`. To do this, the outer query must pass each `Employee_ID` value to the subquery before the subquery can return a value to outer query. This subquery is dependent on the outer query, so it cannot stand alone. It is a correlated subquery.

## Operators that Accept Multiple Values

The operator that precedes a subquery `... (SELECT ...)` indicates whether the outer query will accept only a single value or multiple values.

**Example:**
```
  proc sql;
      select Employee_Name, City, Country
         from orion.Employee_Addresses
         where Employee_ID IN /*use IN operator for a list of values*/
            (SELECT Employee_ID
              FROM orion.Employee_Payroll
              WHERE month(Birth_Date)= 2)
         order by Employee_Name;
    quit;
```

If a subquery returns multiple values, you must use the `IN` operator, or a comparison operator with either the `ANY` or `ALL` keyword. The `EQUAL` operator does not accept multiple values. So, when a subquery returns multiple values and the `EQUAL` operator is used, an error message appears in the log and the query cannot be processed.

**Example:** Using a Subquery That Returns a Single Value 
```
proc sql;
select Job_Title,
       avg(Salary) as MeanSalary
   from orion.staff
   group by Job_Title
   having avg(Salary) > (38041.51);
quit;
```

**Example:** Using a Subquery That Returns Multiple Values 
```
proc sql;
select Employee_Name, City, Country
   from orion.employee_addresses
   where Employee_ID in
      (select Employee_ID
          from orion.employee_payroll
          where month(Birth_Date)=2)
   order by Employee_Name;
quit;
```

**Example:** Using a Subquery That Returns Multiple Values 
```
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
```

### Use of the `ANY` Keyword with a Comparison Operator 

The `ANY` keyword specifies that at least one of a set of values obtained from a subquery must satisfy a given condition in order for the expression to be true.

Suppose you're working with a subquery that returns the three values 20, 30, and 40.

* **`WHERE column-name =ANY (SELECT ...)`**: this is **true if the value of the specified column is equal to any one of the values** that the subquery returns: 20, 30, or 40
* **`WHERE column-name >ANY (SELECT ...)`**: this is **true when the value of the specified column is greater than any value** returned by the subquery: 20, 30, or 40 (i.e. greater than the smallest value returned by the subquery)
* **`WHERE column-name <ANY (SELECT ...)`**: this is **true when the value of the specified column is less than any value** returned by the subquery: 20, 30, or 40 (i.e. less than the largest value returned by the subquery)

### Use of the `ALL` Keyword with a Comparison Operator

The `ALL` keyword specifies that **all of the values from a subquery must satisfy a given condition** in order for the expression to be true.

* **`WHERE column-name >ALL (SELECT ...)`**: this is **true when the value of the specified column is greater than all of the values** returned by the subquery: 20, 30, or 40 (i.e. greater than the highest value that the subquery returns)
* **`WHERE column-name <ALL (SELECT ...)`**: this is **true when the value of the specified column is less than all of the values** returned by the subquery: 20, 30, or 40 (i.e. less than the smallest value that the subquery returns)

## Understanding In-Line Views

An in-line view is a **query that is nested in the `FROM` clause of another query**.

```
  SELECT ...
        FROM ...
               (SELECT ...
                       FROM ...
                       <WHERE ...>)
        <WHERE ...>
        <GROUP BY ...>
        <HAVING ...>
        <ORDER BY ...>;
```

It acts as a **virtual table**, which the query uses instead of a physical table. An in-line view can contain any of the clauses in a `SELECT` statement **except for the `ORDER BY` clause**. Unlike a subquery, an **in-line view can return a single column or multiple columns to the outer query**. An in-line view must be **enclosed in parentheses** and can be referenced only in the query in which it is defined.

**Example:** Using an In-Line View
```
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
```

**Example:** Using an In-Line View and a Subquery 
```
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
```
