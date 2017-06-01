[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m422/m422_5_a_sum.htm)

## Using PROC FREQ to Create Summary Reports

* When you're summarizing data, there's no need to show a frequency distribution for variables that have a large number of distinct values
* Frequency distributions work best with variables whose values meet two criteria: variable with **categorical values** and values are **best summarized by counts instead of averages**
* Variables that have continuous numerical values, such as dollar amounts and dates, will need to be **grouped into categories** by **applying formats** inside the PROC FREQ step (substitute an specific range of those values by a tag)

```
PROC FREQ DATA=SAS-data-set <option(s)>;
    TABLES variable(s) <loption(s)>;
    <additional statements>
RUN;
```

* **PROC FREQ** produces frequency tables that report the distribution of any or all variable values in a SAS data set
* In the **TABLE** statement you specify the frequency tables to produce 
* To create **one-way** frequency tables you specify one or more variable names separated by space
* **WATCH OUT**: if you omit the **TABLE** statement, SAS produces a one-way table for every variable in the data set
* The **PROC FREQ** step automatically displays output in a report, so you don't need to add a PROC PRINT step 
* Each unique variable's value displayed in the 1<sup>st</sup> column of the output is called a **level of the variable**

---

```
PROC FREQ DATA=SAS-data-set <option(s)>;
    TABLES variable/NOCUM NOPERCENT;
    <additional statements>
RUN;
```

* **NOCUM** option supresses the display of  the cummulative frequency and cummulative percent values 
* **NOPERCENT** option supresses the display of all percentages

---

```
PROC SORT DATA=SAS-data-set
    OUT=SAS-data-set-sorted;
    BY variable_sorted;
RUN;

PROC FREQ DATA=SAS-data-set-sorted;
    TABLES variable-freq;
    BY variable_sorted;
RUN;
```

- Whenever you use the **BY** statement, the data set must be sorted by the variable named in the statement
- Using this we will get a frequency table on **`variable_freq`** for each value of **`variable_sorted`**

---

***Crosstabulation tables***

* Sometimes it is useful to view a single table with statistics for each distintic combination of values of the selected variables
* The simplest crosstabulation table is a **two-way table**

```
PROC FREQ DATA=SAS-data-set;
    TABLES variable1 * variable2 / NOFREQ NOPERCENT NOROW NOCOL;
RUN;

variable1 = table rows
variable2 = table columns
```

Information contained in crosstabulation tables (legend):

* **Frequency**: indicates the number of observations with the unique combination of values represented in that cell
* **Percent**: indicates the cell's percentage of the total frequency
* **Row Pct**: cell's percentage of the total frequency for its row
* **Col Pct**: cell's percentage of the total frequency for its column 
<br><br>
* **LIST** option format: the first two columns specify each possible combination of the two variables; it displays the same statistics as the default **one-way frequency** table
* **CROSSLIST** option format: it displays the same statistics as the default **crosstabulation** table

--- 

The **FORMAT=** option allows you to format the frequency value (to any SAS numeric format or a user-defined numeric format while its length is not more than 24) and to change the width of the column (e.g. to allow variable labels to fit in one line). 

```
PROC FREQ DATA=SAS-data-set;
    TABLES variable1 * variable2 /
    FORMAT = <w>.;
    FORMAT variable1 $format-name.;    
RUN;
```

The **FORMAT=** option applies only to crosstabulation tables displayed in the default format. It doesn't apply to crosstabulation tables produced with the **LIST**/**CROSSLIST** option

## Using PROC FREQ for Data Validation

You can use a **PROC FREQ** step with the **TABLES** statement to detect invalud numeric and character data by looking at distinct values. The **FREQ** procedure **lists all discrete values** for a variable and **reports its missing values**.

```
PROC FREQ DATA=SAS-data-set <ORDER=FREQ>;
    TABLES variable;
RUN;
```

* You can check for non-expected variable's values
* You can check for missing values
* You can find duplicated values

---

The table showing the **Number of Variable Levels** can indicate whether a variable contains duplicate/missing/non-expected values:

```
PROC FREQ DATA=SAS-data-set NLEVELS;
    TABLES variable / NOPRINT;
RUN;
```

---

You can use a **WHERE** statement to print out only the invalid values to be checked:

```
PROC PRINT DATA=SAS-data-set;
    WHERE gender NOT IN ('F','M') OR
          job_title IS NULL OR
          salary NOT BETWEEN 24000 AND 500000 OR
          employee IS MISSING;
RUN;
```

---

You can output the tables to a new data set instead of displaying it:

```
PROC FREQ DATA=SAS-data-set NOPRINT;
   TABLE variable / OUT=SAS-new-data-set;
RUN;
```

## Using the MEANS and UNIVARIATE Procedures

**PROC MEANS** produces summary reports with descriptive statistics and you can create statistics for groups of observations

