You can learn about macros in the **SAS Macro Language 1: Essentials course**.
 
## Remove element/string from macro variable 

```
%put &=list;     /* Check list contents before */

%let removefromlist = string_to_remove;
%let list = %sysfunc(tranwrd(&list., &removefromlist., %str()));;

%put &=list;     /* Check list contents after */
```

## Macros Available in SAS 

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
 
### 

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

