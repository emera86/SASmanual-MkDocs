## Getting Started with SAS Programming
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m411/m411_5_a_sum.htm)

## Working with SAS Programs
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m412/m412_3_a_sum.htm)

***Comments***

```
/* comment */
* comment statement;
```

## Accessing Data
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m413/m413_3_a_sum.htm)

### Accessing SAS libraries

* **libref**: library reference name (shortcut to the physical location). There are three rules for valid librefs:
* A length of one to eight characters
* Begin with a letter or underscore
* The remaining characters are letters, numbers, or underscores
* Valid variable names begin with a letter or underscore, and continue with letters, numbers, or underscores. The **VALIDVARNAME** system option specifies the rules for valid SAS variable names that can be created and processed during a SAS session: 

```
OPTIONS VALIDVARNAME=V7 (default) | UPCASE | ANY;
```

* **libref.data-set-name**: data set reference two-level name
* **data-set-name**: when the data set belongs to a temporary library, you can optionally use a one-level name (SAS assumes that it is contained in the **work** library, which is the default)
* The **LIBNAME** statement associates the **libref** with the physical location of the library/data for the current SAS session

```
LIBNAME libref-name 'SAS-library-folder-path' <options>;
```

*Example*
```
%let path=/folders/myfolders/ecprg193; 
libname orion "&path";
```

* To erase the association between SAS and a custom library

```
LIBNAME libref-name CLEAR;
```

* To check the **contents of a library** programatically

```
PROC CONTENTS DATA=libref._ALL_;
RUN;
```

* To hide the descriptors of all data sets in the library (it could generate a very long report) you can add the option **nods** (only compatible with the keybord **\_all_**)

```
PROC CONTENTS DATA=libref._ALL_ NODS;
RUN;
```

* To access a data set you can use a **proc print** step

```
PROC PRINT DATA=SAS-data-set;
RUN;
```

### Examining SAS Data Sets

Parts of a library (SAS notation):

* Table = **data set**
* Column = **variable**
* Row = **observation**
 
The **descriptor portion** (PROC CONTENTS) contains information about the attributes of the data set (metadata), including the variable names. It is show in three tables:

* Table 1: general information about the data set (name, creation date/time, etc.)
* Table 2: operating environment information, file location, etc.
* Table 3: alphabetic list of variables in the data set and their attributes

The **data portion** (PROC PRINT) contains the data values, stored in variables (numeric/character)

* Numeric values: right-aligned
* Character values: left-aligned
* **Missing values**: ***blank*** for character variables and ***period*** for numeric ones. To change this default behaviour use  `MISSING='new-character'`
* Valid **character values**: letters, numbers, special characters and blanks
* Valid **numeric values**: digits 0-9, minus sign, single decimal point, scientific notation (E)
* Values length: for character variables 1 byte = 1 character, numeric variables have 8 bytes of storage by default (16-17 significant digits)
* Other attributes: **format**, **informat**, **label**

## Producing Detailed Reports
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m415/m415_4_a_sum.htm)

### Subsetting Report Data

```
PROC PRINT DATA=SAS-data-set(OBS=3) NOOBS;  /* OBS=3 prints only 3 elements | NOOBS hides the 'Obs' */
    VAR variable1 variable2 variable3;      /* prints out only this variables in the report */
    SUM variable1 variable2;                /* adds an extra line at the end with the total */
    WHERE variable3<1000; variable3<1000;   /* operators: < > <= >= = ^= in + - / * ** & | ~ ^ ? */
    WHERE variable4 in ('Child','Elder');   /* only the last WHERE condition is applied */
    WHERE variable1=20 AND variable4 CONTAINS 'case-sensitive-substring';  /* CONTAINS = ? */
    IDWHERE ANYALPHA(variable) NE 0         /* only values containing at least a letter */
    ID variable1                            /* replaces the 'Obs' column by a selected variable values */
    BY variable3variable3                   /* separate in different tables for different variable values (sort first) */
RUN;
```

