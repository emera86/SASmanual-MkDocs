When you name a process flow Autoexec, SAS Enterprise Guide prompts you to run the process flow when you open the project. This makes it easy to recreate your data when you start practising in the course.

For the SAS Enterprise Guide you need to add this command to get the plots displayed in the output:

```
ODS GRAPHICS ON;
[your code here]
ODS GRAPHICS OFF;
```

When you add the **ODS TRACE** statement, SAS writes a trace record to the log that includes information about each output object (name, label, template, path):

``` 
ODS TRACE ON;
[your code here]
ODS TRACE OFF;
```

You produce a list of the possible output elements in the log that you may specify in the **ODS SELECT/EXCLUDE** statement:

```
ODS SELECT lmeans diff meanplot diffplot controlplot;
[your code here]
```

This way you can see the actual variable level values in the output rather than some indexes:

```
FORMAT variable DOSEF.;
```

* Create different data sets from one:

```
DATA data1 data2 data3;
	SET original_data;
	IF (condition1) THEN OUTPUT prueba1;
	IF (condition2) THEN OUTPUT prueba2;
	IF (condition3) THEN OUTPUT prueba3;
RUN;
```

* Copy database **test** into **work**:

```
proc copy in=test out=work;
run;
```

* Remove data sets:

```
PROC DELETE DATA=data1 data2 data3;
RUN;
```

* Declaring **arrays**:

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

* IF THEN analogue to "CONTAINS":

```
if find(variable_name,'pattern') then
```

* Site calculation from the two first numbers of the patient number:

```
site = SUBSTR(PUT(patient,z4.),1,2);
```

* **PUT**: turns the numeric variable *patient* into a string (**z4.** adds leading zeroes if needed)
* **SUBSTR**: takes the first **2** characters starting from position **1**

* [Count the distinct values of a variable](http://support.sas.com/kb/36/898.html)

* Remove element/string from macro variable 

```
%put &=list;     /* Check list contents before */

%let removefromlist = string_to_remove;
%let list = %sysfunc(tranwrd(&list., &removefromlist., %str()));;

%put &=list;     /* Check list contents after */
```

* How to uppercase the first letter of words:

```
var_propercase = PROPCASE(var_uppercase);
```

* [How to replace the variable's name with the variable's label in PROC FREQ output](http://support.sas.com/kb/23/350.html)

```
options validvarname=any;
PROC FREQ DATA=SAS-data-set (RENAME=(variable1="Label variable 1"n variable1="Label variable 1"n));
	TABLES "Label variable 1"n;
RUN;
```

* [PROC TEMPLATE style tips](https://support.sas.com/rnd/base/ods/scratch/styles-tips.pdf)
* [WHERE variable IS MISSING](http://www.sascommunity.org/wiki/Tips:Use_IS_MISSING_and_IS_NULL_with_Numeric_or_Character_Variables)