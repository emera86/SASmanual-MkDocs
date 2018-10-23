## Introducing Set Operators

### What Are Set Operators?

To **vertically combine the results of two queries**, you can use one of four set operators:

* `UNION`  (ANSI standard for SQL)
* `OUTER UNION`  (SAS enhancement)
* `EXCEPT`  (ANSI standard for SQL)
* `INTERSECT`  (ANSI standard for SQL)

To modify the default behavior of a set operator, you can also use one or both of the modifiers `ALL` and `CORR`.

A set operator vertically combines the intermediate result sets from two queries to produce a final result set. Set operators act on the intermediate result sets, not directly on the input tables.

**Example:** Using a Set Operator in an In-Line View
```
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
```

### How Set Operators Combine Rows and Columns by Default? 

By default, the set operators handle the rows in the intermediate result sets as follows:

* The `UNION` operator produces **ALL UNIQUE rows from BOTH result sets**
* The `OUTER UNION` operator produces **ALL rows from BOTH result sets**
* The `EXCEPT` operator produces **UNIQUE rows from the FIRST result set that are NOT in the SECOND**
* The `INTERSECT` operator produces **UNIQUE rows from the FIRST result set that are in the SECOND**

By default, the set operators handle the columns in the intermediate result sets as follows:

* The `UNION`, `EXCEPT`, and `INTERSECT` operators **align columns by their `POSITION` in both intermediate result sets**
* The `OUTER UNION` operator produces **all columns from both result sets**

### Modifying the Default Behavior of the Set Operators 

To **change the default behavior** of the set operators, you can use one or both of the **modifiers `ALL` and `CORR`** (or `CORRESPONDING`) along with each set operator.

#### `ALL` Modifies the Default Behavior for Rows

The `UNION`, `EXCEPT`, and `INTERSECT` set operators produce **only the unique rows** by default. To produce only the unique rows, `PROC SQL` must make a **second pass through the data to eliminate the duplicate rows**. When used with these three operators, the **`ALL` modifier prevents this second pass**, which means it does not suppress the duplicate rows.

!!! warning
    `ALL` cannot be used with the `OUTER UNION` operator.

#### `CORR` Modifies the Default Behavior for Columns

With the `UNION`, `EXCEPT`, and `INTERSECT` operators, the **`CORR` modifier aligns columns that have the same `NAME` (not the same position)** in both intermediate result sets **instead of aligning columns by position**. With these three operators, `CORR` also **suppresses** any columns with names that do not appear in both intermediate result sets.

With the `OUTER UNION` operator, `CORR` aligns columns by `NAME`, like the other operators, instead of producing all columns. However, the final result set includes any columns that do not appear in both result sets.

!!! tip 
    Remember that you can use `ALL` and `CORR` separately or together, except when you are using the `OUTER UNION` operator.

### Syntax of a Set Operation

A set operation consists of two sets of query clauses that are combined by one of the four set operators and, optionally, one or both modifiers.
```
  SELECT ...
  UNION | OUTER UNION | EXCEPT | INTERSECT
  <ALL> <CORR>
  SELECT ...;
```

A `SELECT` statement can contain more than one set operation.
```
  SELECT *
    FROM table-one
  UNION
  SELECT *
    FROM table-two
  UNION
  SELECT *
    FROM table-three;
```

No matter how many set operations a `SELECT` statement contains, it always produces one final result set.

## Order of Evaluation of Set Operators

If your set operation contains multiple instances of the **same set operator**, `PROC SQL` processes the set operations in order, from top to bottom.

If a single statement contains **different set operators**, `PROC SQL` **follows specific rules to determine the order** in which to evaluate the set operations. By default, within a single statement, `PROC SQL` evaluates the `INTERSECT` operator first. The other three operators (`UNION`, `OUTER UNION`, and `EXCEPT`) have the same order of precedence, so `PROC SQL` will evaluate them in the order in which they appear in the statement. 

To override the default order in which `PROC SQL` evaluates the set operators, you can add parentheses to your code. `PROC SQL` combines any queries that are enclosed in parentheses first.

**Example:** Combining Set Operators
```
title "Who on Bob's Team Has Not";
title2 'Started Any Training';
proc sql;
select ID, Name from orion.team
except
(select ID, Name from orion.train_a
 union
 select ID, Name from orion.train_b);
quit;
```

## Using the `UNION` Operator

### Using the `UNION` Operator without Modifiers 

