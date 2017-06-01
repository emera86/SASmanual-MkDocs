## Dealing with arrays

### Declaring arrays

The dimension has to be known in advance (???)
There's no way to write an implicit loop through all the elements of the array (???)

```
data _null_;

	ARRAY arrayname[2,3] <$> v11-3 (0 0 0)
	                     <$> v21-3 (0 0 0);
                             
	DO i=1 TO DIM(arrayname);
		arrayname[i] = arrayname[i] + 1;
	END;

	result=CATX(',',OF v11-3);
	PUT result=;

RUN;
```

* [WHERE variable IS MISSING](http://www.sascommunity.org/wiki/Tips:Use_IS_MISSING_and_IS_NULL_with_Numeric_or_Character_Variables)

* Site calculation from the two first numbers of the patient number:

```
site = SUBSTR(PUT(patient,z4.),1,2);
```

!!! note
    1. `PUT`: turns the numeric variable *patient* into a string (`z4.` adds leading zeroes if needed)
    2. `SUBSTR`: takes the first **2** characters starting from position **1**

* [Count the distinct values of a variable](http://support.sas.com/kb/36/898.html)
* Remove element/string from macro variable 

```
%put &=list;     /* Check list contents before */

%let removefromlist = string_to_remove;
%let list = %sysfunc(tranwrd(&list., &removefromlist., %str()));;

%put &=list;     /* Check list contents after */
```

* [How to replace the variable's name with the variable's label in PROC FREQ output](http://support.sas.com/kb/23/350.html)

```
options validvarname=any;
PROC FREQ DATA=SAS-data-set (RENAME=(variable1="Label variable 1"n variable1="Label variable 1"n));
	TABLES "Label variable 1"n;
RUN;
```

### Measure your code execution time

```
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

[YOUR CODE HERE]

%put END TIME: %sysfunc(datetime(),datetime14.);
%put TOTAL TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss) ;
```