* It automatically displays output in a report and you can also save the output in a SAS data set
* It reports the **number of nonmissing values** of the analysis variable (N), and the **mean**, the **standard deviation** and **minimum/maximum values** of every numeric variable in the data set
* The variables in the **CLASS** statement are called **classification variables** or **class variables** (they typically have few discrete values)
* Each combination of class variable values is called a **class level**
* The data set **doesn't need to be sorted** or indexed by the class variables
* **N Obs** reports the number of observations with each unique combination of class variables, whether or not there are missing values (if these **N Obs** are identical to **N**, there are no missing values in you data set)

```
PROC MEANS DATA=SAS-data-set <statistic(s)>;
    VAR analysis-variable(s);
    CLASS classification-variable(s);
RUN;
```

To write the report in a new data set (including total addition):

```
PROC MEANS DATA=SAS-data-set NOPRINT NWAY;
	OUTPUT OUT=SAS-new-data-set SUM=addition-new-variable;
    VAR analysis-variable(s);
    CLASS classification-variable(s);
RUN;
```

Format options: 

* **MAXDEC=number** (default format = BESTw.) 
* **NONOBS**
* **FW=number**: specifies that the field width for all columns is *number*
* **PRINTALLTYPES**: displays statistics for all requested combination of class variables

![Descriptive statistics](https://lh3.googleusercontent.com/R84N_PMRcXBBgDksyuhN6i--5J_vun1oLe5CRgMIvZdFZNSbSAxMkrKzCo5z7Zn_2aPnoFY=s0 "Descriptive statistics")
![Quantile statistics](https://lh3.googleusercontent.com/aQuAOJzy4JgnaWUPOUwU80TvOp9DeQXr3Iesbw1EVHVJrZKjUw-TC4S27Mhd6Dt8NJ7V7j4=s0 "Quantile statistics")

---

***Alternative procedure to validate data: *** **PROC MEANS**

* The **MIN**/**MAX** values can be useful to check if the data is within a range
* **NMISS** option displays the number of observations with missing values

---

***Alternative procedure to validate data: *** **PROC UNIVARIATE**

**PROC UNIVARIATE** is a procedure that is useful for detecting data outliers that also produces summary reports of **descriptive statistics**

```
PROC UNIVARIATE DATA=SAS-data-set;
    VAR variable(s);
    ID variable_to_relate;
    HISTOGRAM variables </options>;
    PROBPLOT variables </options>;
    INSET keywords </options>;
RUN;
```

* If you omit the **VAR** statement, all numeric variables in the data set are analyzed
* The **Extreme Observations** table contains useful information to locate outliers: it displays the 5 lowest/highest values by default along with the corresponding observation number. The **ID** statement specifies that SAS will use this variable as a label in the table of extreme observations and as an identifier for any extreme.
* To specify the number of listed observations you can use **NEXTROBS=**
* **HISTOGRAM/PROBPLOT** options: normal(mu=est sigma=est) creates a normal curve overlay to the histogram using the estimates of the population mean and standard deviation
* **INSET** writes a legend for the graph. `/ position=ne` moves the **INSET** to the north-east corner of the graph.

To include in the report only one of the automatically produced tables:

1) Check the specific table name in the **LOG information** using **ODS TRACE**:

```
ODS TRACE ON;
PROC UNIVARIATE DATA=SAS-data-set;
    VAR variable(s);
RUN;
ODS TRACE OFF;
```

2) Select the wanted table with **ODS SELECT**:

```
ODS SELECT ExtremeObs;
PROC UNIVARIATE DATA=SAS-data-set;
    VAR variable(s);
RUN;
```

---

***SUMMARY of validation procedures***

![Validation procedures](https://lh3.googleusercontent.com/qa02E3GQU_EU1ZHWX40Ewy-WsXd7hmzfJ5HXBOCDvHrtxRGjrlh6R3hjEupj5Ul9mDreXO8=s0 "Validation procedures")

## Using the SAS Output Delivery System

```
ODS destination FILE="filename" <options>;
    <SAS code to generate the report>
ODS destination CLOSE;
```

* You can have multiple destinations open and execute multiple procedures
* All generated output will be sent to every open destination
* You might not be able to view the file, or the most updated file, outside of SAS until you close the destination

**E.g.:**

```
ODS pdf FILE="C:/output/test.pdf";
(...)
ODS pdf CLOSE;

ODS csvall FILE="C:/output/test.cvs";
ODS rtf FILE="C:/output/test.rtf";
(...)
ODS csvall CLOSE;
ODS rtf CLOSE;
```

***Allowed file formats and their corresponding destinations:***
![SAS Output Delivery System](https://lh3.googleusercontent.com/p3gAmRNbwqP8WfUOSKCLxTA042D3e_F9OUkxYJ0XHspC7MAfzfAnK0ghvpLZQXJWNWdbPd0=s0 "SAS Output Delivery System")

You can also `EXPORT` a database to a different format:
```
PROC EXPORT DATA=sashelp.class
    OUTFILE='c:\temp\sashelp class.csv'
    DBMS=CSV
    REPLACE;
RUN;
```
