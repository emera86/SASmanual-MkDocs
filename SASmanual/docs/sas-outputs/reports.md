## ODS 

In order to produce outputs from SAS, the three more common `ODS` techniques, that produces different output files, are HTML, RTF, and PDF. Each `ODS` statement uses options that are specific to that destination. The `ODS` options (other than the `FILE=` option) used in the program are shown in the table below. 

|                   **RTF**             |                  **PDF**                   |     **HTML**        |
|:---------------------------------------:|:--------------------------------------------:|:--------------------:|
| BODYTITLE <\br> STARTPAGE=NO <\br> KEEPN <\br> NOTOC_DATA | BOOKMARKGEN=NO STARTPAGE=NO COMPRESS=9 TEXT= | STYLE=SASWEB RS=NONE |

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
