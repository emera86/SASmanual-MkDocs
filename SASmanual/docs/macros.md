You can learn about macros in the **SAS Macro Language 1: Essentials course**.
 
## Remove element/string from macro variable 

```
%put &=list;     /* Check list contents before */

%let removefromlist = string_to_remove;
%let list = %sysfunc(tranwrd(&list., &removefromlist., %str()));;

%put &=list;     /* Check list contents after */
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
 
### `SG`Annotation Macros

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