Special **WHERE operators**:

* **BETWEEN x AND y**: an inclusive range
* **WHERE SAME AND**: augment a previous where expression (both applied)
* **IS NULL**: a missing value
* **IS MISSING**: a missing value
* **LIKE**: matches a pattern (% = any number of characters, _ = one character). E.g.: 'T_m%'
* The **SOUNDS-LIKE (=\*)** operator selects observations that contain a spelling variation of a specified word or words. This operator uses the *Soundex* algorithm to compare the variable value and the operand.
* [**ANYVALUE**](http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a002194060.htm) is an interesting function that searches a character string for an alphabetic character, and returns the first position at which the character is found


**Note:** To compare with a SAS date value you need to express is as a SAS date constant: **'DDMM<\YY>YY'D**

### Sorting and Grouping Report Data

```
PROC SORT DATA=SAS-data-set
    OUT=new-SAS-data-set NODUPKEY;                                           /* optional */
    DUPOUT=work.duplicates;                                                  /* optional */
    BY ASCENDING variable1-to-be-sorted DESCENDING variable2-to-be-sorted;   /* optional (ASCENDING is the default order)*/
RUN;
```

* The **NODUPKEY** option deletes observations with duplicate **BY** values
* **DUPOUT** writes duplicate observations to a separate output data set

### Enhancing Reports

```
TITLEline 'text';       
FOOTNOTEline 'text';

TITLE1 'text1';
TITLE1 'text1_change';     /* Change title text and also cancels all footnotes with higher numbers */
TITLE;                     /* Cancel (erase) all titles */
```

* The **lines** specifies the line (1-10) on which the title/footnote will appear (line = 1 is the default value)
* The title/footnote will remain until you **change** it, **cancel** it or you **end your SAS session**

---

Assigning **temporary labels** to display in the report instead of the variable names:

```
PROC PRINT DATA=SAS-data-set LABEL;           /* you need to add the LABEL option to display the labels */ 
    LABEL variable1 = 'new variable1 name' 
          variable2 = 'new variable2 name';
    LABEL variable3 = 'new variable3 name';
RUN;
```

- The **LABEL** lengths can go up to 256 characters long
- You can specify several labels in one **LABEL** statement or use a separate **LABEL** statement for each variable

```
PROC PRINT DATA=SAS-data-set SPLIT='*';            /* you no longer need to add the LABEL option, SPLIT does the same work */ 
    LABEL variable1 = 'new variable1*long name';   /* the variable name ocuppies 2 lines now */
RUN;
```

## Formatting Data Values
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m416/m416_3_a_sum.htm)

### Using SAS Formats

```
PROC PRINT DATA=SAS-data-base;
    FORMAT FORMAT variable1 variable2 format;
    FORMAT variable3 format3 variable4 format4;
RUN;
```

Format definition: **<\$>*format*<\w>.<\d>**

* **<\$>** = character format
* ***format*** = format name
* **<\w>** = total width (includes special characters, commas, decimal point and decimal places)
* **.** = required syntax (dot)
* **<\d>** = decimal places (numeric format)

