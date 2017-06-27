```
/* Load library containing patients data set*/

%let path=C:\your-custom-path;
libname data "&path.\path-to-library";

/* Load demographics data set:
		- keep only patient ID variable
		- build a new counter variable  */

data work.patientslist;
	set data.demographics;
	counter = _n_;
	keep pt counter;
run;

/* Extract total number of patients from the table */

%macro get_table_size(inset,macvar);
	data _null_;
	set &inset NOBS=size;
	call symput("&macvar",size);
	stop;
	run;
%mend;

%let npatients=;
%get_table_size(work.patientslist,npatients);
%put &=npatients;

/* Transform into a numeric value */

%let totalpatients = %SYSEVALF(&npatients.);
%put &=totalpatients;

/* Calculate number of cases needed for random selection */

%let neededpatients = %SYSFUNC(sqrt(&totalpatients.));    /* sqrt(# patients) */
%let neededpatients = %SYSEVALF(&neededpatients. + 1);    /* +1 */
%let neededpatients = %SYSFUNC(ceil(&neededpatients.));   /* round up */
%put &=neededpatients;

/* Generate the list of random counter index numbers */

proc plan seed=12345;
   factors selected = &neededpatients. of &totalpatients. random;
   output out=work.list;
run;

/* Put all selected random numbers into a macro variable named ParamList */

proc sql noprint;                              
 select selected into :ParamList separated by ' '
 from work.list;
quit;
%put ParamList = &ParamList;   /* display list in SAS log to check it */

/* Select the patients from the list that correspond to those indexes */

data work.selectedpatients;
	set work.patientslist;
	where counter in (&ParamList.);
run;

/* Order selected patient list */

proc sort data=selectedpatients;
	by pt;
run;

/* Print out the list of selected patients and print out to a word doc */

ods rtf bodytitle path="&path." file="random_list.doc";

proc print data=work.selectedpatients;
	var pt;
run;

ods rtf close;
```
