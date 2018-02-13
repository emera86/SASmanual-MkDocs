## Declaring arrays

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

## Assigning Initial Values to Array Variables or Elements

The following `ARRAY` statements illustrate the initialization of numeric and character values:

```
ARRAY sizes[*] petite small medium large extra_large (2, 4, 6, 8, 10);
ARRAY cities[4] $10 ('New York' 'Los Angeles' 'Dallas' 'Chicago');
```

You can also initialize the elements of an array with the same value using an iteration factor, as shown in the following
example that initializes 10 elements with a value of 0:

```
ARRAY values[10] 10*0;
```

When elements are initialized within an `ARRAY` statement, the values are automatically retained from one iteration of the
`DATA` step to another; a `RETAIN` statement is not necessary. 

## Date Arrays 

You can only assign lengths, not formats in an array definition. Use a separate format statement to specify the date format.

```
DATA new-SAS-data-set;
	SET existing-SAS-data-set;
	ARRAY arrayname[8] element1-element8;
	FORMAT element1-element8 ddmmyy10.;
RUN;
```