SAS formats ([Dictionary of formats](http://support.sas.com/documentation/cdl/en/leforinforref/64790/HTML/default/viewer.htm#p0z62k899n6a7wn1r5in6q5253v1.htm)):

* **\$w.** = writes standard character data
* **\$UPCASE.** = writes a string in uppercase
* **\$QUOTE.** = writes a string in quotation marks 
* **w.d** = writes standard numeric data
* **COMMAw.d** = writes numeric values with a comma that separates every three digits and a period that separates the decimal fraction
* **DOLLARw.d** = writes numeric values with a leading dollar sign, a comma that separates every three digits and a period that separates the decimal fraction
* **COMMAXw.d** = writes numeric values with a period that separates every three digits and a coma that separates the decimal fraction
* **EUROXw.d** = writes numeric values with a leading euro symbol, a period that separates every three digits and a comma that separates the decimal fraction

SAS date values: **MMDDYY<\w>.** / **DDMMYY<\w>.** / **MONYY<\w>.** / **DATE<\w>.** / **WEEKDATE.**
* w = 6: only date numbers
* w = 8: date numbers with **/** separators (just the last 2 digits of year)
* w = 10: date numbers with **/** separators (full 4-digit year)

**Note:** dates before 01/01/1960 (0 value) will appear as negative numbers

### Creating and Applying User-Defined Formats

```
PROC FORMAT;
	VALUE <$>format-name value-or-range1='formatted-value1'
                         value-or-range2='formatted-value2';
RUN;
```

```
PROC PRINT DATA=SAS-data-set;
    FORMAT variable1 <$>format-name.;
RUN;
```

* A format name can have a maximum of **32 characters**
* The name of a format that applies to **character values** must begin with a **dollar sign** followed by a letter or underscore
* The name of a format that applies to **numeric values** must begin with a letter or underscore
* A format name cannot end in a number
* All remaining characters can be letters, underscores or numbers
* A user defined format name cannot be the name of a SAS format

Each **value-range set** has three parts:

* **value-or-range**: specifies one or more values to be formatted (it can be a value, a range or a list of values)
* **=**: equal sign
* **formatted-value**: the formatted value you want to display instead of the stored value/s (it is allways a character string no matter wheter the format applies to character values or numeric values)

```
PROC FORMAT LIBRARY = my-format-library;   /* To save the custom formats */
    VALUE string 'A'-'H'='First'
                 'I','J','K'='Middle'
                  OTHER = 'End';           /* Non-specified values */
    VALUE tiers low-<50000='Tier1'         /* 50000 not included */
                50000-<100000='Tier2'      /* 100000 not included */
                100000-high='Tier3'
                .='Missing value';
RUN;
```

**Note1:** if you omit the **LIBRARY** option, then formats and informats are stored in the **work.formats** catalog

**Note2:** if you do not includ the keyword **OTHER**, then SAS applies the format only to values that match the value-range sets that you specify and the rest of values are displayed as they are stored in the data set

**Note3:** you can only use the **<** symbol to define a non-inclusive range.

```
OPTIONS FMTSEARCH = (libref1 libref2... librefn)
```

* The **FMTSEARCH** system option controls the order in which format catalogs are searched until the desired member is found.
* The **WORK.FORMATS** catalog is always searched first, unless it appears in the **FMTSEARCH** list. 

## Reading SAS Data Sets
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

## Reading Spreadsheet and Database Data
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m418/m418_3_a_sum.htm)

### Reading Spreadsheet Data

To determine the SAS products that are included in your SAS license, you can run the following PROC SETINIT step:

```
PROC SETINIT;
RUN;
```

---

SAS/ACCESS LIBNAME statement (read/write/update data):

```
LIBNAME libref <engine> <PATH=>"workbook-name" <options>;
```

E.g.:<br>
**Default engine:** `LIBNAME orionx excel "&path/sales.xls"`<br>
**PC Files server engine:** `LIBNAME orionx pcfiles PATH="&path/sales.xls"`<br>

- **<\engine>**: excel (if both SAS and Office are 32/64 bits), pcfiles (if the value is different)
- The icon of the library will be different (a globe) indicating that the data is outside SAS
- The members whose name ends with a **\$** are the **spreadsheets** while the others are named **ranges**. In case it has the **\$**, you need to refer to that Excel worksheet in a special way to account for that special character (SAS name literal): `libref.'worksheetname\$'n`
- You can use the **`VALIDVARNAME = v7`** option in SAS Enterprise Guide to cause it to behave the same as in the SAS window environment
- Is important to disassociate the library: the workbook cannot be opened in Excel meanwhile (SAS puts a lock on the Excel file when the libref is assigned): **`LIBNAME libref CLEAR;`**

---

Import the xls data:

```
PROC IMPORT DATAFILE="/folders/myfolders/reading_test.xlsx"
            OUT=work.myexcel
            DBMS=xlsx 
            REPLACE;
RUN;
```

### Reading Database Data

```
LIBNAME libref engine <SAS/ACCESS options>;
```

- **engine**: oracle or BD2
- **SAS/ACCESS options**: USER, PASSWORD/PW, PATH (specifies the Oracle driver, node and database), SCHEMA (enables you to read database objects such as tables and views)

## Reading Raw Data Files
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m419/m419_5_a_sum.htm)

