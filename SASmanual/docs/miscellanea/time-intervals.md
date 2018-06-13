## Time periods in months or years
```
* In years;
interval = YRDIF(inidat,enddat,'age');

* In months;
interval = YRDIF(inidat,enddat,'age')*12;
```

## Time periods in days

In general, the difference between two SAS dates in days can most easily be calculated as
```
duration = end_date - start_date;
```

The `INTCK` function in SAS can calculate the difference between any two dates or datetime values, and return whatever interval you're looking for (days, minutes, hours, weeks, months).
```
data test;
  set test;
  by subj;
  days=intck('dtday', date1, date2);
  put days=;
run;
```

For hospital stays, you might have special rules about calculating day intervals. For example, a patient who is admitted and charged on the same day might count as a 1-day stay, and a patient who is discharged on the second day might still count as a 1-day stay -- so you might need to modify the formula to add 1 in the case of a same-day discharge--.  If your data are such that any record with a hospital admission represents at least a 1-day stay (for reporting purposes), then your formula might be:
```
/* return the higher of two values: calculated interval or 1 */
dur = max(intck('day',date_1,date_2), 1);
```

### The `INTICK` Function

Everyone knows that the `INTCK` function returns the integer count of the number of interval boundaries between two dates, two times, or two datetime values.

```
* Date examples ;
*---------------;
years=intck('year','01jan2009'd,'01jan2010'd);
SEMIYEAR=intck('SEMIYEAR','01jan2009'd,'01jan2010'd);
quarters=intck('qtr','01jan2009'd,'01jan2010'd);
months=intck('month','01jan2009'd,'01jan2010'd);
weeks=intck('week','01jan2009'd,'01jan2010'd);
days=intck('day','01jan2009'd,'01jan2010'd);

* Date + time examples ;
*----------------------;
hours=intck('hour','01jan2009:00:00:00'dt,'01jan2010:00:00:00'dt);
minutes=intck('minute','01jan2009:00:00:00'dt,'01jan2010:00:00:00'dt);
seconds=intck('second','01jan2009:00:00:00'dt,'01jan2010:00:00:00'dt);

* Time examples ;
*---------------;
hours=intck('hour','00:00:00't,'12:00:00't);
minutes=intck('minute','00:00:00't,'12:00:00't);
seconds=intck('second','00:00:00't,'12:00:00't);

* Use 'days365' to calculate number of years instead of number of number of interval boundaries (would be 1 for this case);
days365=intck('day365','31dec2009'd,'01jan2010'd);

* Using 'Timepart()' and 'Datepart()' ;
*-------------------------------------;
format a1 b1 date9.;
a0='01jan2009:00:00:00'dt;
b0='01jan2010:00:00:00'dt;
a1=datepart(a0);
b1=datepart(b0);
days=intck('day',a1,b1);

format a1 b1 date9.;
a0='01jan2009:00:00:00'dt;
b0='01jan2010:12:00:00'dt;
a1=timepart(a0);
b1=timepart(b0);
hour=intck('hour',a1,b1);
```

### The `INTNX` Function

This function increments a date, time, or datetime value by a given interval or intervals, and returns a date, time, or datetime value.

```
format day week month_ year date9.;
 
day=intnx('day', '01FEB2010'd, 7); /* +7 days */
week=intnx('week', '01FEB2010'd, 1); /* 01 of Feb 2010 is Monday*/
month_=intnx('month', '01FEB2010'd, 2); /* +2 month */
year=intnx('year', '01FEB2010'd, 1); /* +1 year */
```
