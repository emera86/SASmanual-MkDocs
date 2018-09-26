## Creating a Macro Variable during `DATA` Step Execution

### Using the `CALL SYMPUTX` Routine

You can use the SAS `CALL` routine `SYMPUTX` to create and assign a value to a macro variable during execution.
```
CALL SYMPUTX(macro-variable, value);
```
`CALL` routines are similar to functions in that you can pass arguments to them and they perform a calculation or manipulation of the arguments. `CALL` routines differ from functions in that you can't use `CALL` routines in assignment statements or expressions. `CALL` routines don't return a value. Instead, they might alter the value of one or more arguments.

To invoke a SAS `CALL` routine, you specify the name of the routine after the keyword `CALL` in the `CALL` statement. The first argument to `SYMPUTX` is the name of the macro variable to be created or modified. It can be a character literal, a variable, or an expression that resolves to a valid macro variable name. The second argument is the value to be assigned to the macro variable. It can be a character or numeric constant, a variable, or an expression. If character literals are used as arguments, they must be quoted.

**Example:** What is the value of `foot` after execution of this `DATA` step?
```
data _null_;
    call symputx('Foot','No Internet orders');
    %let foot=Some Internet orders;
run;
```

The value of `foot` is 'No Internet Orders'. Word scanning begins. The `%LET` is executed by the macro processor. The step boundary is reached and the `DATA` step executes. `SYMPUTX` changes the value of foot.

### Using `SYMPUTX` with a `DATA` Step Variable

You can use the `SYMPUTX` routine to assign the value of a `DATA` step variable to a macro variable. This time, the second argument will be a `DATA` step variable.
```
CALL SYMPUTX(macro-variable, DATA-step-variable);
```

* The value of the DATA step variable is assigned to the macro variable during execution.
* Numeric values are automatically converted to character using the BEST32. format.
* Leading and trailing blanks are removed from both arguments.
* You can assign a maximum of 32,767 characters to the receiving macro variable.

### Using `SYMPUTX` with a `DATA` Step Expression

The second argument to the `SYMPUTX` routine can also be an expression, and it can include arithmetic operations or function calls to manipulate data.
```
CALL SYMPUTX(macro-variable, expression);
```
You can use the `PUT` function as part of the call to the SYMPUTX routine in a `DATA` step to explicitly convert a numeric value to a character value.
```
PUT (source, format.);

/* Example: */
CALL SYMPUTX ('date', PUT(Begin_Date, mmddyy10.));
```

This `CALL` statement assigns the value of the `DATA` step variable `Begin_Date` to the macro variable date. The `PUT` function explicitly converts the value of `Begin_Dat`e to a character value using the `MMDDYY10.` format. The conversion occurs before the value is assigned to the macro variable.

## Passing Data between Steps

!!! tip
    You can use a `DATA _NULL_` step with the `SYMPUTX` routine to create macro variables and pass data between program steps.

### Creating Indirect References to Macro Variables

You can use the `SYMPUTX` routine with `DATA` step expressions for both arguments to create a series of macro variables, each with a unique name. 

To create an **indirect reference**, you precede a name token with **multiple ampersands**. When the macro processor encounters two ampersands, it resolves them to one ampersand and continues to rescan from left to right, from the point where the multiple ampersands begin. This action is known as the **Forward Rescan Rule**.

**Example:** Given the macro variables and values shown in the following global symbol table, the `PROC PRINT` step will print all classes that are taught in a particular city. The statement is written in such a way that you would need to change only the value of `crslo`c in order for the `PROC PRINT` step to print classes that are taught in a different city.

*Global Symbol Table*

| Name	| Value |
|:---:|:---:|
| city1	| Dallas |
| city2	| Boston |
| city3 | Seattle |

```
%let crsloc=2;
proc print data=schedule;
    where location="&&city&crsloc";
run;
```

You precede the macro variable name `city` with **two ampersands**. Then you add a reference to the macro variable `crsloc` immediately after the first reference in order to build a new token.

You need to use **three ampersands** in front of a macro variable name when its value exactly **matches the name of a second macro variable**.