By default, to process a set operation with the `UNION` operator, the SQL processor performs two main steps:

1. Vertically combines the rows from the two intermediate result sets (by default, the columns are aligned by position and to be aligned, the columns must have the same type)
2. Identifies and removes any duplicate rows from the combined result set

The final result set consists of the remaining rows.

### Using the `UNION` Operator with the `CORR` Modifier 

When the `CORR` modifier is used with the `UNION` operator, the SQL processor performs two main steps:

1. Aligns columns by name and removes all columns that do not have a matching name in the other result set
2. Removes the duplicate rows from the combined result set

**Example:** Using the `UNION` Operator with the `CORR` Modifer
```
proc sql;
select *
   from orion.train_a
union corr
select *
   from orion.train_b
   where Edate is
         not missing;
quit;
```

### Using the `UNION` Operator with the `ALL` Modifier 

In certain situations, you can increase the efficiency of your code by adding the `ALL` modifier to suppress the removal of duplicate rows. It makes sense to use the `ALL` modifier when the presence of duplicate rows in the final result set is not a problem, or duplicate rows are not possible (e.g. a column might have a unique or primary key constraint).

**Example:** Combining Three Queries with the `UNION` Operator and the `ALL` Modifier
```
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
```

## Using the `OUTER UNION` Operator

### Using the `OUTER UNION` Operator Alone and with the `CORR` Modifier 

By default, the `OUTER UNION` operator vertically combines the rows from both intermediate result sets. However, unlike the `UNION` operator, `OUTER UNION` does not align common columns by default or remove duplicate rows.

When `CORR` is used with `OUTER UNION`, it overlays common columns. However, with `UNION`, the `CORR` modifier does not suppress columns that have different names, as it does with the other set operators.

**Example:** Using the `OUTER UNION` Operator with the `CORR` Modifer
```
proc sql;
select *
   from orion.train_a
outer union corr
select *
   from orion.train_b
   where EDate is
         not missing;
quit;
```

### `OUTER UNION` Set Operation versus Traditional SAS Programming

There are several methods of using SAS to vertically combine all of the rows and columns in two results sets. The most common alternative to the `OUTER UNION` set operator with the `CORR` modifier is the `SET` statement in the `DATA` step.

## Using the `EXCEPT` Operator

### Using the `EXCEPT` Operator without Modifiers 

By default, the `EXCEPT` operator vertically combines two intermediate result sets as follows:

1. After producing the two intermediate result sets, `PROC SQL` removes any duplicate rows within the first result set (none of the rows in the second result set will appear in the final result, so there is no need to look for duplicates there)
2. Aligns the columns by their position in the intermediate result sets (to be aligned, the columns must be the same type)
3. Identifies and removes any rows in the first result set that match any rows in the second result set

The final result set contains the rows and columns that remain in the first result set.

### Using the `EXCEPT` Operator with Modifiers

When `ALL` is used with the `EXCEPT` operator, duplicate rows are not removed from the intermediate result sets.

With `CORR`, the columns are aligned by name instead of by position in order to identify matching rows. Columns that do not have the same name in both intermediate result sets are eliminated from the final result set.

**Example**: Using the `EXCEPT` Operator with the `ALL` and `CORR` Modifers
```
proc sql;
select *
   from orion.train_a
except all corr
select *
   from orion.train_b
   where EDate is
         not missing;
quit;
```

## Using the `INTERSECT` Operator

### Using the `INTERSECT` Operator without Modifiers

By default, the `INTERSECT` operator vertically combines two intermediate result sets as follows:

1. After producing the two intermediate result sets, `PROC SQL` removes any duplicate rows within each of the intermediate result sets
2. Aligns the columns by their position in the intermediate result sets (to be aligned, the columns must be the same type)
3. Identifies any rows in the first result set that match any rows in the second result set

The final result set contains the matching rows in the first result set. The column names in the final result set are determined by the first result set.

### Using the `INTERSECT` Operator with Modifiers

When `ALL` is used with the `INTERSECT` operator, duplicate rows are not removed from the intermediate result sets.

**Example:** Using the `INTERSECT` Operator with the `ALL` Modifier
```
proc sql;
select ID, Name
   from orion.train_a
intersect all
select ID, Name
   from orion.train_b
   where EDate is
         not missing;
quit;
```

With `CORR`, the columns are aligned by name instead of by position in order to identify matching rows. Columns that do not have the same name in both intermediate result sets are eliminated from the final result set.
