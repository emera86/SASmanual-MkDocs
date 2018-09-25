* describe what macro variables store and where macro variables are stored
* identify selected automatic macro variables
* create user-defined macro variables
* display macro variables in the SAS log
* identify tokens in a SAS program
* place a macro variable reference adjacent to text or another macro variable reference

## Basic Concepts

Macro variables substitute text into your SAS programs. The macro facility enables you to create and resolve macro variables anywhere within a SAS program. There are two types of macro variables: **automatic macro variables**, which SAS provides, and **user-defined macro variables**, which you create and define.

## Automatic Macro Variables

Automatic macro variables contain system information such as the date and time that the current SAS session began. Some automatic macro variables have fixed values that SAS defines when the session starts. This table shows several common automatic macro variables:

| Name	        | Description   | Example       |
|:-------------:|---------------|:-------------:|
| SYSDATE	      | Date when the current SAS session began (DATE7.)	| 16JAN13 |
| SYSDATE9	    | Date when the current SAS session began (DATE9.)	| 16JAN2013 |
| SYSDAY	      | Day of the week when the current SAS session began	| Friday |
| SYSSCP	      | Abbreviation for the operating system being used	| OS, WIN, HP 64 |
| SYSTIME	      | Time that the current SAS session began	| 13:39 |
| SYSUSERID	    | The user ID or login of the current SAS process	| MyUserid |
| SYSVER	      | Release of SAS software being used	| 9.4 |

Other automatic macro variables have values that change automatically, based on the SAS statements that you submit.

| Name | Description |
|:-----:|------------|
| SYSLAST	| Name of the most recently created data set in the form `libref.name`; if no data set has been created, the value is `_NULL_`|
| SYSPARM	| Value specified at SAS invocation |
| SYSERR	| SAS DATA or PROC step return code (0=success) |
| SYSLIBRC | LIBNAME statement return code (0=success) |

## Tips

If you need to reference a macro variable within quotation marks, such as in a title, you must use double quotation marks.
