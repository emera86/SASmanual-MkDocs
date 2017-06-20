[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m419/m419_5_a_sum.htm)

## Introduction to Reading Raw Data Files

* **Raw data files** are not software specific
* A **delimited raw data file** is an external text file in which the values are separated by spaces or other special characters.
* A **list input** will be used to work with delimited raw data files that contain standard and/or nonstandard data
* **Standard data** is data that SAS can read without any special instructions
* **Nonstandard data** includes values like dates or numeric values that include special characters like dollar signs (extra instructions needed)
* You cannot use a `WHERE` statement when the input data is a raw data file instead of a SAS data set

## Reading Standard Delimited Data

```
DATA output-SAS-data-set-name;
	LENGTH variable(s) <$> length;
	INFILE 'raw-data-file-name' DLM='delimiter';  
	INPUT variable1 <$> variable2 <$> ... variableN <$>;       
RUN;

/* Example */

DATA work.sales1;
	LENGTH First_Name Last_Name $ 12 Gender $ 1;
	INFILE '&path/sales.csv' DLM=',';  
	INPUT Employee_ID Gender $ Salary $ Job_Title $ Country $; 
RUN;
```

- With **list input**, the default length for all variables is 8 bytes
- SAS uses an **input buffer** only if the input data is a raw data file
- The variable names will appear in the report as stated in the **LENGTH** statement (watch out the uppercase/lowercase)
- The `LENGTH` statement must precede the `INPUT` statement in order to correctly set the length of the variable
- The variables not specified in the `LENGTH` statement will appear at the end of the table. If you want to keep the original order you should include all variables even if you want them to have the defaul length (8)

## Reading Nonstandard Delimited Data

You can use a **modified list input** to read all of the fields from a raw data file (including nonstandard variables)

- Informats are similar to formats except that **formats** provide instruction on how to **write** a value while **informats** provide instruction on how to **read** a value
- The **colon format modifier (:)** causes SAS to read up to the delimiter

```
INPUT variable <$> variable <:informat>;

/* Example */

:date.
:mmddyy.
```

* `COMMA./DOLLAR.`: reads nonstandard numeric data and removes embedded commas, blanks, dollar sign, percent signs and dashes
* `COMMAX./DOLLARX.`: reads nonstandard numeric data and removes embedded non-numeric characters; reverses the roles of the decima point and the comma
* `EUROX.`: reads nonstandard numeric data and removes embedded non-numeric characters in European currency
* `$CHAR.`: reads character values and preserves leading blanks
* `$UPCASE.`: reads character values and converts them to uppercase

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

* The null statement (`;`) indicates the end of the input data
* You precede the instream data with the `DATALINES` statement and follow it with a null statement
* The instream data should be the last part of the `DATA step` except for a null statement

```
/* Example */

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

title 'Orion Star Management Team';
proc print data=work.managers noobs;
   format HireDate mmddyy10.;
run;
title;
```

## Validating Data

When SAS encounters a data error, it prints messages and a ruler in the log and assigns a missing value to the affected variable. Then SAS continues processing.

### Missing Values between Delimiters (Consecutive Delimiters)

```
INFILE 'raw-data-file-name' <DLM=> DSD;
```

The `DSD` option sets the default delimiter to a comma, treats consecutive delimiters as missing values and enables SAS to read values with embedded delimiters if the value is surrounded by quotation marks

### Missing Values at the End of a Line

```
INFILE 'raw-data-file-name' MISSOVER;
```

With the `MISSOVER` option, if SAS reaches the end of a record without finding values for all fields, variables without values are set to missing.
