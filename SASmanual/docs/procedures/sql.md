## Introduction to `PROC SQL`

!!! summary "Check these websites"
    * [SQL syntax available in SAS](http://support.sas.com/documentation/cdl/en/proc/61895/HTML/default/viewer.htm#a000086336.htm)

## Code Examples

### Creating Tables Filtering Specific Data

```
PROC SQL;
   CREATE TABLE table-name AS
   SELECT DISTINCT variable1
   FROM origin-data-set
   WHERE variable2 NE '' AND variable3 IN ('value1' 'value2') ; 
QUIT;
```

### Macrovariable Creation 

In this code a macrovariable is created containing a list of a variable distinct values (`list`). Another macrovariable is also created whose value is the number of elements in the list (`nelements`).

```
* Count distinct elements;
PROC SQL NOPRINT;
	SELECT COUNT(DISTINCT variable2check) 
	INTO : nelements
	FROM original-data-set;
QUIT;

* Load these distinct elements in a macrovariable list;
PROC SQL NOPRINT;
	SELECT DISTINCT variable2check. 
	INTO : list SEPARATED BY '$' 
	FROM original-data-set;
QUIT;
```

**Is there any way to do these two operations in just one `PROC SQL`?** Two different `INTO:` are not compatible.

* General `PROC SQL` options:
    * The `NOPRINT` option avoids any output printing
* `SELECT` statement elements:
    * The `COUNT(*)` option counts the number of elements of the table designated in the `FROM` statement
    * The `DISTINCT` option selects only different variable values
    * `INTO: name` creates a `name` macrovariable containing the result of that specific query
    * `SEPARATED BY ' '` defines a the separator between elements
   
### Selecting Distinct Values of a Variable to Create a Data Set with them

```
PROC SQL NOPRINT;
	CREATE TABLE new-SAS-data-set AS SELECT DISTINCT analyzed-variable
	FROM original-SAS-data-set;
QUIT;
```

### Cartesian Product of Data Sets (All Possible Combinations)

```
PROC SQL;
	CREATE TABLE new-SAS-data-set AS SELECT variable1, variable2, variablE3 FROM original-SAS-data-set1 AS f1 CROSS JOIN original-SAS-data-set2 AS f2 CROSS JOIN original-SAS-data-set3 AS f3;
QUIT;
```

### Selecting the Maximum Value

If you need only the maximum value of a certain variable for equal registers except this value, you will use the `MAX()` function. If you want to keep in the selection any other variable that you do not need to group you will need to apply the `MAX()` function to it as well.

```
PROC SQL;
	CREATE TABLE new-SAS-data-set AS
	SELECT grouped-variable1, grouped-variable2, MAX(ungrouped-variable) AS alias-ungrouped, MAX(maximized-variable) AS alias-maximized
	FROM original-SAS-data-set
	GROUP BY grouped-variable1, grouped-variable2;
QUIT;
```

### Counting Grouped Elements

A simple example first.
```
PROC SQL NOPRINT;
	SELECT COUNTt(*)
	INTO :nlabs
	FROM SAS-data-set;
QUIT;
```

In this first `PROC SQL` a number of count variables are created:
```
PROC SQL;
	CREATE TABLE AESWPP AS
		SELECT COHORT, AEBODSY, AEDECOD, PT, MAX(AETOXGRN) AS GRADE, COUNT(*) AS NEVENTS, 
			NTOTPATSCOHORT.NPATS AS NTOTPATSCOHORT, 
         100/NTOTPATSCOHORT.NPATS AS PCTPATC,
			NTOTEVENTSCOHORT.NEVENTS AS NTOTEVENTSCOHORT, 
         100/NTOTEVENTSCOHORT.NEVENTS AS PCTEVENTSC,
			NTOTPATS.NPATS AS NTOTPATS, 
         100/NTOTPATS.NPATS AS PCTPATTOT,
			NTOTEVENTS.NEVENTS AS NTOTEVENTS, 
         100/NTOTEVENTS.NEVENTS AS PCTOTEVENTS
		FROM ADS.TEAE AS TEAE, 
			(SELECT COUNT(DISTINCT PT) AS NPATS, COHORT AS COHORTP FROM ADS.TEAE GROUP BY COHORT) NTOTPATSCOHORT,
			(SELECT COUNT(*) AS NEVENTS, COHORT AS COHORTE FROM ADS.TEAE GROUP BY COHORT) NTOTEVENTSCOHORT,
			(SELECT COUNT(DISTINCT PT) AS NPATS FROM ADS.TEAE) NTOTPATS,
			(SELECT COUNT(*) AS NEVENTS FROM ADS.TEAE) NTOTEVENTS
				WHERE NTOTPATSCOHORT.COHORTP EQ TEAE.COHORT
					AND NTOTEVENTSCOHORT.COHORTE EQ TEAE.COHORT
				GROUP BY COHORT, AEBODSY, AEDECOD, PT;
QUIT;
```

In this second `PROC SQL` the number of certain ocurrences are counted.
```
PROC SQL;
	CREATE TABLE AESWPP_1
		AS SELECT * ,
			CASE 
				WHEN GRADE EQ 1 THEN COUNT(1) 
				ELSE 0 
			END 
		AS GRADE1,
			CASE 
				WHEN GRADE EQ 2 THEN COUNT(1) 
				ELSE 0 
			END 
		AS GRADE2,
			CASE 
				WHEN GRADE EQ 3 THEN COUNT(1) 
				ELSE 0 
			END 
		AS GRADE3,
			CASE 
				WHEN GRADE EQ 4 THEN COUNT(1) 
				ELSE 0 
			END 
		AS GRADE4,
			CASE 
				WHEN GRADE EQ 5 THEN COUNT(1) 
				ELSE 0 
			END 
		AS GRADE5
			FROM AESWPP
				GROUP BY COHORT, AEBODSY, AEDECOD, GRADE
					ORDER BY COHORT, AEBODSY, AEDECOD;
QUIT;
```

### Selecting First and Last Dates Related to a Patient

```
proc sql;
	create table firstlastdates as 
		select min(STARTDATE) as date1, max(ENDDATE) as date2, pt, visit
			from origin-SAS-data-set 
			group by pt, visit;
quit; 

```
