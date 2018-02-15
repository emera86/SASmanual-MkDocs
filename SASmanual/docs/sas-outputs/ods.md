## Setting the SAS System Options

```
OPTIONS NODATE PAGENO=1 LINESIZE=80 PAGESIZE=40;
```

* The `NODATE` option suppresses the display of the date and time in the output
* `PAGENO=` specifies the starting page number
* `LINESIZE=` specifies the output line length
* `PAGESIZE=` specifies the number of lines on an output page
* `NONUMBER` removes pagination from the automatic output header

## ODS 

In order to produce outputs from SAS, the three more common `ODS` techniques, that produces different output files, are HTML, RTF, and PDF. Each `ODS` statement uses options that are specific to that destination. The `ODS` options (other than the `FILE=` option) used in the program are shown in the table below. 

|                   **RTF**             |                  **PDF**                   |     **HTML**        |
|:---------------------------------------:|:--------------------------------------------:|:--------------------:|
| `BODYTITLE` <br> `STARTPAGE=NO` <br> `KEEPN` <br> `NOTOC_DATA` / `TOC_DATA` <br> `CONTENTS` <br> `COLUMNS=` <br> `TEXT=` | `BOOKMARKGEN=NO` <br> `STARTPAGE=NO` <br> `COMPRESS=9` <br> `TEXT=` | `STYLE=SASWEB` <br> `RS=NONE` |

For an explanation of the options, refer to [this page](http://www2.sas.com/proceedings/forum2007/021-2007.pdf) or to the [`ODS` User's Guide](https://support.sas.com/documentation/cdl/en/odsug/69832/HTML/default/viewer.htm#titlepage.htm).

* Remove graph's external borders:
```
ODS GRAPHICS / NOBORDER;
```

### Basic `ODS` Options

You need to add this command to get the plots displayed in the output:

```
ODS GRAPHICS ON;
[your code here]
ODS GRAPHICS OFF;
```

When you add the `ODS TRACE` statement, SAS writes a trace record to the log that includes information about each output object (name, label, template, path):

``` 
ODS TRACE ON;
[your code here]
ODS TRACE OFF;
```

You produce a list of the possible output elements in the log that you may specify in the `ODS SELECT/EXCLUDE` statement:

```
ODS SELECT output-name1 output-name2 output-name3;
[your code here]
ODS SELECT ALL;  /* Reset this option to the default */
```

Yo can keeps some of the outputs in SAS-data-sets:

```
ODS OUTPUT output-name1=generated-data-set1 output-name1=generated-data-set2 output-name1=generated-data-set3;
```

### Control the output via `ODS EXCLUDE`

* [Turn off ODS when running simulations in SAS](https://blogs.sas.com/content/iml/2013/05/24/turn-off-ods-for-simulations.html)
* [What is the best way to suppress ODS output in SAS?](https://blogs.sas.com/content/iml/2015/05/26/suppress-ods.html)
* [Five reasons to use ODS EXCLUDE to suppress SAS output](https://blogs.sas.com/content/iml/2015/05/28/five-reasons-ods-exclude.html)

Example on combining `ODS EXCLUDE` with `ODS OUTPUT` to control the obtained output:

```
ODS EXCLUDE ALL;
PROC FREQ DATA=SAS-data-set;
	TABLE variable1*variable2;
	ODS OUTPUT CROSSTABFREQS=custom-SAS-data-set;
RUN;
ODS EXCLUDE NONE;
```



