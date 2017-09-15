[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m417/m417_4_a_sum.htm)

### Subsetting using the `WHERE` statement 

To create a new data set that is a subset of a previous data set:

```
DATA output-SAS-data-set;
	SET input-SAS-data-set;
    WHERE where-expression;
    variable_name	WHERE where-expression;
	variable_name = expression;     /* new variable creation */
RUN;
```

!!! note
    1. If a missing value is involved in an arithmetic calculation the result will be a missing value too
    2. New variables being created in the `DATA` step and not contained in the original data set cannot be used in a `WHERE` statement

### Other `WHERE` options

* Here's how to set a filter for [`WHERE` a variable `IS MISSING`](http://www.sascommunity.org/wiki/Tips:Use_IS_MISSING_and_IS_NULL_with_Numeric_or_Character_Variables)

## Customizing a SAS Data Set

How to select a subset of the variables/observations of the original data set:

```
DATA output-SAS-data-set;
    SET input-SAS-data-set;
    DROP variable-list;        /* variables to exclude */
    KEEP variable-list;        /* variables to include */
RUN;
```

### How SAS processes the `DATA` step

**Compilation phase**

- SAS scan each DATA step statement for syntax errors and converts the program into machine code if everything's alright. 
- SAS also creates the program data vector (**PDV**) in memory to hold the current observation.
 - `_N_`: iteration number of the DATA step
 - `_ERROR_`: its value is 0 is there are no errors (1 if there are some)
- SAS creates the descriptor portion of the new data set (takes the original one, adds the new variables and flags the variables to be dropped). 

**Execution phase**

- SAS initializes the PDV to missing
- SAS reads and processes the observations from the input data set 
- SAS creates observations in the data portion of the output data set (an implicit output/implicit return loop over all the observations that continues until EOF)

### Subsetting using the `IF` statement 

```
DATA output-SAS-data-set;
	SET input-SAS-data-set;
    IF expression;
RUN;
```

* When the expression is false, SAS excludes the observation from the output data set and continues processing
* While original values can be managed with a `WHERE` statement as well as an `IF` statement, for **new variable** conditionals only `IF` can be used
* You should subset as early as possible in your program for more efficient processing (a `WHERE` before an `IF` can make the processing more efficient).
* In a `PROC` step `IF` statements are **NOT allowed**
* `IF THEN` analogue to `CONTAINS`:

```
IF FIND(variable_name,'pattern') THEN (...);
```

### Subsetting `IF-THEN/DELETE` statement

```
DATA output-SAS-data-set;
	SET input-SAS-data-set;
	IF expression1 or expression2 THEN DELETE;
RUN;
```

* The `IF-THEN/DELETE` statement eliminates the observations where the **conditions are not met** (on the contrary of what the `IF` does)
* The `DELETE` statement stops processing the current observation. It is often used in a `THEN` clause of an `IF-THEN` statement or as part of a conditionally executed `DO` group.

!!! tip
    You can remove all the observations with at least one missing value using this condition inside a `DATA` step:
    `if cmiss(of _all_) then delete;`

### Create different data sets from one

```
DATA data1 data2 data3;
	SET original_data;
	IF (condition1) THEN OUTPUT prueba1;
	IF (condition2) THEN OUTPUT prueba2;
	IF (condition3) THEN OUTPUT prueba3;
RUN;
```

### Available operations

* Addition of several variables: `Total=sum(var1, var2, var3)`
* Count of nonmissing values: `Nonmissing=n(var1, var2, var3)`

### Using `PROC SQL` to `GROUP BY` variables

[`PROC SQL`](https://support.sas.com/documentation/cdl/en/sqlproc/63043/PDF/default/sqlproc.pdf) is a wonderful tool for [summarizing or aggregating](http://support.sas.com/kb/25/279.html) data. When you use a [`GROUP BY`](http://support.sas.com/documentation/cdl/en/sqlproc/63043/HTML/default/viewer.htm#n0tf6s2l1rfv5ln1o04ojc4rotu1.htm) clause, you also use an aggregate function in the [`SELECT`](http://support.sas.com/documentation/cdl/en/sqlproc/63043/HTML/default/viewer.htm#p0gs8n2t8df024n1uh160pfr6a0i.htm) clause or in a `HAVING` clause to instruct `PROC SQL` in how to summarize the data for each group:

```
PROC SQL;
	select T, range(survival) as RangeSurvival, sqrt(sum(sdf_stderr**2)) as Squares, range(survival)/sqrt(sum(sdf_stderr**2)) as z,
	       probnorm(abs(range(survival)/sqrt(sum(sdf_stderr**2)))) as pz, 2 * (1-probnorm(abs(range(survival)/sqrt(sum(sdf_stderr**2))))) as pvalue
  	from BTM_param 
	where T > 0
   	group by T;
QUIT;
```

## Adding Permanent Attributes

### Permanent variable labels

```
DATA output-SAS-data-set;
	SET input-SAS-data-set;
    LABEL variable1='label1'
          variable2='label2';
RUN;
```

```
PROC PRINT DATA=output-SAS-data-set label;
RUN;
```

* If you use the `LABEL` statement in the `PROC` step the labels are **temporary** while if you use it in the `DATA` step, SAS **permanently** associates the labels to the variables
* Labels and formats that you specify in `PROC` steps override the permanent labels in the current step. However, the permanent labels are not changed.

### Permanent variable formats

```
DATA output-SAS-data-set;
    SET input-SAS-data-set;
    FORMAT variable1 format1
           variable2 format2;
RUN;
```