### Introduction to Reading Raw Data Files

- **Raw data files** are not software specific
- A **delimited raw data file** is an external text file in which the values are separated by spaces or other special characters.
- A **list input** will be used to work with delimited raw data files that contain standard and/or nonstandard data
- **Standard data** is data that SAS can read without any special instructions
- **Nonstandard data** includes values like dates or numeric values that include special characters like dollar signs (extra instructions needed)

### Reading Standard Delimited Data

```
DATA output-SAS-data-set-name;
	LENGTH variable(s) <$> length;
	INFILE 'raw-data-file-name' DLM='delimiter';  
	INPUT variable1 <$> variable2 <$> ... variableN <$>;    /* $ = character variables */     
RUN;
```

**E.g.:**<br>

```
DATA work.sales1;
	LENGTH First_Name Last_Name $ 12 Gender $ 1;
	INFILE '&path/sales.csv' DLM=',';  
	INPUT Employee_ID Gender $ Salary $ Job_Title $ Country $; 
RUN;
```

- With **list input**, the default length for all variables is 8 bytes
- SAS uses an **input buffer** only if the input data is a raw data file
- The variable names will appear in the report as stated in the **LENGTH** statement (watch out the uppercase/lowercase)
- The **LENGTH** statement must precede the **INPUT** statement in order to correctly set the length of the variable
- The variables not specified in the **LENGTH** statement will appear at the end of the table. If you want to keep the original order you should include all variables even if you want them to have the defaul length (8)


### Reading Nonstandard Delimited Data

You can use a **modified list input** to read all of the fields from a raw data file (including nonstandard variables)

- Informats are similar to formats except that **formats** provide instruction on how to **write** a value while **informats** provide instruction on how to **read** a value
- The **colon format modifier (:)** causes SAS to read up to the delimiter

```
INPUT variable <$> variable <:informat>;
```

**E.g.:**<br>

```
:date.
:mmddyy.
```

- **COMMA./DOLLAR.**: reads nonstandard numeric data and removes embedded commas, blanks, dollar sign, percent signs and dashes
- **COMMAX./DOLLARX.**: reads nonstandard numeric data and removes embedded non-numeric characters; reverses the roles of the decima point and the comma
- **EUROX.**: reads nonstandard numeric data and removes embedded non-numeric characters in European currency
- **\$CHAR.**: reads character values and preserves leading blanks
- **\$UPCASE.**: reads character values and converts them to uppercase

---

- You cannot use a **WHERE** statement when the input data is a raw data file instead of a SAS data set

---

```
DATA (...);
	INFILE DATALINES DLM=',';   /* only if datalines are delimited */
    INPUT (...);
    DATALINES;
    <instream data>
    ;
 	INPUT (...);
	DATALINES;
<instream data>
;
```

- The null statement (**;**) indicates the end of the input data
- You precede the instream data with the *DATALINES* statement and follow it with a null statement
- The instream data should be the **last part of the DATA step** except for a null statement

**E.g.:**<br>

