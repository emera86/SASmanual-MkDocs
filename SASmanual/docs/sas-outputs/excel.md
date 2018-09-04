## Export Data to Excel With Format

```
%macro ExportExcelWithFormat(libname=,dataname=,select=, outputname=,sheetname= );

	proc sql noprint;
		create table tmp_vars as
			select name,format, label from dictionary.columns
				where libname=upcase("&libname.") and memname=upcase("&dataname.");
	quit;

	data tmp_vars;
		set tmp_vars end=last;
		length formatcode $400.;
		if format ^="" then
			formatcode=catx(" ",cats("put","(",name,",",format,")"), "as",name," label","'" ,label,"'",",");
		else formatcode=cats(name,",");
		if last then
			formatcode=substr(formatcode,1,length(formatcode)-1);
	run;

	%let formatcodes=;

	data _null_;
		set tmp_vars;
		call symput('formatcodes', trim(resolve('&formatcodes.')||' '||trim
			(formatcode)));
	run;

	%put &formatcodes.;

	proc sql;
		create view tmp_view as
			select &formatcodes.
				from &libname..&dataname.;
	quit;

	data _datain;
		retain &select;
		set tmp_view (keep=&select);
	run;

	%let formatcodes=%str();

	PROC EXPORT DATA= _datain DBMS=xlsx REPLACE label 
		OUTFILE= "&outputname.";
		SHEET="&sheetname.";
	RUN;

	proc sql;
		drop table tmp_vars, _datain;
		drop view tmp_view;
	quit;

%mend;

%exportExcelWithFormat(libname=SAS-libname,
                      dataname=SAS-data-set,
                      select=variable1 variable2 variable3,
                      outputname=%str(&path\exceldata\File name (&sysdate).xlsx),
                      sheetname=Sheet name);
```
