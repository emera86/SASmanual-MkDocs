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
* `$QUOTE.` = writes a string in quotation marks 
* `w.d` = writes standard numeric data
* `COMMAw.d` = writes numeric values with a comma that separates every three digits and a period that separates the decimal fraction
* `DOLLARw.d` = writes numeric values with a leading dollar sign, a comma that separates every three digits and a period that separates the decimal fraction
* `COMMAXw.d` = writes numeric values with a period that separates every three digits and a coma that separates the decimal fraction
* `EUROXw.d` = writes numeric values with a leading euro symbol, a period that separates every three digits and a comma that separates the decimal fraction
* `DOSEF.` = you can see the actual variable level values in the output rather than some indexes
* `$UPCASE.` = writes a string in uppercase

If you want to uppercase **only the first letter** of words there is not a format but a function that you could use to transform your value:

```
var_propercase = PROPCASE(var_uppercase);
```

### SAS date values
`MMDDYY<w>.` | `DDMMYY<w>.` | `MONYY<w>.` | `DATE<w>.` | `WEEKDATE.`

* w = 6: only date numbers
* w = 8: date numbers with `/` separators (just the last 2 digits of year)
* w = 10: date numbers with `/` separators (full 4-digit year)

!!! note
    Dates before 01/01/1960 (0 value) will appear as negative numbers.
    
!!! warning
    If you ever have to deal with hours (4-character strings with the military hour) you better create an auxiliary character variable with a `:` in between hours and minutes or translate it into seconds (numeric) before applying an `HOURw.d` (time interval in hours and its fractions) or `HHMMw.d` (time in HH:MM appearance) format. 

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
    1. If you omit the `LIBRARY` option, then formats and informats are stored in the `work.formats` catalog.
    2. If you do not include the keyword `OTHER`, then SAS applies the format only to values that match the value-range sets that you specify and the rest of values are displayed as they are stored in the data set.
    3. You can only use the `<` symbol to define a non-inclusive range.

```
OPTIONS FMTSEARCH = (libref1 libref2... librefn);
```

* The `FMTSEARCH` system option controls the order in which format catalogs are searched until the desired member is found.
* The `WORK.FORMATS` catalog is always searched first, unless it appears in the `FMTSEARCH` list.



!!! tip "Format maximum length"
    The maximum lenght of a custom format is defined by the length of its longer label.
    If you need to increase it you can create a larger dummy element in the format or change the format attributes (see [this example](https://luciarodrigoinsausti.com/sasmanual/essentials/formatting/#how-to-modify-an-existing-format)). 

###  Creating a Format from a SAS Dataset

```
DATA formatdataset;
	SET originaldataset;
	RETAIN fmtname '$custom_format_name' TYPE 'C';
	RENAME index_variable=start label_variable=label;
RUN;

PROC FORMAT CNTLIN=formatdataset;
RUN;
```

!!! summary "Check these websites"
    [Creating a Format from Raw Data or a SAS Dataset](http://www2.sas.com/proceedings/forum2007/068-2007.pdf)

### [`PROC FORMAT`'s `PICTURE` Statement](http://support.sas.com/documentation/cdl/en/proc/70377/HTML/default/viewer.htm#p0n990vq8gxca6n1vnsracr6jp2c.htm)

`LOW-HIGH` ensures that all values are included in the range. The `MULT=` statement option specifies that each value is multiplied by 1.61. The `PREFIX=` statement adds a US dollar sign to any number that you format. The picture contains six digit selectors, five for the salary and one for the dollar sign prefix.

```
PROC FORMAT;
    PICTURE pct (round)   low-high ='0009.9%)'  (mult=10 prefix='(');
    PICTURE pctl (round)  low-high ='0000.00%)' (mult=100 prefix='(');
    PICTURE numero        low-high ="0000000)"  (prefix='(N=');
    PICTURE uscurrency    low-high='000,000'    (mult=1.61 prefix='$');
RUN;
```

## Examples

### How to Order Categorical Variables

!!! summary "Check these websites"
    * [There Is No `APPEND` Option On `PROC FORMAT`. What Can You Do?](http://www.lexjansen.com/nesug/nesug97/coders/goldman.pdf)

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

### How to Modify an Existing Format

We first load the existing format from the catalog into a data set:
```
%LET fmtname = %QSYSFUNC(COMPRESS(&fmtnamepoint.,%STR(%.)));

PROC FORMAT LIBRARY=WORK CNTLOUT=tmpfmt1;
	SELECT &fmtname.;
RUN;

DATA tmpfmt2;
	SET tmpfmt1;
	KEEP START END LABEL FMTNAME;
RUN;
```

We create the new format entry and add it to the existing format list:
```
DATA updatefmt;
	LENGTH FMTNAME $32. START $16. END $16. LABEL $102.;
	FMTNAME = "&TIMEVARFORMAT.";
	LABEL = 'Format label';
	END = 'end-valule';
	START = 'start-value';
RUN;

DATA newfmt;
	SET updatefmt tmpfmt2;
	END = TRIM(LEFT(END));
	START = TRIM(LEFT(START));
RUN;
```

Now we load the updated format to the format catalog:
```
ODS SELECT NONE;
PROC FORMAT LIBRARY=WORK CNTLIN=newfmt FMTLIB;
RUN;
ODS SELECT ALL;
```

If you need to recover the original format after some operations you just load the original data set:
```
ODS SELECT NONE;
PROC FORMAT LIBRARY=WORK CNTLIN=tmpfmt1 FMTLIB;
RUN;
ODS SELECT ALL;
```
