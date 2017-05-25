[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECPRG193/m413/m413_3_a_sum.htm)

## Accessing SAS libraries

`libref` is a **library reference name** (a shortcut to the physical location). There are three rules for valid librefs:

1. A length of one to eight characters
2. Begin with a letter or underscore
3. The remaining characters are letters, numbers, or underscores

Valid **variable names** begin with a letter or underscore, and continue with letters, numbers, or underscores. The `VALIDVARNAME` system option specifies the rules for valid SAS variable names that can be created and processed during a SAS session: 

```
OPTIONS VALIDVARNAME=V7 (default) | UPCASE | ANY;
```

* `libref.data-set-name`: data set reference two-level name
* `data-set-name`: when the data set belongs to a temporary library, you can optionally use a one-level name (SAS assumes that it is contained in the `work` library, which is the default)
* The `LIBNAME` statement associates the `libref` with the physical location of the library/data for the current SAS session

```
LIBNAME libref-name 'SAS-library-folder-path' <options>;

/* Example */

%let path=/folders/myfolders/ecprg193; 
libname orion "&path";
```

---

To erase the association between SAS and a custom library:

```
LIBNAME libref-name CLEAR;
```

To check the **contents of a library** programatically:

```
PROC CONTENTS DATA=libref._ALL_;
RUN;
```

To hide the descriptors of all data sets in the library (it could generate a very long report) you can add the option `nods` (only compatible with the keybord `_all_`):

```
PROC CONTENTS DATA=libref._ALL_ NODS;
RUN;
```

To access a data set you can use a `PROC PRINT` step:

```
PROC PRINT DATA=SAS-data-set;
RUN;
```

## Examining SAS Data Sets

Parts of a library (SAS notation):

* Table = **data set**
* Column = **variable**
* Row = **observation**
 

### `PROC CONTENTS`
The **descriptor portion** contains information about the attributes of the data set (metadata), including the variable names. It is show in three tables:

* *Table 1:* general information about the data set (name, creation date/time, etc.)
* *Table 2:* operating environment information, file location, etc.
* *Table 3:* alphabetic list of variables in the data set and their attributes

### `PROC PRINT`
The **data portion** contains the data values, stored in variables (numeric/character)

* *Numeric values:* right-aligned digits 0-9, minus sign, single decimal point, scientific notation (E)
* *Character values:* left-aligned; letters, numbers, special characters and blanks
* *Missing values:* ***blank*** for character variables and ***period*** for numeric ones. To change this default behaviour use  `MISSING='new-character'` 
* *Values length:* for character variables 1 byte = 1 character, numeric variables have 8 bytes of storage by default (16-17 significant digits)
* *Other attributes:* **format**, **informat**, **label**