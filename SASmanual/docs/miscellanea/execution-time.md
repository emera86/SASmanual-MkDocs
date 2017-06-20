## Measure your code execution time

```
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

[YOUR CODE HERE]

%put END TIME: %sysfunc(datetime(),datetime14.);
%put TOTAL TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss) ;
```
