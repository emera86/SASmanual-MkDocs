!!! check
    * [Here](https://support.sas.com/resources/papers/proceedings11/281-2011.pdf) are some examples of complex graphs.
    * [Here](http://support.sas.com/documentation/cdl/en/grstatproc/65235/HTML/default/viewer.htm#p07m2vpyq75fgan14m6g5pphnwlr.htm) there are instructions to play with the axis' attributes.

## Basic `ODS` Options

You need to add this command to get the plots displayed in the output:

```
ODS GRAPHICS ON;
[your code here]
ODS GRAPHICS OFF;
```

When you add the `ODS TRACE` statement, SAS writes a trace record to the log that includes information about each output object (name, label, template, path):

``` 
ODS TRACE ON;
[your code here]
ODS TRACE OFF;
```

You produce a list of the possible output elements in the log that you may specify in the `ODS SELECT/EXCLUDE` statement:

```
ODS SELECT lmeans diff meanplot diffplot controlplot;
[your code here]

ODS SELECT ALL;  /* Reset this option to the default */
```

---

* Remove date and pagination from the automatic output header:
```
OPTIONS NODATE NONUMBER;
```

* Remove graph's external borders:
```
ODS GRAPHICS / NOBORDER;
```

## Plots

* Highlight a certain boxplot and get the plot narrower: 
```
proc sgplot data=sashelp.heart;
	/* The order matters: first thing defined goes to the back */
	refline 'Coronary Heart Disease' / axis=x 
    	lineattrs=(thickness=70 color=yellow) transparency=0.5 ;
	vbox cholesterol / category=deathcause;
	xaxis OFFSETMIN=0.25 OFFSETMAX=0.25 discreteorder=data;
    yaxis grid;
run;
```

* [Specify the colors of groups in SAS statistical graphics](http://blogs.sas.com/content/iml/2012/10/17/specify-the-colors-of-groups-in-sas-statistical-graphics.html)
