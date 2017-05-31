!!! check
	  * [Here](http://support.sas.com/documentation/cdl/en/grstatug/63302/HTML/default/viewer.htm#n0kqozn49yx2lon1aavkll1f5dff.htm) you can find some notes on **Graph Template Language** (categories of statements)
	  * [Bob Rodríguez](https://www.linkedin.com/in/bob-rodriguez-7b12634/) is has written a lot about templates, check his papers for more information
	  * [Here](https://support.sas.com/documentation/cdl/en/statug/63962/HTML/default/viewer.htm#templt_toc.htm) you can find the official documentation on ODS Graphics Template Modification
	  * [PROC TEMPLATE style tips](https://support.sas.com/rnd/base/ods/scratch/styles-tips.pdf)

## Basic Template Information

### Obtain the Default Template for an Object

First you need to know the name of the template. For this you can either look for its name listing all the available default templates that are kept in `sashelp.tmplmst`...

```
PROC TEMPLATE;
  PATH sashelp.tmplmst;
  LIST base.freq / SORT=path DESCENDING;
RUN; 
```

... or use the `ODS TRACE ON` to obtain the name of an specific template.

```
ODS TRACE ON;
ODS GRAPHICS ON;
PROC FREQ DATA=sashelp.baseball;
	TABLE League*Division / AGREE NOCOL NOROW; 
	TEST KAPPA;
RUN;
ODS GRAPHICS OFF;
ODS TRACE OFF;
```

You will obtain the following log output for the `Agreement Plot` where you can obtain the name of the template you are interested in:

```
Output Added:
-------------
Name:       AgreePlot
Label:      Agreement Plot
Template:   Base.Freq.Graphics.AgreePlot
Path:       Freq.Table1.AgreePlot
-------------
```

Then you use the `SOURCE` option from the `TEMPLATE` procedure to show in the log the full object template.

```
%let path=C:\your-path-here;
PROC TEMPLATE;
	SOURCE Base.Freq.Graphics.AgreePlot / file="&path.\agreeplot.sas";
RUN;
```

### Revert Template Changes

The following statements delete the modified template from `SASUSER.TEMPLAT` and revert to the default template in
`SASHELP.TMPLMST`, which is where the SAS templates are stored.

```
PROC TEMPLATE;
	DELETE Base.Freq.Graphics.AgreePlot;
RUN;
```

## Other Related Topics

* Solve the error *"[unable to write to the template store](http://support.sas.com/techsup/notes/v8/4/739.html)"*:
```
ERROR: Template 'xxxxx' was unable to write to the template store!

ods path show;
ods path(prepend) work.templat(update);
```



