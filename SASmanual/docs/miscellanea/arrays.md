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
