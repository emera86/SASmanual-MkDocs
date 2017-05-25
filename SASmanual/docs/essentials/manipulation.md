[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m421/m421_5_a_sum.htm)

## Using SAS Functions

***SUM function***

```
SUM(argument1, argument2, ...)
```

- The arguments must be numeric values
- The **SUM** function ignores missing values, so if an argument has a missing value, the result of the SUM function is the sum of the nonmissing values
- If you add two values by **+**, if one of them is missing, the result will be a missing value which makes the **SUM** function a better choice

---

***DATE funtion***

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

- The arguments must be numeric values (except from **TODAY()** and **DATE()** functions)
- You can subtract dates: **Agein2012=(Bday2012-Birth_Date)/365.25;**

---
***Concatenation function***

```
CATX(' ', First_Name, Last_Name)
```

The **CATX** function removes leading and trailing blanks, inserts delimiters, and returns a concatenated character string. In the code, you first specify a character string that is used as a delimiter between concatenated items.

---
***Time interval function***

```
INTCK('year', Hire_Date, '01JAN2012'd)
```

The **INTCK** function returns the number of interval boundaries of a given kind that lie between the two dates, times, or datetime values. In the code, you first specify the interval value.

---
***What happens if you use a variable to describe a new one that you are gonna DROP in that same DATA statement?***

The **DROP** statement is a compile-time-only statement. SAS sets a drop flag for the dropped variables, but the variables are in the PDV and, therefore, are available for processing.

## Conditional Processing

***IF-THEN-ELSE conditional structures***

```
IF expression THEN statement;
ELSE IF expression THEN statement;
ELSE statement;
```

In the conditional expressions involving strings watch out for possible mixed case values where the condition may not be met:  **Country = upcase(Country);** to avoid problems

---

***Executing multiple statements in an IF-THEN-ELSE statement***

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
    
In the **DATA** step, the first reference to a variable determines its length. The first reference to a new variable can be in a **LENGTH** statement, an **assignment** statement, or **another** statement such as an INPUT statement. After a variable is created in the PDV, the length of the variable's first value doesn't matter. 

To avoid truncation in a variable defined inside a conditional structure you can:

- Define the longer string as the first condition
- Add some blanks at the end of shorter strings to fit the longer one
- Define the length explicitly before any other reference to the variable

---

***SELECT group***

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

- The **SELECT** statement executes one of several statements or groups of statements
- The **SELECT** statement begins a SELECT group. They contain **WHEN** statements that identify SAS statements that are executed when a particular condition is true
- Use at least one **WHEN** statement in a SELECT group
- An optional **OTHERWISE** statement specifies a statement to be executed if no **WHEN** condition is met
- An **END** statement ends a **SELECT** group
