[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m417/m417_4_a_sum.htm)

To create a new data set that is a subset of a previous data set:

```
DATA output-SAS-data-set;
	SET input-SAS-data-set;
    WHERE where-expression;
    variable_name	WHERE where-expression;
	variable_name = expression;     /* new variable creation */
RUN;
```

**Note1:** if a missing value is involved in an arithmetic calculation the result will be a missing value too

**Note2:** new variables being created in the DATA step and not contained in the original data set cannot be used in a WHERE statement

### Customizing a SAS Data Set

How to select a subset of the variables/observations of the original data set:

```
DATA output-SAS-data-set;
    SET input-SAS-data-set;
    DROP variable-list;        /* original variables to exclude */
    KEEP variable-list;        /* original variables to include + new variables */
RUN;
```

How SAS processes the **DATA** step:

**Compilation phase**

- SAS scan each DATA step statement for syntax errors and converts the program into machine code if everything's alright. 
- SAS also creates the program data vector (**PDV**) in memory to hold the current observation.
 - **\_N\_**: iteration number of the DATA step
 - **\_ERROR\_**: its value is 0 is there are no errors (1 if there are some)
- SAS creates the descriptor portion of the new data set (takes the original one, adds the new variables and flags the variables to be dropped). 

**Execution phase**

- SAS initializes the PDV to missing
- SAS reads and processes the observations from the input data set 
- SAS creates observations in the data portion of the output data set (an implicit output/implicit return loop over all the observations that continues until EOF)

---

Subsetting **IF** statement: 

```
DATA output-SAS-data-set;
	SET input-SAS-data-set;
    IF expression;
RUN;
```

* When the expression is false, SAS excludes the observation from the output data set and continues processing
* While original values can be managed with a **WHERE** statement as well as an **IF** statement, for **new variable** conditionals only **IF** can be used
* You should subset as early as possible in your program for more efficient processing (a **WHERE** before an **IF** can make the processing more efficient).
* In a **PROC** step **IF** statements are **NOT allowed**

---

Subsetting **IF-THEN/DELETE** statement: 

```
DATA output-SAS-data-set;
	SET input-SAS-data-set;
	IF expression1 or expression2 THEN DELETE;
RUN;
```

* The **IF-THEN/DELETE** statement eliminates the observations where the **conditions are not met** (on the contrary of what the **IF** does)
* The **DELETE** statement stops processing the current observation. It is often used in a THEN clause of an IF-THEN statement or as part of a conditionally executed DO group.

---

Addition of several variables: **Total=sum(var1, var2, var3)**
Count of nonmissing values: **Nonmissing=n(var1, var2, var3)**

### Adding Permanent Attributes

***Permanent variable labels***

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

* If you use the **LABEL** statement in the **PROC** step the labels are **temporary** while if you use it in the **DATA** step, SAS **permanently** associates the labels to the variables
* Labels and formats that you specify in **PROC** steps override the permanent labels in the current step. However, the permanent labels are not changed.

***Permanent variable formats***

```
DATA output-SAS-data-set;
    SET input-SAS-data-set;
    FORMAT variable1 format1
           variable2 format2;
RUN;
```