**Example:** Given the macro variables and values shown in this global symbol table, the correspondance between each macro variable reference and its resolved value.

*Global Symbol Table*

| Name	| Value |
|:---:|:---:|
cat100	| Outerwear
cat120	| Accessories
sale	| cat100

| Macro variable | Resolved value |
|:---:|:---:|
| `&sale` | cat100 |	 	 
| `&&sale` | cat100 |	  
| `&&&sale` | Outerwear |	 	

## Creating Macro Variables Using PROC SQL

### Creating Macro Variables Using PROC SQ 

You can also create or update macro variables during the execution of a PROC SQL step.
PROC SQL;
      SELECT column-1<,column-2,…>
            INTO :macro-variable-1<, :macro-variable-2,…>
            FROM table-1 | view-1
            <WHERE expression>
                   <other clauses>;
QUIT;

In PROC SQL, the SELECT statement generates a report by selecting one or more columns from a table. The INTO clause in a SELECT statement enables you to create or update macro variables. The values of the selected columns are assigned to the new macro variables.

You specify the keyword INTO, followed by a colon and then the name of the macro variable(s) to be created. Separate multiple macro variables with commas; each must start with a colon. The colon doesn't become part of the name.
Unlike the %LET statement and the SYMPUTX routine, the PROC SQL INTO clause doesn't remove leading and trailing blanks from the values. You can use a %LET statement to remove any leading or trailing blanks that are stored in the value.

You can use the PROC SQL NOPRINT option to suppress the report if you don't want output to be displayed.
PROC SQL NOPRINT;
      SELECT column-1
            INTO :macro-variable-1 - :macro-variable-n
            FROM table-1 | view-1
            <WHERE expression>
            <ORDER BY order-by-item <,...order-by-item>>
            <other clauses>;
QUIT;
Code Challenge:
Complete the following statement so that it will create a macro variable named price with a value that is equal to the value of the data set variable Fee in the first observation of the courses data set.
  proc sql;
   select fee
      into ....;
      from courses;
    quit;
The correct answer is
      into :price
You specify the keyword INTO, then you precede the macro variable name with a colon. Remember, you don't end the INTO clause with a semicolon.

Code Challenge:
Complete the following SELECT statement so that it creates a series of macro variables named place1, place2, place3, and so on. This statement should create as many new macro variables as are needed so that each new macro variable will be assigned a value of a distinct city and state where a student lives (as provided in the data set variable City_State).
The first SELECT statement uses the N function to count the number of distinct city_state values and assigns this number to the macro variable numlocs.
  proc sql;
    select N(distinct city_state)
      into :numlocs
    from students;

    %let numlocs=&numlocs;
    select distinct city_state
      into ...
    from students;
  quit;
The correct answer is
      into :place1-:place&numlocs
You specify :place1 as the first new macro variable name. Then you use a reference to the macro variable numlocs combined with :place in order to specify the final new macro variable in the series.

### Storing a List of Values in a Macro Variable 

You can use the INTO clause in a PROC SQL step to create one new macro variable for each row in the result of the SELECT statement.
You can use an alternate form of the INTO clause in order to take all values of a column (variable) and concatenate them into the value of one macro variable.
PROC SQL NOPRINT;
      SELECT <DISTINCT>column-1
            INTO :macro-variable-1
            SEPARATED BY 'delimiter-1'
            FROM table-1 | view-1
            <WHERE expression>
            <other clauses>;
QUIT;


The INTO clause names the macro variable to be created. The SEPARATED BY clause specifies the character that will be used as a delimiter in the value of the macro variable. Notice that the character is enclosed in quotation marks.

The DISTINCT keyword eliminates duplicates by selecting unique values of the selected column.

After you execute the PROC SQL step, you can use the %PUT statement to write the values to the log.

Code Challenge:
Complete the following SELECT statement so that it creates a macro variable named location that stores all distinct cities in which students live, separated by an asterisk delimiter.
  proc sql;
    select distinct city_state
      ...
      from students;
    quit;
The correct answer is
      into :location separated by '*'
You specify the keyword INTO and precede the macro variable name with a colon. Then you specify the keywords SEPARATED BY and enclose the asterisk in quotation marks.
