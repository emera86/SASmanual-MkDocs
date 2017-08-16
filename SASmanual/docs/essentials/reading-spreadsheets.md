[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m418/m418_3_a_sum.htm)

## Reading Spreadsheet Data

SAS/ACCESS LIBNAME statement (read/write/update data):

```
LIBNAME libref <engine> <PATH=>"workbook-name" <options>;
```

E.g.:<br>
**Default engine:** `LIBNAME orionx excel "&path/sales.xls"`<br>
**PC Files server engine:** `LIBNAME orionx pcfiles PATH="&path/sales.xls"`<br>

- `<\engine>`: excel (if both SAS and Office are 32/64 bits), pcfiles (if the value is different)
- The icon of the library will be different (a globe) indicating that the data is outside SAS
- The members whose name ends with a `$` are the **spreadsheets** while the others are named **ranges**. In case it has the `$`, you need to refer to that Excel worksheet in a special way to account for that special character (SAS name literal): `libref.'worksheetname$'n`
- You can use the `VALIDVARNAME = v7` option in SAS Enterprise Guide to cause it to behave the same as in the SAS window environment
- Is important to disassociate the library: the workbook cannot be opened in Excel meanwhile (SAS puts a lock on the Excel file when the libref is assigned): **`LIBNAME libref CLEAR;`**

---

Import the xls data:

```
PROC IMPORT DATAFILE="/folders/myfolders/reading_test.xlsx"
            OUT=work.myexcel
            DBMS=xlsx 
            REPLACE;
RUN;
```

## Reading Database Data

```
LIBNAME libref engine <SAS/ACCESS options>;
```

- **engine**: oracle or BD2
- **SAS/ACCESS options**: USER, PASSWORD/PW, PATH (specifies the Oracle driver, node and database), SCHEMA (enables you to read database objects such as tables and views)
