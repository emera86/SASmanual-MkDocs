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

## Separate Site ID from Patient Number

* Site calculation from the two first numbers of the patient number:

```
site = SUBSTR(PUT(patient,z4.),1,2);
```

!!! note
    1. `PUT`: turns the numeric variable *patient* into a string (`z4.` adds leading zeroes if needed)
    2. `SUBSTR`: takes the first **2** characters starting from position **1**

## Measure your code execution time

```
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

[YOUR CODE HERE]

%put END TIME: %sysfunc(datetime(),datetime14.);
%put TOTAL TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss) ;
```
