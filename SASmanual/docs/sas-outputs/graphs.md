!!! summary "Check these websites"
    * [Here](https://support.sas.com/resources/papers/proceedings11/281-2011.pdf) are some examples of complex graphs.
    * [Here](http://support.sas.com/documentation/cdl/en/grstatproc/65235/HTML/default/viewer.htm#p07m2vpyq75fgan14m6g5pphnwlr.htm) there are instructions to play with the axis' attributes.
    * [Graphically speaking](http://blogs.sas.com/content/graphicallyspeaking/) blog with useful tips for graphics.

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
ODS SELECT output-name1 output-name2 output-name3;
[your code here]
ODS SELECT ALL;  /* Reset this option to the default */
```

Yo can keeps some of the outputs in SAS-data-sets:

```
ODS OUTPUT output-name1=generated-data-set1 output-name1=generated-data-set2 output-name1=generated-data-set3;
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

###`GPLOT`

* Reference lines:

```
SYMBOL1 COLOR=blue INTERPOL=join;
AXIS1 LABEL=('X axis label') order=(0 to 15 by 1) reflabel=(j=c h=9pt 'Reference line label 1' 'Reference line label 2' 'Reference line label 3');
AXIS2 LABEL=('Y axis label' j=c);
PROC GPLOT DATA=SAS-data-set;
	PLOT variabley*variablex / HAXIS=AXIS1 VAXIS=AXIS2 HREF=6 9 13 /*location of ref lines*/;
RUN;
```

###`SGPLOT`

* Highlight a certain boxplot and get the plot narrower: 
```
PROC SGPLOT DATA=sashelp.heart;
	/* The order matters: first thing defined goes to the back */
	REFLINE 'Coronary Heart Disease' / AXIS=x 
    	LINEATTRS=(THICKNESS=70 COLOR=yellow) TRANSPARENCY=0.5 ;
	VBOX cholesterol / CATEGORY=deathcause;
	XAXIS OFFSETMIN=0.25 OFFSETMAX=0.25 DISCRETEORDER=data;
    YAXIS GRID;
RUN;
```

* [Specify the colors of groups in SAS statistical graphics](http://blogs.sas.com/content/iml/2012/10/17/specify-the-colors-of-groups-in-sas-statistical-graphics.html)

## Miscellanea

### Available Colors at the SAS Registry

You can check the [list of SAS predefined colors](http://support.sas.com/documentation/cdl/en/graphref/69717/HTML/default/viewer.htm#n161ukdyz9wpfsn1nh8sihforvyq.htm) and even list it using the SAS registry:

```
PROC REGISTRY LIST STARTAT='\COLORNAMES\HTML'; 
RUN; 
```

!!! summary "Check this website"
    * [Using the SAS Registry to Control Color](http://support.sas.com/documentation/cdl/en/lrcon/69852/HTML/default/viewer.htm#n1hpynpm51h88wn1izdahm5id5yw.htm#p1xtn4wjg933son1p6o6t8izxtrr)
