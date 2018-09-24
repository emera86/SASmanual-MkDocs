!!! summary "Check these websites"
    * [Here](http://support.sas.com/documentation/cdl/en/grstatug/63302/HTML/default/viewer.htm#n0kqozn49yx2lon1aavkll1f5dff.htm) you can find some notes on **Graph Template Language** (categories of statements)
    * [Bob Rodríguez](https://www.linkedin.com/in/bob-rodriguez-7b12634/) is has written a lot about templates, check his papers for more information
    * [Here](https://support.sas.com/documentation/cdl/en/statug/63962/HTML/default/viewer.htm#templt_toc.htm) you can find the official documentation on ODS Graphics Template Modification
    * [PROC TEMPLATE style tips](https://support.sas.com/rnd/base/ods/scratch/styles-tips.pdf)
	  
## Style Templates vs Graph Templates

### Modifying Style Templates

1. Obtain the source code
```
PROC TEMPLATE;
SOURCE styles.default;
RUN;
```

2. Modify the code
```
PROC TEMPLATE;
    DEFINE STYLE MyListingStyle;
    PARENT=styles.listing;
        [make desired changes in code]
    END;
RUN;
```

3. Generate the plot
```
ODS LISTING STYLE=mylistingstyle;
[SGPLOT Statements]
```

### Modifying Graph Templates

1. Obtain the source code
	```
	PROC TEMPLATE;
      	    SOURCE Stat.Lifetest.Graphics.ProductLimitSurvival;
	RUN;
	```

2. Modify the code
	```
	PROC TEMPLATE;
    	    DEFINE Stat.Lifetest.Graphics.ProductLimitSurvival;
    	    SOURCE Stat.Lifetest.Graphics.ProductLimitSurvival;
    		[make desired changes in code]
    	END;
	RUN;
	```

3. Generate the plot
	```
	PROC LIFETEST DATA=db PLOTS=S;
    	    [statements]
	RUN;
	```

4. Revert to default template
	```
	PROC TEMPLATE;
   	    DELETE Stat.Lifetest.Graphics.ProductLimitSurvival;
	RUN;
	```

## Basic Graph Template Functionalities

### Obtaining the Default Templates 

First you need to know the name of the template. For this you can either look for its name listing all the available default templates that are kept in `sashelp.tmplmst`...

```
PROC TEMPLATE;
  PATH sashelp.tmplmst;
  LIST Base.Freq / SORT=path DESCENDING;
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
!!! note
    Remember that you must add a `PROC TEMPLATE;` statement before the generated source statements and optionally a `RUN;` statement after the `END;` statement before you submit your modified definition.

### Editing Templates

Graph definitions are self-contained and do not support inheritance (via the `PARENT=` option) as do table definitions. Consequently, the `EDIT` statement in `PROC TEMPLATE` is not supported for graph definitions.

Here are some important points about what you can and cannot change in a template:

* **Do not change the template name**. A statistical procedure can access only a predefined list of templates. If you change the name, the procedure cannot find your template. You must make sure that it is in a template store that is read before `Sashelp.Tmplmst` through the `ODS PATH` statement.
* **Do not change the names of columns**. The underlying data object contains predefined column names that you must use. Be very careful if you change how a column is used in a template. Usually, columns are not interchangeable.
* **Do not change the names of `DYNAMIC` variables**. Changing dynamic variable names can lead to runtime errors. Do not add dynamic variables, because the procedure cannot set their values.
* **Do not change the names of statements** (for example, from a `SCATTERPLOT` to a `NEEDLEPLOT` or other type of plot).

You can change any of the following:

* **You can add macro variables that behave like dynamic variables**. They are resolved at the time that the statistical procedure is run, and not at the time that the template is compiled. They are defined with an `MVAR` or `NMVAR` statement at the beginning the template. You can also move a variable from a `DYNAMIC` statement to an `MVAR` or `NMVAR` statement if you want to set it yourself rather than letting the procedure set it.
* **You can change the graph size**.
* **You can change graph titles, footnotes, axis labels, and any other text that appears in the graph**.
* **You can change which plot features are displayed**.
* **You can change axis features, such as grid lines, offsets, view ports, tick value formatting, and so on**.
* **You can change the content and arrangement of insets** (small tables of statistics embedded in some graphs).
* **You can change the legend location, contents, border, background, title, and so on**.

### Using Customized Templates

The `ODS PATH` statement specifies the template stores to search, as well as the order in which to search them. You can change the default template search path by using the `ODS PATH` statement.

```
ODS PATH work.mystore(update) sashelp.tmplmst(read);
```

You can display the current template search path with the following statement:

```
ODS PATH SHOW;
```

The log messages for the default template search path are as follows:

```
Current ODS PATH list is:

1. WORK.MYSTORE(UPDATE)
2. SASHELP.TMPLMST(READ)
```

When you are done, you can reset the default template search path as follows:

```
ODS PATH RESET;
```

```
Current ODS PATH list is:

1. SASUSER.TEMPLAT(UPDATE)
2. SASHELP.TMPLMST(READ)
```

### Reverting to the Default Templates

The following statements delete the modified template from `SASUSER.TEMPLAT` and revert to the default template in
`SASHELP.TMPLMST`, which is where the SAS templates are stored.

```
PROC TEMPLATE;
	DELETE Base.Freq.Graphics.AgreePlot;
RUN;
```

The following note is printed in the SAS log:

```
NOTE: 'Base.Freq.Graphics.AgreePlot' has been deleted from: SASUSER.TEMPLAT
```

You can run the following step to delete the entire `SASUSER.TEMPLAT` store of customized templates:

```
ODS PATH sashelp.tmplmst(read);
PROC DATASETS LIBRARY=sasuser NOLIST;
   DELETE TEMPLAT(MEMTYPE=ITEMSTOR);
RUN;
ODS PATH sasuser.templat(update) sashelp.tmplmst(read);
```

## `PROC TEMPLATE` Features

### Include an Image as the Header

```
PROC TEMPLATE;
	DEFINE STYLE template_header_image;
		PARENT = styles.default;
		(...)
		STYLE SYSTEMTITLE /
			TEXTALIGN=l 
			VERTICALALIGN=t
			PREIMAGE="c:\path-to-your-file\header-image.png" 
			FOREGROUND = #ffffff;
	END;
RUN;

ODS PDF DPI=700 STYLE=template_header_image FILE="your-path\your-file (&sysdate).pdf";

TITLE "";
(...)

ODS PDF CLOSE;
```

* `DPI` needs to be increased to show the `PREIMAGE` logo with good definition
* You need to specify `TITLE "";` for the `PREIMAGE` to appear

## Other Related Topics

* Solve the error *"[unable to write to the template store](http://support.sas.com/techsup/notes/v8/4/739.html)"*:
```
ERROR: Template 'xxxxx' was unable to write to the template store!

ODS PATH SHOW;
ODS PATH(PREPEND) work.templat(UPDATE);
```
