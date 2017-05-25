[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m415/m415_4_a_sum.htm)

## Subsetting Report Data

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

Special `WHERE` operators:

* `BETWEEN x AND y`: an inclusive range
* `WHERE SAME AND`: augment a previous where expression (both applied)
* `IS NULL`: a missing value
* `IS MISSING`: a missing value
* `LIKE`: matches a pattern (% = any number of characters, _ = one character). E.g.: `'T_m%'`
* The `SOUNDS-LIKE (=\*)` operator selects observations that contain a spelling variation of a specified word or words. This operator uses the *Soundex* algorithm to compare the variable value and the operand.
* [`ANYVALUE`](http://support.sas.com/documentation/cdl/en/lrdict/64316/HTML/default/viewer.htm#a002194060.htm) is an interesting function that searches a character string for an alphabetic character, and returns the first position at which the character is found


!!! note
    To compare with a SAS date value you need to express is as a SAS date constant: `'DDMM<\YY>YY'D`.

## Sorting and Grouping Report Data

```
PROC SORT DATA=SAS-data-set
    OUT=new-SAS-data-set NODUPKEY;                                           /* optional */
    DUPOUT=work.duplicates;                                                  /* optional */
    BY ASCENDING variable1-to-be-sorted DESCENDING variable2-to-be-sorted;   /* optional (ASCENDING is the default order)*/
RUN;
```

* The `NODUPKEY` option deletes observations with duplicate `BY` values
* `DUPOUT` writes duplicate observations to a separate output data set

## Enhancing Reports

### Titles and footnotes

```
TITLEline 'text';       
FOOTNOTEline 'text';

TITLE1 'text1';
TITLE1 'text1_change';     /* Change title text and also cancels all footnotes with higher numbers */
TITLE;                     /* Cancel (erase) all titles */
```

* The **lines** specifies the line (1-10) on which the title/footnote will appear (line = 1 is the default value)
* The title/footnote will remain until you **change** it, **cancel** it or you **end your SAS session**

#### Titles and footnotes inside AND outside a graph

***COMPLETE***

### Labels

Assigning **temporary labels** to display in the report instead of the variable names:

```
PROC PRINT DATA=SAS-data-set LABEL;            
    LABEL variable1 = 'new variable1 name' 
          variable2 = 'new variable2 name';
    LABEL variable3 = 'new variable3 name';
RUN;
```

* You need to add the `LABEL` option at the `PROC PRINT` definition to display the labels 
* The `LABEL` lengths can go up to 256 characters long
* You can specify several labels in one `LABEL` statement or use a separate `LABEL` statement for each variable

#### The `SPLIT` option

```
PROC PRINT DATA=SAS-data-set SPLIT='*';             
    LABEL variable1 = 'variable label line 1*variable label line 1';   
RUN;
```

* When you use `SPLIT` you no longer need to add the `LABEL` option to get the labels printed out
* The `SPLIT` option introduces a line break at the label text whenever it finds the specified character (`*`)