```
DATA work.managers;
   infile datalines dlm='/';
   input ID First :$12. Last :$12. Gender $ Salary :comma. 
            Title :$25. HireDate :date.;
   datalines;
120102/Tom/Zhou/M/108,255/Sales Manager/01Jun1993
120103/Wilson/Dawes/M/87,975/Sales Manager/01Jan1978
120261/Harry/Highpoint/M/243,190/Chief Sales Officer/01Aug1991
121143/Louis/Favaron/M/95,090/Senior Sales Manager/01Jul2001
121144/Renee/Capachietti/F/83,505/Sales Manager/01Nov1995
121145/Dennis/Lansberry/M/84,260/Sales Manager/01Apr1980
;

title;
```

```
title 'Orion Star Management Team';
proc print data=work.managers noobs;
   format HireDate mmddyy10.;
run;
title;
```

### Validating Data

When SAS encounters a data error, it prints messages and a ruler in the log and assigns a missing value to the affected variable. Then SAS continues processing.

---

***Missing values between delimiters (consecutive delimiters)***

```
INFILE 'raw-data-file-name' <DLM=> DSD;
```

The **DSD** option sets the default delimiter to a comma, treats consecutive delimiters as missing values and enables SAS to read values with embedded delimiters if the value is surrounded by quotation marks

---

***Missing values at the end of a line***

```
INFILE 'raw-data-file-name' MISSOVER;
```

With the **MISSOVER** option, if SAS reaches the end of a record without finding values for all fields, variables without values are set to *missing*.

## Manipulating Data 
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m421/m421_5_a_sum.htm)

### Using SAS Functions

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

### Conditional Processing

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

## Combining SAS Data Sets
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m421/m421_5_a_sum.htm)

### Concatenating Data Sets

***Combine files vertically by concatenating***

```
DATA SAS-data-set;
    SET SAS-data-set1 SAS-data-set2 ...;
RUN;
```

***Combine two different variables that are actually the same one***

```
DATA SAS-data-set;
    SET SAS-data-set1 (RENAME=(old-name1 = new-name1 old-name2 = new-name2)) SAS-data-set2 ...;
RUN;
```

- The name change affects the PDV and the output data set, but has no effect on the input data set
- The **variable attributes** are assigned from the **first data set** in the SET statement
- You will get an **error** in the DATA step if a variable is defined with **different data types** in the files that you are trying to concatenate

### Merging SAS Data Sets One-to-One

***Combine files horizontally by merging***

- The **match-merging** is a process based on the values of common variables
- Data sets are merged in the order that they appear in the MERGE statement
- You may need to **SORT** the files by the **BY-variable(s)** before merging the files

```
DATA SAS-data-set;
    MERGE SAS-data-set1 (RENAME=(old-name1 = new-name1 ...)) SAS-data-set2 ...;
    BY <DESCENDING> BY-variable(s);
    <additional SAS statements>
RUN;
```

- In a **one-to-one** relationship, a single observastion in one data set is related to one, and only one, observation in another data set based on the values of one or more common variables
- In a **one-to-many** relationship, a single observation in one data set is related to one or more observations in another data set
- In a **many-to-one** relationship, multiple observations in one data set are related to one observation in another data set
- In a **many-to-many** relationship, multiple observations in one data set are related to multiple observations in another data set
- Sometimes the data sets have **non-matches**: at least one observation in one of the data sets is unrelated to any observation in another data set based on the values of one or more common variables

### Merging SAS Data Sets One-to-Many

```
DATA SAS-data-set;
    MERGE SAS-data-set1 SAS-data-set2 ...;
    BY <DESCENDING> BY-variable(s);
    <additional SAS statements>
RUN;
```

*In a **one-to-many merge**, does it matter which data set is listed first in the MERGE statement?*

When you reverse the order of the data sets in the MERGE statement, the results are the same, but the order of the variables is different. SAS performs a **many-to-one merge**.

---

**MERGENOBY** (= NOWARN (default) | WARN | ERROR) controls whether a message is issued when MERGE processing occurs without an associated BY statement

* Performing a merge without a BY statement merges the observations based on their positions
* This is almost never done intentionally and can lead to unexpected results

