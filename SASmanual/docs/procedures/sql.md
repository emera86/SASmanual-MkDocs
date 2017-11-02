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
PROC SQL NOPRINT;
	SELECT COUNT(*) 
	INTO : nelements
	FROM 
  	(SELECT DISTINCT variable2check INTO : list SEPARATED BY '$' FROM original-data-set);
QUIT;
```

* General `PROC SQL` options:
    * The `NOPRINT` option avoids any output printing
* `SELECT` statement elements:
    * The `COUNT(*)` option counts the number of elements of the table designated in the `FROM` statement
    * The `DISTINCT` option selects only different variable values
    * `INTO: name` creates a `name` macrovariable containing the result of that specific query
    * `SEPARATED BY ' '` defines a the separator between elements
    
### Counting grouped elements

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
