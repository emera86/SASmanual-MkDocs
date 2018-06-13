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
