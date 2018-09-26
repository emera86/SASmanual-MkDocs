## Overview of Macro Functions

### Macro functions 

Macro functions enable you to manipulate text strings that SAS inserts in your code. When you submit a program, SAS executes the macro functions before the program compiles. To use a macro function, specify the function name, which starts with a percent sign. Enclose the function arguments in parentheses, separated by commas.
```
%function-name (argument-1<, argument-n>)
```
The arguments can include:

* Constant text (S&P 500)
* Macro variable references (&sysdate9)
* Macro functions ( %lenght(&var) )
* Macro calls (%time)

When you use constant text, do not enclose the text in quotation marks. If you do include them, they'll become part of the argument.
```
%upcase(text-argument)
```

You can use all macro functions in both open code and macro definitions. Macro functions are categorized in four types:

* Macro character functions
* Macro evaluation functions
* Macro quoting functions
* Other macro functions

## Using Macro Character Functions

Macro character functions enable you to manipulate character strings or obtain information about them.

### `%SUBSTR` Function 

`%SUBSTR` extracts a substring of characters from an argument consisting of a character string or text expression. Position specifies where the extraction should begin. n specifies the number of characters to extract. If you don't specify n, the remainder of the string is extracted.
```
%SUBSTR (argument, position <, n>)
```

### `%SCAN` Function

The `%SCAN` function enables you to extract words from a macro variable or text expression. `%SCAN` returns the nth word in an argument, where the words in the argument are separated by delimiters. If n is greater than the number of words in the argument, the function returns a null string. Delimiters refers to the characters that separate words or text expressions.
```
%SCAN (argument, n <, delimiters>)
```

If you omit the optional delimiter information, `%SCAN` uses a default set of delimiters shown below.

| Encoding | Type	| Default Delimiters |
|:-----:|-----|-----|
| ASCII	| blank | . < ( + & ! $ * ) ; ^ - / , % &#124; |
| EBCDIC | blank | . < ( + &#124; & ! $ * ) ; ¬ - / , % ¦ ¢ |

### `%UPCASE` Function

The `%UPCASE` function enables you to convert characters to uppercase before substituting that value in a SAS program.
```
%UPCASE (argument)
```

### `%INDEX` Function

The `%INDEX` function enables you to search for a string within a source. `%INDEX` searches source for the first occurrence of string and returns the position of its first character. If an exact match of string is not found, the function returns 0.
```
%INDEX (source, string)
```

## Using Arithmetic and Logical Expressions

### `%EVAL` Function

The `%EVAL` function evaluates arithmetic and logical expressions.
```
%EVAL (arithmetic or logical expression)
```
  
| Arithmetic Expressions	|  Logical Expressions |
|:---:|----|
|  1 + 2	                  |  &DAY = FRIDAY |
|  4 * 3	                  |  A < a |
|  4 / 2	                  |  1 < &INDEX |
|  00FFx - 003Ax	          |  &START NE &END |
  
* When `%EVAL` evaluates an **arithmetic expression**, it temporarily converts operands to numeric values and performs an integer arithmetic operation. If the result of the expression is noninteger, `%EVAL` truncates the value to an integer. The result is expressed as text. The %EVAL function generates an error message in the log when it encounters an expression that contains noninteger values.

```
/* Example */
%let x = %eval(5,3);
%put x=&x
/*result 1*/
```

* When `%EVAL` evaluates a **logical expression**, it returns a value of 0 to indicate that the expression is false, or a value of 1 to indicate that the expression is true.

```
/* Example */
%let x = %eval(10 lt 2); /*10 less than 2*/
/*The expression is false*/
%put x=&x
/*result 0*/
```

### `%SYSEVALF` function

The `%SYSEVALF` function evaluates arithmetic and logical expressions using floating-point arithmetic and returns a value that is formatted using the `BEST32.` format (meaning that decimal contributions are not accounted in the operation). The result of the evaluation is always text.

```
%SYSEVALF (expression <, conversion-type>)

/* Example */
%let value=%sysevalf(10.5+20.8);
%put 10.5+20.8 = &value;
/* result 10.5+20.8 = 30 */
```

You can use `%SYSEVALF` with an optional conversion type (`BOOLEAN`, `CEIL`, `FLOOR`, or `INTEGER`) that tailors the value returned by `%SYSEVALF`.

## Using SAS Functions with Macro Variables

### `%SYSFUNC` macro function

You can use the `%SYSFUNC` macro function to execute SAS functions within the macro facility.
```
%SYSFUNC (SAS-function(argument(s)) <, format>)

/* Example */
%let current = %sysfunc(time(), time.);
```

Because `%SYSFUNC` is a macro function, you don't enclose character values in quotation marks, as you do in SAS functions. You can specify an optional format for the value returned by the function. If you do not specify a format, numeric results are converted to a character string using the `BEST12.` format. SAS returns character results as they are, without formatting or translation.

You can use almost any SAS function with the `%SYSFUNC` macro function. The exceptions are shown in this table.

| Function Type	| Function Name |
|-----|-----|
| Array processing	| `DIM`, `HBOUND`, `LBOUND` |
| Variable information	| `VNAME`, `VLABEL`, `MISSING` |
| Macro interface	| `RESOLVE`, `SYMGET` |
| Data conversion	| `INPUT`, `PUT` |
| Other functions	| `ORCMSG`, `LAG`, `DIF` |

!!! tip
    Use `INPUTC` and `INPUTN` in place of `INPUT`, and `PUTC` and `PUTN` in place of `PUT`.

## Using Macro Functions to Mask Special Characters

Macro quoting functions enable you to clearly indicate to the macro processor how it is to interpret special characters and mnemonics.

### `%STR` Macro Quoting Function

The macro quoting function `%STR` masks (or quotes) special characters during compilation so that the macro processor does not interpret them as macro-level syntax.
```
%STR (argument)
```

`%STR` can also be used to quote tokens that typically occur in pairs, such as the apostrophe, quotation marks, and open and closed parentheses. The unmatched token must be preceded by a `%`.
Here is a list of all of the special characters and mnemonics masked by `%STR`.
```
+ - * / < > = ¬ ^ ~ ; , # blank
AND OR NOT EQ NE LE LT GE GT IN
' " ) (
```

Note that `%STR` does not mask the characters `&` or `%`.

### `%NRSTR` Macro Quoting Function

`%NRSTR` masks the same characters as `%STR` and also masks the special characters `&` and `%`. Using `%NRSTR` instead of `%STR` prevents macro and macro variable resolution.
```
%NSTR (argument)
```
