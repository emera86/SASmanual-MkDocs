!!! summary "Related Procedures"
    * [`PROC PRINT`](../print/)
    * [`PROC TABULATE`](../tabulate/)
    * [`PROC REPORT`](../report/)

## ODS 

In order to produce outputs from SAS, the three more common `ODS` techniques, that produces different output files, are HTML, RTF, and PDF. Each `ODS` statement uses options that are specific to that destination. The `ODS` options (other than the `FILE=` option) used in the program are shown in the table below. 

|                   **RTF**             |                  **PDF**                   |     **HTML**        |
|:---------------------------------------:|:--------------------------------------------:|:--------------------:|
| `BODYTITLE` <br> `STARTPAGE=NO` <br> `KEEPN` <br> `NOTOC_DATA` / `TOC_DATA` <br> `CONTENTS` <br> `COLUMNS=` <br> `TEXT=` | `BOOKMARKGEN=NO` <br> `STARTPAGE=NO` <br> `COMPRESS=9` <br> `TEXT=` | `STYLE=SASWEB` <br> `RS=NONE` |

For an explanation of the options, refer to [this page](http://www2.sas.com/proceedings/forum2007/021-2007.pdf) or to the [`ODS` User's Guide](https://support.sas.com/documentation/cdl/en/odsug/69832/HTML/default/viewer.htm#titlepage.htm).

### Setting the SAS System Options

```
OPTIONS NODATE PAGENO=1 LINESIZE=80 PAGESIZE=40;
```

* The `NODATE` option suppresses the display of the date and time in the output
* `PAGENO=` specifies the starting page number
* `LINESIZE=` specifies the output line length
* `PAGESIZE=` specifies the number of lines on an output page
