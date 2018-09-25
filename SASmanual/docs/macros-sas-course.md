* describe what macro variables store and where macro variables are stored
* identify selected automatic macro variables
* create user-defined macro variables
* display macro variables in the SAS log
* identify tokens in a SAS program
* place a macro variable reference adjacent to text or another macro variable reference

## Basic Concepts

Macro variables substitute text into your SAS programs. The macro facility enables you to create and resolve macro variables anywhere within a SAS program. There are two types of macro variables: **automatic macro variables**, which SAS provides, and **user-defined macro variables**, which you create and define.

### Automatic Macro Variables

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
| SYSLAST	| Name of the most recently created data set in the form `libref.name` (the value is `_NULL_` when none has been created)|
| SYSPARM	| Value specified at SAS invocation |
| SYSERR	| SAS `DATA` or `PROC` step return code (0=success) |
| SYSLIBRC | `LIBNAME` statement return code (0=success) |

### User-defined Macro Variables

You use the `%LET` statement to create a macro variable and assign a value to it. Macro variable names **start with a letter or an underscore** and can be followed by letters, digits, or underscores. The prefixes **AF, DMS, SQL, and SYS are not recommended** because they are frequently used in SAS software when creating macro variables. If you assign a macro variable name that isn't valid, SAS writes an error message to the log.

When assigning values to macro variables in the `%LET` statement, SAS does the following:

* Stores all macro variable values as text strings, even if they contain only numbers
* Doesn't evaluate mathematical expressions in macro variable values
* Stores the value in the case that is specified in the `%LET` statement
* Stores quotation marks as part of the macro variable value
* Removes leading and trailing blanks from the macro variable value before storing it
* SAS doesn't remove blanks within the macro variable value

To **reference a user-defined macro variable**, you precede the name of the macro variable with an ampersand (`&macrovariable`). When you submit the program, the macro processor resolves the reference and substitutes the macro variable's value before the program compiles and executes.

Macro variables remain in the global symbol table until they are deleted or the session ends. To **delete macro variables**, you use the `%SYMDEL` statement followed by the name or names of the macro variables that you want to delete.

## Tips

If you need to reference a macro variable within quotation marks, such as in a title, you must use double quotation marks.
