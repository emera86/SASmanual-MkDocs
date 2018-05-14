You can learn about macros in the **SAS Macro Language 1: Essentials course**.

[Here](http://jiangtanghu.com/blog/2011/11/08/my-collection-of-sas-macro-repositories/) you have some macro repositories.

How to define [optional macro arguments](https://communities.sas.com/t5/Base-SAS-Programming/how-to-define-optional-macro-parameters/td-p/259131).
 
## Remove element/string from macro variable 

``` 
%put &=list;     /* Check list contents before */

%let removefromlist = string_to_remove;
%let list = %sysfunc(tranwrd(&list., &removefromlist., %str()));;

%put &=list;     /* Check list contents after */
```

## Call a Macro for a List of Variable Names

``` 
%macro runall(paramlist);
 %let num = %sysfunc(countw(&paramlist));
	%local i;
	%do i =1 %to &num;
		%let parameter&i = %scan(&paramlist, &i);
		%macro_analysis(variablename=&&parameter&i);
	%end;
%mend;

%runall(item1 item2 item3 item4 item5);
```

## Create Macrovariable from Data Set Values

```
DATA _NULL_;
	SET OddsRatios;
	CALL SYMPUT ('var1',OddsRatioEst);
	CALL SYMPUT ('var2',LowerCl);
	CALL SYMPUT ('var3',UpperCL);
	* The variables have a lot of extra spaces;
	%LET OR2report=OR: &var1. (&var2.,&var3.);
	%PUT &OR2report;
RUN;

DATA _NULL_;
	SET OddsRatios;
	length OddsRatioEst LowerCL UpperCL 7;
	Estaux = int(1000*OddsRatioEst)/1000;
	Loweraux = int(1000*LowerCl)/1000;
	Upperaux = int(1000*UpperCL)/1000;
	* The extra blancks has been reduced with the CATX function;
	fullOR=CATX(' ','OR:',Estaux,'(',Loweraux,',',Upperaux,')');
	CALL SYMPUT ('OR2report',fullOR);
	%PUT &OR2report;
RUN;
```

## Useful Functions for Macro Programming

### `VVALUEX` Function
Returns the formatted value that is associated with the argument that you specify. The argument specifies a character constant, variable, or expression that evaluates to a variable name. 

!!! warning
    The value of the specified expression cannot denote an array reference.
    
```
date1='31mar02'd;
date2='date1';
format date1 date7.;
datevalue=vvaluex(date2);
put datevalue;               /* 31MAR02 */
```

## Macros Available in SAS 

Check this [powerpoint](https://www.google.es/url?sa=t&rct=j&q=&esrc=s&source=web&cd=5&ved=0ahUKEwjnkNj-p5zUAhUB2RQKHR9KA3MQFghHMAQ&url=http%3A%2F%2Fwww.sascommunity.org%2Fmwiki%2Fimages%2Ff%2Ff2%2F5_Macros.pptx&usg=AFQjCNHr9cDvdo8lzpMwXfZU6qaAxV1-vg&sig2=hWHrTpexhuvP2vnAOIjEFA) presentation for more tips.

### [Color Utility Macros](http://support.sas.com/documentation/cdl/en/graphref/69717/HTML/default/viewer.htm#n0z9vlsy95ugxcn1qchqznw88m6e.htm)

To initiate these macros in your current session you call the `%COLORMAC` macro.

If you submit the following line:

```
%HELPCLR(HELP);
```

You will get a guide of the color utility macros available:

``` 
Color Utility Macros Help              
                                                      
HELP is currently available for the following macros 
                                                      
        CMY        CMYK       CNS        HLS          
        HVS        RGB        HLS2RGB    RGB2HLS      
                                                                                                          
Enter %HELPCLR(macroname) for details on each macro, 
or %HELPCLR(ALL) for details on all macros.   

```
 
### `SG` Annotation Macros

They can be used within a `DATA` to simplify the process of creating annotation observations.

``` 
  %SGARROW
  %SGPOLYGON
  %SGIMAGE
  %SGPOLYLINE
  %SGLINE
  %SGRECTANGLE
  %SGOVAL
  %SGTEXT
  %SGPOLYCONT
  %SGTEXTCONT
```

### Template Modification Macros

* `%MODSTYLE` macro allows you to easily make changes to style templates without accessing the code
* `%MODTMPLT` macro allows you to easily make limited changes to graph templates without accessing the code

### Graphical Macros

* `%CompactMatrixMacro` (Author: Sanjay Matange): it help you modify graphs based on panels
* `%NEWSURV` macro (Author: Jeff Meyers): it helps you tune the properties of survival plots
* `%FORESTPLOT` macro (Author: Jeff Meyers): it allows another way of presenting results
* `%EULER_MACRO`: useful to present proportion Euler diagrams
* `%VENN` macro: useful to plot intersection between different events
* `%GTLPieChartMacro`: useful for pie charts

### Export Macros

* [`%DS2CSV`](http://go.documentation.sas.com/?cdcId=pgmmvacdc&cdcVersion=9.4&docsetId=lebaseutilref&docsetTarget=n0yo3bszlrh0byn1j4fxh4ndei8u.htm&locale=en): exports a dataset to \*.csv format.

### Where to Find these Macros?

* Color utility macros, SGAnnotation macros, `%MODSTYLE` and `%MODTMPLT` are SAS autocall macros
* [`%AXISBREAK`](http://blogs.sas.com/content/graphicallyspeaking/2014/11/18/axis-break-appearance-macro/)
* [`%COMPACTMATRIXMACRO`](http://blogs.sas.com/content/graphicallyspeaking/2014/11/18/axis-break-appearance-macro/)
* [`%ORTHO3D_MACRO`](http://blogs.sas.com/content/graphicallyspeaking/2012/08/19/compact-scatter-plot-matrix/)
* [`%NEWSURV`](http://www.sascommunity.org/wiki/Kaplan-Meier_Survival_Plotting_Macro_%25NEWSURV)
* [`%FORESTPLOT`](http://www.sascommunity.org/wiki/Forest_Plotting_Analysis_Macro_%25FORESTPLOT)
* [`%EULER_MACRO`](http://blogs.sas.com/content/graphicallyspeaking/2014/06/29/proportional-euler-diagram/)
* [`%VENN`](http://support.sas.com/resources/papers/proceedings13/243-2013.pdf)
* [`%GTLPIECHARTMACRO`](http://blogs.sas.com/content/graphicallyspeaking/2012/08/26/how-about-some-pie/)

## Macro examples

### Macro Program for Creating Box Plots for All of Predictor Variables

```
%let categorical=House_Style2 Overall_Qual2 Overall_Cond2 Fireplaces 
         Season_Sold Garage_Type_2 Foundation_2 Heating_QC 
         Masonry_Veneer Lot_Shape_2 Central_Air;
/* Macro Usage: %box(DSN = , Response = , CharVar = ) */
%macro box(dsn      = ,
           response = ,
           Charvar  = );
%let i = 1 ;
%do %while(%scan(&charvar,&i,%str( )) ^= %str()) ;
    %let var = %scan(&charvar,&i,%str( ));
    proc sgplot data=&dsn;
        vbox &response / category=&var 
                         grouporder=ascending 
                         connect=mean;
        title "&response across Levels of &var";
    run;
    %let i = %eval(&i + 1 ) ;
%end ;
%mend box;
%box(dsn      = statdata.ameshousing3,
     response = SalePrice,
     charvar  = &categorical);
title;
options label;
```

### Checking if a data set is exists

```
DATA test-SAS-data-set;
	SET 	%if %sysfunc(exist(SAS-data-set-part1)) %then %do; 
			SAS-data-set-part1
		%end;
	    		SAS-data-set-part2;
RUN;
```

## Macro's Sources

* [Les macros SAS de Dominique Ladiray](http://www.unige.ch/ses/sococ/eda/sas/)
* [Mayo Clinic: Locally written SAS macros](http://www.mayo.edu/research/departments-divisions/department-health-sciences-research/division-biomedical-statistics-informatics/software/locally-written-sas-macros)
* [Kaplan-Meier Survival Plotting Macro %NEWSURV](http://player.slideplayer.com/39/10943335/#)