### Merging SAS Data Sets that Have Non-Matches

```
DATA SAS-data-set;
    MERGE SAS-data-set1 SAS-data-set2 ...;
    BY <DESCENDING> BY-variable(s);
    <additional SAS statements>
RUN;
```

* After the merging, the output data set contains **both matches and non-matches**
* You want the new data set to contain only the observations that match across the input data sets, and not those ones that are missing in one of the data sets that you are merging

```
DATA SAS-data-set;
    MERGE SAS-data-set1 (IN=variable1) 
          SAS-data-set2 (IN=variable2) ...;
    BY <DESCENDING> BY-variable(s);
    <additional SAS statements>
RUN;
```

* When you spefify the **IN** option after an input data set in the MERGE statement, SAS creates a **temporary numeric variable** that indicates whether the data set contributed data to the current observation (0 = it did not contribute to the current observation, 1 = it did contribute)
* These variables are only available **during execution**

```
DATA SAS-data-set;
    MERGE SAS-data-set1 (IN=variable1) 
          SAS-data-set2 (IN=variable2) ...;
    BY <DESCENDING> BY-variable(s);
    IF variable1 = 1 and variable2 = 1;     /* write only matches */
    <additional SAS statements>
RUN;
```

- ***Matches***

```
IF variable1 = 1 and variable2 = 1 
IF variable1 and variable2
```

* ***Non-matches from either data set***

```
IF variable1 = 0 or not variable2 = 0
IF not variable1 or not variable2`
```

***E.g.:***<br>

```
DATA SAS-new-data-set1 SAS-new-data-set2;
	MERGE SAS-data-set1 (in=var1) SAS-data-set2 (in=var2);
	BY BY-variable(s);
	IF var2 THEN OUTPUT SAS-new-data-set1;
	ELSE IF var1 and not var2 THEN OUTPUT SAS-new-data-set2;
	KEEP variable1 variable2 variable5 variable8;
run;
```

## Creating Summary Reports
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m422/m422_5_a_sum.htm)

### Using PROC FREQ to Create Summary Reports

* When you're summarizing data, there's no need to show a frequency distribution for variables that have a large number of distinct values
* Frequency distributions work best with variables whose values meet two criteria: variable with **categorical values** and values are **best summarized by counts instead of averages**
* Variables that have continuous numerical values, such as dollar amounts and dates, will need to be **grouped into categories** by **applying formats** inside the PROC FREQ step (substitute an specific range of those values by a tag)

```
PROC FREQ DATA=SAS-data-set <option(s)>;
    TABLES variable(s) <loption(s)>;
    <additional statements>
RUN;
```

* **PROC FREQ** produces frequency tables that report the distribution of any or all variable values in a SAS data set
* In the **TABLE** statement you specify the frequency tables to produce 
* To create **one-way** frequency tables you specify one or more variable names separated by space
* **WATCH OUT**: if you omit the **TABLE** statement, SAS produces a one-way table for every variable in the data set
* The **PROC FREQ** step automatically displays output in a report, so you don't need to add a PROC PRINT step 
* Each unique variable's value displayed in the 1<sup>st</sup> column of the output is called a **level of the variable**

---

```
PROC FREQ DATA=SAS-data-set <option(s)>;
    TABLES variable/NOCUM NOPERCENT;
    <additional statements>
RUN;
```

* **NOCUM** option supresses the display of  the cummulative frequency and cummulative percent values 
* **NOPERCENT** option supresses the display of all percentages

---

```
PROC SORT DATA=SAS-data-set
    OUT=SAS-data-set-sorted;
    BY variable_sorted;
RUN;

PROC FREQ DATA=SAS-data-set-sorted;
    TABLES variable-freq;
    BY variable_sorted;
