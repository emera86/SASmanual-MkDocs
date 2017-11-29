[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m421/m421_5_a_sum.htm)

## Using SAS Functions

###`SUM` Summation Function

```
SUM(argument1, argument2, ...)
```

- The arguments must be numeric values
- The `SUM` function ignores missing values, so if an argument has a missing value, the result of the `SUM` function is the sum of the nonmissing values
- If you add two values by `+`, if one of them is missing, the result will be a missing value, which makes the `SUM` function a better choice

---

###`DATE` Function

```
YEAR(SAS-date)     
QTR(SAS-date)
MONTH(SAS-date)
DAY(SAS-date)
WEEKDAY(SAS-date)
TODAY()                /* Obtain the current date and convert to SAS-date (no argument) */
DATE()                 /* Obtain the current date and convert to SAS-date (no argument) */
MDY(month, day, year)
```

- The arguments must be numeric values (except from `TODAY()` and `DATE()` functions)
- You can subtract dates: `Agein2012=(Bday2012-Birth_Date)/365.25;`

---

### `CATX` Concatenation Function

```
CATX(' ', First_Name, Last_Name)
```

The **CATX** function removes leading and trailing blanks, inserts delimiters, and returns a concatenated character string. In the code, you first specify a character string that is used as a delimiter between concatenated items.

---

### `INTCK` Time Interval Function

```
INTCK('year', Hire_Date, '01JAN2012'd)
```

The `INTCK` function returns the number of interval boundaries of a given kind that lie between the two dates, times, or datetime values. In the code, you first specify the interval value.


!!! warning "What happens when you define a new variable from another that you are gonna `DROP` in this DATA statement?"
    The `DROP` statement is a compile-time-only statement. SAS sets a drop flag for the dropped variables, but the variables are in the PDV and, therefore, are available for processing.

## Conditional Processing

### `IF-THEN-ELSE` Conditional Structures

```
IF expression THEN statement;
ELSE IF expression THEN statement;
ELSE statement;
```

In the conditional expressions involving strings watch out for possible mixed case values where the condition may not be met:  `country = UPCASE(country);` to avoid problems

!!! warning "What do you mean 0.73 doesn't equal 0.73?"
    When comparing numeric values, you may get unexpected results when the values of your variables seem to be the same (but actually they are not). The key to making sure these issues do not introduce erroneous results lies in understanding how numeric values are actually stored in data sets and in memory. This is referred to as **numeric representation and precision**. Read this article for more information: [Numeric Representation and Precision in SAS and Why it Matters](https://www.pharmasug.org/proceedings/2014/CC/PharmaSUG-2014-CC50.pdf).
    Main solutions to this problem:
    
    * The `ROUND`function: `A = round(A, 0.01);`
    * Character versions of numeric variables: `CharA = put(A, best.);`
    * Options in procedures: `PROC COMPARE BASE=baseds COMPARE=compds CRITERION=0.0000001;`

### Executing Multiple Statements

```
IF expression THEN
    DO;
        executable statements;
    END;
ELSE IF expression THEN
    DO;
        executable statements;
    END;
```
    
---
    
In the `DATA` step, the first reference to a variable determines its length. The first reference to a new variable can be in a `LENGTH` statement, an **assignment** statement, or **another** statement such as an `INPUT` statement. After a variable is created in the PDV, the length of the variable's first value doesn't matter. 

To avoid truncation in a variable defined inside a conditional structure you can:

- Define the longer string as the first condition
- Add some blanks at the end of shorter strings to fit the longer one
- Define the length explicitly before any other reference to the variable

---

### `SELECT` Group

```
SELECT(Gender);
      WHEN('F') DO;
         Gift1='Scarf';
         Gift2='Pedometer';
      END;
      WHEN('M') DO;
         Gift1='Gloves';
         Gift2='Money Clip';
      END;
      OTHERWISE DO;
         Gift1='Coffee';
         Gift2='Calendar';
      END;
END;
```

- The `SELECT` statement executes one of several statements or groups of statements
- The `SELECT` statement begins a `SELECT` group. They contain `WHEN` statements that identify SAS statements that are executed when a particular condition is true
- Use at least one `WHEN` statement in a `SELECT` group
- An optional `OTHERWISE` statement specifies a statement to be executed if no `WHEN` condition is met
- An `END` statement ends a `SELECT` group

## Avoiding Duplicates

```
* Period has more than one register per patient and the calculation of time periods between each one and the reference;
PROC SORT DATA=period;
	BY pt periodmax periodvisit;
RUN;

* Keep only highest (last value after the sorting);
DATA maxperiod;
	SET period;
	BY pt;
	IF last.pt;
RUN;
```
