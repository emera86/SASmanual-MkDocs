## Examples

### How to Write a Header/Footer in your Tables

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

### Specify the `STYLE` of a Cell Based on Other Cell's Value

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

!!! tip
    Remember, `PROC REPORT` builds each row from left to right, so the value used as a condition to define the style must be to the left of the values whose style/format you want to change. 
    
```
data test;
	input flag pt $ firstdate $ lastdate $ ;
	datalines;
0 X1 XX-XX-XXXX XX-XX-XXXX
1 X2 XX-XX-XXXX XX-XX-XXXX
0 X3 XX-XX-XXXX XX-XX-XXXX
0 X4 XX-XX-XXXX XX-XX-XXXX
0 X5 XX-XX-XXXX XX-XX-XXXX
2 X6 XX-XX-XXXX XX-XX-XXXX
;
run;

proc report data=test nowindows headline style(header)={background=very light grey} missing split='*';
	column ("First and Last Dates in the Study" ('Patient' pt) ('First Study Date' firstdate) ('Last Study Date' lastdate) flag color1 color2);
	define pt / '' display order=internal;
	define firstdate / '' display;
	define lastdate / '' display;
	define flag / display noprint;
	define color1 / computed noprint;
	define color2 / computed noprint;

    compute color1;
        if flag eq 1 then call define('firstdate',"style","style={background=yellow}");
    endcomp;

	compute color2;
        if flag eq 2 then call define('lastdate',"style","style={background=yellow}");
    endcomp;
run;
```
![Example of cell's style based on value](proc-report-style-cell.png)

### Specify the `STYLE` of Your Global Header

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
    
### Working with `ACROSS`

* Simple example:

```
PROC REPORT DATA=_AUX3 NOWINDOWS  
	HEADLINE STYLE(HEADER)={BACKGROUND=VERY LIGHT GREY} MISSING SPLIT='*';
	COLUMN("&&VAR&I (&&UNIT&I)" &TIMEVAR. ('STATISTICS' _LABEL_) &STRATAVAR., COL1);
	DEFINE _LABEL_ / '' GROUP ORDER=DATA;
	DEFINE &STRATAVAR./ '' ACROSS NOZERO ORDER=INTERNAL;
	/* NOZERO = SINCE ALL PRODUCT CATEGORIES WILL NOT BE REPRESENTED FOR EACH PRODUCT LINE IN THE TABLE */
	DEFINE &TIMEVAR./ '' F=&TIMEFMT. GROUP ORDER=INTERNAL; 
	DEFINE COL1/ '' GROUP;
RUN;
```

* Complex example:

```
proc report data=_data2report nowindows headline style(header)={background=very light grey} missing split='*';
	column("Lab tests (Hematology): normal, high abnormal and low abnormal results n(%)" lbtest trtgrpnum ('Value at * screening' clinsigSCR) ('Day 6' clinsig60, npctn60 _dummy) ('Early Termination Day' clinsigET, npctnET _dummy));
	define lbtest / '' group order=internal;
	define trtgrpnum/ '' group order=internal;
	define clinsigSCR / '' group order=internal;
	define clinsig60 / '' across nozero order=internal;
	define clinsigET / '' across nozero order=internal;
	* nozdero = since all product categories will not be represented for each product line in the table;
	define npctn60/ group '';
	define npctnET/ group '';
	define _dummy / computed noprint; /* This variable is created to avoid an error message */

	compute after/style=[just=L foreground=black FONT_SIZE=9pt];
		line "Table footer line 1";
		line "Table footer line 2";
	endcomp;

	* Introduce some line separations between arms of treatment;
	break after trtgrpnum / skip;
	* Introduce some line separations between tests;
	break before lbtest / summarize style=[background=very light grey FONT_WEIGHT=BOLD];
	* Avoid repeated labels;
	compute npctn60;
		if missing(_break_) then lbtest=' ';
	endcomp;
run;
```

!!! summary "Check these websites"
    * [Sailing Over the `ACROSS` Hurdle in `PROC REPORT`](https://www.sas.com/content/dam/SAS/support/en/technical-papers/SAS388-2014.pdf)
    
### Introducing Line Breaks

```
PROC REPORT DATA=DATA2REPORT3 NOWINDOWS HEADLINE STYLE(HEADER)={BACKGROUND=VERY LIGHT GREY} MISSING SPLIT='*';
	COLUMN("&TITLE." &TIMEVAR. ('SHIFT' SHIFT) &STRATAVAR., NVAL);
	DEFINE &STRATAVAR./ '' ACROSS NOZERO ORDER=DATA;
	DEFINE &TIMEVAR./ F=&TIMEVARFMT. '' GROUP ORDER=INTERNAL; 
	DEFINE SHIFT/ F=SHIFTFMT. '' GROUP ORDER=INTERNAL;
	DEFINE NVAL/ '' GROUP;
	* INTRODUCE SOME LINE SEPARATIONS BETWEEN VISITS;
	BREAK BEFORE &TIMEVAR. / SUMMARIZE STYLE=[BACKGROUND=VERY LIGHT GREY];
	* MAKE THE GLOBAL SHIFT TO BE IN BOLD;
	COMPUTE &TIMEVAR.;
		IF &TIMEVAR. EQ '99999' AND _BREAK_ EQ "&TIMEVAR." THEN DO;
			CALL DEFINE (_ROW_,'STYLE', 'STYLE=[FONT_WEIGHT=BOLD]');
		END;
	ENDCOMP;
	* AVOID REPEATED LABELS;
	COMPUTE NVAL;
 		IF MISSING(_BREAK_) THEN &TIMEVAR.=' ';
	ENDCOMP;
RUN;
```

### Defining your own variables

```
DEFINE obs / COMPUTED; 

COMPUTE obs;
	dsobs + 1;
	obs = dsobs;
ENDCOMPUTE;
```