RUN;
```

- Whenever you use the **BY** statement, the data set must be sorted by the variable named in the statement
- Using this we will get a frequency table on **`variable_freq`** for each value of **`variable_sorted`**

---

***Crosstabulation tables***

* Sometimes it is useful to view a single table with statistics for each distintic combination of values of the selected variables
* The simplest crosstabulation table is a **two-way table**

```
PROC FREQ DATA=SAS-data-set;
    TABLES variable1 * variable2 / NOFREQ NOPERCENT NOROW NOCOL;
RUN;

variable1 = table rows
variable2 = table columns
```

Information contained in crosstabulation tables (legend):

* **Frequency**: indicates the number of observations with the unique combination of values represented in that cell
* **Percent**: indicates the cell's percentage of the total frequency
* **Row Pct**: cell's percentage of the total frequency for its row
* **Col Pct**: cell's percentage of the total frequency for its column 
<br><br>
* **LIST** option format: the first two columns specify each possible combination of the two variables; it displays the same statistics as the default **one-way frequency** table
* **CROSSLIST** option format: it displays the same statistics as the default **crosstabulation** table

--- 

The **FORMAT=** option allows you to format the frequency value (to any SAS numeric format or a user-defined numeric format while its length is not more than 24) and to change the width of the column (e.g. to allow variable labels to fit in one line). 

```
PROC FREQ DATA=SAS-data-set;
    TABLES variable1 * variable2 /
    FORMAT = <w>.;
    FORMAT variable1 $format-name.;    
RUN;
```

The **FORMAT=** option applies only to crosstabulation tables displayed in the default format. It doesn't apply to crosstabulation tables produced with the **LIST**/**CROSSLIST** option

### Using PROC FREQ for Data Validation

You can use a **PROC FREQ** step with the **TABLES** statement to detect invalud numeric and character data by looking at distinct values. The **FREQ** procedure **lists all discrete values** for a variable and **reports its missing values**.

```
PROC FREQ DATA=SAS-data-set <ORDER=FREQ>;
    TABLES variable;
RUN;
```

* You can check for non-expected variable's values
* You can check for missing values
* You can find duplicated values

---

The table showing the **Number of Variable Levels** can indicate whether a variable contains duplicate/missing/non-expected values:

```
PROC FREQ DATA=SAS-data-set NLEVELS;
    TABLES variable / NOPRINT;
RUN;
```

---

You can use a **WHERE** statement to print out only the invalid values to be checked:

```
PROC PRINT DATA=SAS-data-set;
    WHERE gender NOT IN ('F','M') OR
          job_title IS NULL OR
          salary NOT BETWEEN 24000 AND 500000 OR
          employee IS MISSING;
RUN;
```

---

You can output the tables to a new data set instead of displaying it:

```
PROC FREQ DATA=SAS-data-set NOPRINT;
   TABLE variable / OUT=SAS-new-data-set;
RUN;
```

### Using the MEANS and UNIVARIATE Procedures

**PROC MEANS** produces summary reports with descriptive statistics and you can create statistics for groups of observations

* It automatically displays output in a report and you can also save the output in a SAS data set
* It reports the **number of nonmissing values** of the analysis variable (N), and the **mean**, the **standard deviation** and **minimum/maximum values** of every numeric variable in the data set
* The variables in the **CLASS** statement are called **classification variables** or **class variables** (they typically have few discrete values)
* Each combination of class variable values is called a **class level**
* The data set **doesn't need to be sorted** or indexed by the class variables
* **N Obs** reports the number of observations with each unique combination of class variables, whether or not there are missing values (if these **N Obs** are identical to **N**, there are no missing values in you data set)

```
PROC MEANS DATA=SAS-data-set <statistic(s)>;
    VAR analysis-variable(s);
    CLASS classification-variable(s);
RUN;
```

To write the report in a new data set (including total addition):

```
PROC MEANS DATA=SAS-data-set NOPRINT NWAY;
	OUTPUT OUT=SAS-new-data-set SUM=addition-new-variable;
    VAR analysis-variable(s);
    CLASS classification-variable(s);
