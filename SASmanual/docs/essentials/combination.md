[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m421/m421_5_a_sum.htm)

## Concatenating Data Sets

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
- The **variable attributes** are assigned from the **first data set** in the `SET` statement
- You will get an **error** in the `DATA` step if a variable is defined with **different data types** in the files that you are trying to concatenate

## Merging SAS Data Sets One-to-One

***Combine files horizontally by merging***

- The **match-merging** is a process based on the values of common variables
- Data sets are merged in the order that they appear in the MERGE statement
- You may need to `SORT` the files by the `BY-variable(s)` before merging the files

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

## Merging SAS Data Sets One-to-Many

```
DATA SAS-data-set;
    MERGE SAS-data-set1 SAS-data-set2 ...;
    BY <DESCENDING> BY-variable(s);
    <additional SAS statements>
RUN;
```

*In a **one-to-many merge**, does it matter which data set is listed first in the `MERGE` statement?*

When you reverse the order of the data sets in the `MERGE` statement, the results are the same, but the order of the variables is different. SAS performs a **many-to-one merge**.

---

`MERGENOBY` (`= NOWARN (default) | WARN | ERROR`) controls whether a message is issued when `MERGE` processing occurs without an associated `BY` statement

* Performing a merge without a BY statement merges the observations based on their positions
* This is almost never done intentionally and can lead to unexpected results

## Merging SAS Data Sets that Have Non-Matches

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

* When you spefify the `IN` option after an input data set in the `MERGE` statement, SAS creates a **temporary numeric variable** that indicates whether the data set contributed data to the current observation (0 = it did not contribute to the current observation, 1 = it did contribute)
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

* ***Matches***

```
IF variable1 = 1 and variable2 = 1 
IF variable1 and variable2
```

* ***Non-matches from either data set***

```
IF variable1 = 0 or not variable2 = 0
IF not variable1 or not variable2
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

## Merging SAS Data Sets Many-to-Many

With the macros [`makewide.sas` and `makelong.sas`](http://www.sascommunity.org/wiki/Transpose_data_with_macro_%25MAKEWIDE_and_%25MAKELONG_(based_on_Proc_TRANSPOSE)) you can 

1. Make one of your data sets wide
2. Perform a one-to-many merge with the other data set
3. Make your resultant data set long to obtain the required result
