[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m416/m416_3_a_sum.htm)

## Using SAS Formats

```
PROC PRINT DATA=SAS-data-base;
    FORMAT variable1 variable2 format;
    FORMAT variable3 format3 variable4 format4;
RUN;
```

### Format definition

`<$>format<w>.<d>`

* `<$>` = character format
* `format` = format name
* `<w>` = total width (includes special characters, commas, decimal point and decimal places)
* `.` = required syntax (dot)
* `<d>` = decimal places (numeric format)

### SAS formats 
[Dictionary of formats](http://support.sas.com/documentation/cdl/en/leforinforref/64790/HTML/default/viewer.htm#p0z62k899n6a7wn1r5in6q5253v1.htm)

* `$w.` = writes standard character data
* `$UPCASE.` = writes a string in uppercase
* `$QUOTE.` = writes a string in quotation marks 
* `w.d` = writes standard numeric data
* `COMMAw.d` = writes numeric values with a comma that separates every three digits and a period that separates the decimal fraction
* `DOLLARw.d` = writes numeric values with a leading dollar sign, a comma that separates every three digits and a period that separates the decimal fraction
* `COMMAXw.d` = writes numeric values with a period that separates every three digits and a coma that separates the decimal fraction
* `EUROXw.d` = writes numeric values with a leading euro symbol, a period that separates every three digits and a comma that separates the decimal fraction

### SAS date values
`MMDDYY<w>.` | `DDMMYY<w>.` | `MONYY<w>.` | `DATE<w>.` | `WEEKDATE.`

* w = 6: only date numbers
* w = 8: date numbers with `/` separators (just the last 2 digits of year)
* w = 10: date numbers with `/` separators (full 4-digit year)

!!! note
    Dates before 01/01/1960 (0 value) will appear as negative numbers.

## Creating and Applying User-Defined Formats

### `PROC FORMAT`

```
PROC FORMAT;
	VALUE <$>format-name value-or-range1='formatted-value1'
                         value-or-range2='formatted-value2';
RUN;
```

```
PROC PRINT DATA=SAS-data-set;
    FORMAT variable1 <$>format-name.;
RUN;
```

* A format name can have a maximum of **32 characters**
* The name of a format that applies to **character values** must begin with a **dollar sign** followed by a letter or underscore
* The name of a format that applies to **numeric values** must begin with a letter or underscore
* A format name cannot end in a number
* All remaining characters can be letters, underscores or numbers
* A user defined format name cannot be the name of a SAS format

Each **value-range set** has three parts:

* **value-or-range**: specifies one or more values to be formatted (it can be a value, a range or a list of values)
* **=**: equal sign
* **formatted-value**: the formatted value you want to display instead of the stored value/s (it is allways a character string no matter wheter the format applies to character values or numeric values)

```
PROC FORMAT LIBRARY = my-format-library;   /* To save the custom formats */
    VALUE string 'A'-'H'='First'
                 'I','J','K'='Middle'
                  OTHER = 'End';           /* Non-specified values */
    VALUE tiers low-<50000='Tier1'         /* 50000 not included */
                50000-<100000='Tier2'      /* 100000 not included */
                100000-high='Tier3'
                .='Missing value';
RUN;
```

!!! note
    1. If you omit the **LIBRARY** option, then formats and informats are stored in the `work.formats` catalog.
    2. If you do not include the keyword `OTHER`, then SAS applies the format only to values that match the value-range sets that you specify and the rest of values are displayed as they are stored in the data set.
    3. You can only use the `<` symbol to define a non-inclusive range.

```
OPTIONS FMTSEARCH = (libref1 libref2... librefn)
```

* The `FMTSEARCH` system option controls the order in which format catalogs are searched until the desired member is found.
* The `WORK.FORMATS` catalog is always searched first, unless it appears in the `FMTSEARCH` list.

## Examples

### How to order categorical variables

You first create a format that you will apply to an auxiliary variable: 

```
value SmFmt 1 = 'Non-smoker'
            2 = 'Light (1-5)'
            3 = 'Moderate (6-15)'
            4 = 'Heavy (16-25)'
            5 = 'Very Heavy (> 25)';
run;
```

Then you create a data set view rather than a data set in order to save storage space (which might be important for large data sets) on which you define your auxiliary variable with the predefined format:

```
data Heart / view=Heart;
	format Smoking_Cat SmFmt.;
	set sashelp.heart;
	counter = _n_;
	keep counter Status Sex AgeAtStart Height Weight Diastolic Systolic Smoking_Cat;

	select (Smoking_Status);
   		when ('Non-smoker')        Smoking_Cat=1;
   		when ('Light (1-5)')       Smoking_Cat=2;
   		when ('Moderate (6-15)')   Smoking_Cat=3;
   		when ('Heavy (16-25)')     Smoking_Cat=4;
   		when ('Very Heavy (> 25)') Smoking_Cat=5;
   		when (' ')                 Smoking_Cat=.;
	end;
run;
```

If you then use a `PROC REPORT` to display your results, the order of appearance will be the numeric order of your auxiliary variable. By using this technique, you can specify any order for the categories of a contingency table.