RUN;
```

Format options: 

* **MAXDEC=number** (default format = BESTw.) 
* **NONOBS**
* **FW=number**: specifies that the field width for all columns is *number*
* **PRINTALLTYPES**: displays statistics for all requested combination of class variables

![Descriptive statistics](https://lh3.googleusercontent.com/R84N_PMRcXBBgDksyuhN6i--5J_vun1oLe5CRgMIvZdFZNSbSAxMkrKzCo5z7Zn_2aPnoFY=s0 "Descriptive statistics")
![Quantile statistics](https://lh3.googleusercontent.com/aQuAOJzy4JgnaWUPOUwU80TvOp9DeQXr3Iesbw1EVHVJrZKjUw-TC4S27Mhd6Dt8NJ7V7j4=s0 "Quantile statistics")

---

***Alternative procedure to validate data: *** **PROC MEANS**

* The **MIN**/**MAX** values can be useful to check if the data is within a range
* **NMISS** option displays the number of observations with missing values

---

***Alternative procedure to validate data: *** **PROC UNIVARIATE**

**PROC UNIVARIATE** is a procedure that is useful for detecting data outliers that also produces summary reports of **descriptive statistics**

```
PROC UNIVARIATE DATA=SAS-data-set;
    VAR variable(s);
    ID variable_to_relate;
    HISTOGRAM variables </options>;
    PROBPLOT variables </options>;
    INSET keywords </options>;
RUN;
```

* If you omit the **VAR** statement, all numeric variables in the data set are analyzed
* The **Extreme Observations** table contains useful information to locate outliers: it displays the 5 lowest/highest values by default along with the corresponding observation number. The **ID** statement specifies that SAS will use this variable as a label in the table of extreme observations and as an identifier for any extreme.
* To specify the number of listed observations you can use **NEXTROBS=**
* **HISTOGRAM/PROBPLOT** options: normal(mu=est sigma=est) creates a normal curve overlay to the histogram using the estimates of the population mean and standard deviation
* **INSET** writes a legend for the graph. `/ position=ne` moves the **INSET** to the north-east corner of the graph.

To include in the report only one of the automatically produced tables:

1) Check the specific table name in the **LOG information** using **ODS TRACE**:

```
ODS TRACE ON;
PROC UNIVARIATE DATA=SAS-data-set;
    VAR variable(s);
RUN;
ODS TRACE OFF;
```

2) Select the wanted table with **ODS SELECT**:

```
ODS SELECT ExtremeObs;
PROC UNIVARIATE DATA=SAS-data-set;
    VAR variable(s);
RUN;
```

---

***SUMMARY of validation procedures***

![Validation procedures](https://lh3.googleusercontent.com/qa02E3GQU_EU1ZHWX40Ewy-WsXd7hmzfJ5HXBOCDvHrtxRGjrlh6R3hjEupj5Ul9mDreXO8=s0 "Validation procedures")

### Using the SAS Output Delivery System

```
ODS destination FILE="filename" <options>;
    <SAS code to generate the report>
ODS destination CLOSE;
```

* You can have multiple destinations open and execute multiple procedures
* All generated output will be sent to every open destination
* You might not be able to view the file, or the most updated file, outside of SAS until you close the destination

**E.g.:**

```
ODS pdf FILE="C:/output/test.pdf";
(...)
ODS pdf CLOSE;

ODS csvall FILE="C:/output/test.cvs";
ODS rtf FILE="C:/output/test.rtf";
(...)
ODS csvall CLOSE;
ODS rtf CLOSE;
```

***Allowed file formats and their corresponding destinations:***
![SAS Output Delivery System](https://lh3.googleusercontent.com/p3gAmRNbwqP8WfUOSKCLxTA042D3e_F9OUkxYJ0XHspC7MAfzfAnK0ghvpLZQXJWNWdbPd0=s0 "SAS Output Delivery System")
