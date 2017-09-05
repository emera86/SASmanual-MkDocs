## ODS 

In order to produce outputs from SAS, the three more common `ODS` techniques, that produces different output files, are HTML, RTF, and PDF. Each `ODS` statement uses options that are specific to that destination. The `ODS` options (other than the `FILE=` option) used in the program are shown in the table below. 

|                   **RTF**             |                  **PDF**                   |     **HTML**        |
|:---------------------------------------:|:--------------------------------------------:|:--------------------:|
| `BODYTITLE` <br> `STARTPAGE=NO` <br> `KEEPN` <br> `NOTOC_DATA` / `TOC_DATA` <br> `CONTENTS` <br> `COLUMNS=` <br> `TEXT=` | `BOOKMARKGEN=NO` <br> `STARTPAGE=NO` <br> `COMPRESS=9` <br> `TEXT=` | `STYLE=SASWEB` <br> `RS=NONE` |

For an explanation of the options, refer to [this page](http://www2.sas.com/proceedings/forum2007/021-2007.pdf) or to the [`ODS` User's Guide](https://support.sas.com/documentation/cdl/en/odsug/69832/HTML/default/viewer.htm#titlepage.htm).

**Set the SAS system options.** The `NODATE` option suppresses the display of the date and time in the output. `PAGENO=` specifies the starting page number. `LINESIZE=` specifies the output line length, and `PAGESIZE=` specifies the number of lines on an output page.

```
OPTIONS NODATE PAGENO=1 LINESIZE=80 PAGESIZE=40;
```

## PROC PRINT

## PROC TABULATE

```
PROC TABULATE DATA=SAS-data-set ORDER=FREQ;
	VAR var1 var2;
	CLASS AEencoding;
	CLASS grade / ORDER=FORMATTED;
	CLASS treatment / ORDER=FORMATTED;
	TABLE AEencoding='', treatment='Treatment/Grade'*grade=''*(N='N' var1='%'*SUM='') ALL='Total (N=# cases)'*(N='N' var2='%'*SUM='') / BOX="Preferred MeDDRA Term";
RUN;
```

## PROC REPORT

How to write a header/footer in your tables:

```
ODS ESCAPECHAR='^';

PROC REPORT DATA=sashelp.cars;
	WHERE Make = 'Jaguar';
	COLUMN ('1) Label 1' model Invoice)
			('2) Label 2' Horsepower Weight Length);
	COMPUTE BEFORE _PAGE_ / STYLE=HEADER{JUST=L FONTWEIGHT=BOLD COLOR=PURPLE};
		LINE 'Test of custom header';
	ENDCOMP;
	COMPUTE AFTER / STYLE={TEXTDECORATION=UNDERLINE JUST=C COLOR=RED};
		LINE 'Test of a custom footer';
		LINE '^S={color=green} Test of a custom footer with a different style';
	ENDCOMP;
RUN;
```

Specify the `STYLE` of a cell based on other cell's value:

```
PROC REPORT DATA=SAS-data-set NOWD;
	COLUMN timeinterval date1 date2;
	DEFINE timeinterval / DISPLAY NOPRINT; 
	DEFINE date1 / DISPLAY;
	DEFINE date2 / DISPLAY;
	COMPUTE date2;
		IF timeinterval lt 0 and timeinterval ne . then call define(_col_,"style","style={foreground=red font_weight=bold}");
		ELSE call define(_col_,"style","style={foreground=green font_weight=bold}");
	ENDCOMP;
RUN;
```

* `DEFINE` the variables involved in your conditional structure before the variable to which you want to apply the new format 
* `DEFINE` your variables as `DISPLAY NOPRINT` if you want to use them for the conditional structure but you don't want them to appear in your table

Specify the `STYLE` of your global header:

```
PROC REPORT DATA=SAS-data-set HEADSKIP HEADLINE NOWINDOWS STYLE(header)={ASIS=on BACKGROUND=very light grey FONTWEIGHT=BOLD};
	COLUMN ("Style of this global header" var1 var2);
	DEFINE var1 / DISPLAY 'Parameters' LEFT STYLE=[FONTWEIGHT=BOLD];
	DEFINE var2 / DISPLAY 'Values' CENTER;
RUN;
```

!!! summary "Check these websites"
    * [Beyond the Basics: Advanced `PROC REPORT` Tips and Tricks](http://support.sas.com/rnd/papers/sgf07/sgf2007-report.pdf)
    * [Creating a Plan for Your Reports and Avoiding Common Pitfalls in `REPORT` Procedure Coding](http://support.sas.com/resources/papers/proceedings13/366-2013.pdf)
    * [Turn Your Plain Report into a Painted Report Using ODS Styles](http://support.sas.com/resources/papers/proceedings10/133-2010.pdf)
