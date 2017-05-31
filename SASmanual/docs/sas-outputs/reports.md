## PROC PRINT

## PROC TABULATE

## PROC REPORT

* How to write a header in your tables:

```
PROC REPORT DATA=sashelp.cars;
	WHERE Make = 'Jaguar';
	COLUMN ('1) Label 1' model Invoice)
			('2) Label 2' Horsepower Weight Length);
	COMPUTE BEFORE _PAGE_ / STYLE=HEADER{JUST=L FONTWEIGHT=BOLD COLOR=PURPLE};
		LINE 'Test of custom header';
	ENDCOMP;
RUN;
```
