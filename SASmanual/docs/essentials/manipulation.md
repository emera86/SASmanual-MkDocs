[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m421/m421_5_a_sum.htm)

## Using SAS Functions

### `CATX` Concatenation Function

```
CATX(' ', First_Name, Last_Name)
CATX('-',of array_name(*))
```

The **CATX** function **removes leading and trailing blanks**, **inserts delimiters**, and returns a concatenated character string. In the code, you first specify a character string that is used as a delimiter between concatenated items.

!!! tip
    Similar functions are:
    
    * **`CAT`**: concatenates variables similar to the concatenation operator `||` 
    * **`CATT` (concatenate with `TRIM`)**: similar to the `CAT` function, but it **removes the trailing spaces** before concatenating the variables
    * **`CATS` (concatenate with `STRIP`)**: similar to the `CAT` function, but it **removes both the leading and trailing spaces** before concatenating the variables
    * **`CATQ` (concatenate with quotes)**: concatenates variables by using a **delimiter** to separate items and by **adding quotation marks to strings that contain the delimiter**
    
    **Function** | **Equivalent Code**
    :-----------:|:------------------:
    `CAT(OF X1-X4) | <code>X1&#124;&#124;X2&#124;&#124;X3&#124;&#124;X4</code>
    `CATT(OF X1-X4)` | <code>TRIM(X1)&#124;&#124;TRIM(X2)&#124;&#124;TRIM(X3)&#124;&#124;TRIM(X4)</code>
    `CATS(OF X1-X4)` | <code>TRIM(LEFT(X1))&#124;&#124;TRIM(LEFT(X2))&#124;&#124;TRIM(LEFT(X3))&#124;&#124;TRIM(LEFT(X4))</code>
    `CATX(SP, OF X1-X4)` | <code>TRIM(LEFT(X1))&#124;&#124;SP&#124;&#124;TRIM(LEFT(X2))&#124;&#124;SP&#124;&#124;TRIM(LEFT(X3))&#124;&#124;SP&#124;&#124;TRIM(LEFT(X4))</code>
    
Notice that, although no length IS set for the resultant concatenated variable, the longer values that came later in the step are not truncated. Where the length has not been set, the `CAT` functions will set a **length of 200**. This is another significant advantage over using the `||` operator.

Items, or arguments, can be numeric instead of character; numeric arguments are converted to character using `BESTw.` format.

#### Search for Required Values

**Searching for a single character value** (at least one 'Y' answer in a ten-questions questionnaire):
```
DATA yes;
	SET answers;
	IF FIND(CAT(of a1-a10),'Y');
RUN;
```

**Searching for multiple character values** (at least two 'Y' answer in a ten-questions questionnaire):
```
DATA yes;
	SET answers;
	IF COUNTC(CAT(OF a1-a10),'Y') GE 2;
RUN;
```

**Searching for numeric values** (at least one question answered with the value 5 in a ten-questions questionnaire):
```
DATA yes;
	SET answers;
	IF FIND(CAT(OF a:),'5');
RUN;
```

**Searching for a single numeric pattern** (variable whose value starts with '250'):
```
DATA diagnostic-results;
	SET diagnostic-tests;
	IF FIND(CATX('*', OF diag1-diag5),'250') ne 0;
RUN;
```

**Searching for multiple numeric patterns** (variable whose value starts with '250' or '493'):
```
DATA diagnostic-results;
	LENGTH string $100;
	SET diagnostic-tests;
	string = CATX('*', OF diag1-diag5);
	diabetes = (FIND(string,'250') ne 0);
	asthma = (FIND(string,'493') ne 0);
	DROP string;
RUN;
```

**Search for characters in numeric variables**:
```
DATA final-SAS-data-set;
	SET origin-SAS-data-set;
	ARRAY arrayname(3) item1-item3;
	DO _N_ = 1 TO 3 UNTIL (search eq 1);
		search = (CAT(arrayname(_N_)) IN : ('171' '172'));
	END;
RUN;
```

### `DATE` Function

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

### `INTCK` Time Interval Function

```
INTCK('year', Hire_Date, '01JAN2012'd)
```

The `INTCK` function returns the number of interval boundaries of a given kind that lie between the two dates, times, or datetime values. In the code, you first specify the interval value.


!!! warning "What happens when you define a new variable from another that you are gonna `DROP` in this DATA statement?"
    The `DROP` statement is a compile-time-only statement. SAS sets a drop flag for the dropped variables, but the variables are in the PDV and, therefore, are available for processing.
    
### `SUM` Summation Function

```
SUM(argument1, argument2, ...)
```

- The arguments must be numeric values
- The `SUM` function ignores missing values, so if an argument has a missing value, the result of the `SUM` function is the sum of the nonmissing values
- If you add two values by `+`, if one of them is missing, the result will be a missing value, which makes the `SUM` function a better choice

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
    
    * The `ROUND` function: `A = round(A, 0.01);`
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
    
In the `DATA` step, the first reference to a variable determines its length. The first reference to a new variable can be in a `LENGTH` statement, an **assignment** statement, or **another** statement such as an `INPUT` statement. After a variable is created in the PDV, the length of the variable's first value doesn't matter. 

To avoid truncation in a variable defined inside a conditional structure you can:

- Define the longer string as the first condition
- Add some blanks at the end of shorter strings to fit the longer one
- Define the length explicitly before any other reference to the variable

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

The dataset `period` has more than one register per patient and the calculation of time periods between each one and the reference.
```
PROC SORT DATA=period;
	BY pt periodmax periodvisit;
RUN;
```

If you want to keep only highest/lowest value (last/first value after the sorting), you need to use the `last.`/`.first` functions.
```
DATA maxperiod;
	SET period;
	BY pt;
	IF last.pt;
RUN;
```
