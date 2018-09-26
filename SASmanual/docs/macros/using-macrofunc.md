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

The %UPCASE function enables you to convert characters to uppercase before substituting that value in a SAS program.
  %UPCASE (argument)
Code Challenge:
Complete the following FOOTNOTE statement, ensuring that the value of the macro variable month will be inserted in uppercase even if the stored value is lowercase or mixed case.
  footnote "CLASSES OFFERED IN ... ";
The correct answer is:
  footnote "CLASSES OFFERED IN %upcase(&month)";
Use the %UPCASE function with the reference to month. Be sure to precede month with an ampersand.

### `%INDEX` Function

The %INDEX function enables you to search for a string within a source. %INDEX searches source for the first occurrence of string and returns the position of its first character. If an exact match of string is not found, the function returns 0.
  %INDEX (source, string)
Question:
What will be written to the SAS log when you submit the following %INDEX statement?
  %let a=a very long value;
  %let b=%index(&a,v);
  %put V appears at position &b;
a.  V appears at position 2
b.  V appears at position 3 (Correct)
c.  None of the above
The %INDEX function finds the text string v beginning at position 3.

## Using Arithmetic and Logical Expressions

### `%EVAL` Function

The %EVAL function evaluates arithmetic and logical expressions.
  %EVAL (arithmetic or logical expression)
  Arithmetic Expressions	|  Logical Expressions
  1 + 2	                  |  &DAY = FRIDAY
  4 * 3	                  |  A < a
  4 / 2	                  |  1 < &INDEX
  00FFx - 003Ax	          |  &START NE &END
  
#### `%EVAL` (arithmetic expression)

When %EVAL evaluates an arithmetic expression, it temporarily converts operands to numeric values and performs an integer arithmetic operation.
If the result of the expression is noninteger, %EVAL truncates the value to an integer. The result is expressed as text.
  %let x = %eval(5,3);
  %put x=&x
  /*result 1*/
The %EVAL function generates an error message in the log when it encounters an expression that contains noninteger values.

#### `%EVAL` (logical expression)

When %EVAL evaluates a logical expression, it returns a value of 0 to indicate that the expression is false, or a value of 1 to indicate that the expression is true.
  %let x = %eval(10 lt 2); /*10 less than 2*/
  /*The expression is false*/
  %put x=&x
  /*result 0*/
Code Challenge
Use the %EVAL function to complete the following statement and compute the final year of a range that begins with the value of firstyr and continues for the value of numyears.
     %let firstyr = 2000;
     %let numyears = 2;
     %let finalyr =...
The correct answer is:
    %let finalyr = %eval(&firstyr + &numyears - 1);
You use the %EVAL function and enclose the arithmetic expression in parentheses. You must subtract 1 from the sum of &firstyr and &numyears to correctly calculate the range of years. For example, if &firstyr is 2008 and &numyears is 3, the range includes the 3 years 2008, 2009 and 2010.

### `%SYSEVALF` function

The `%SYSEVALF` function evaluates arithmetic and logical expressions using floating-point arithmetic and returns a value that is formatted using the BEST32. format. The result of the evaluation is always text.
%SYSEVALF (expression <, conversion-type>)
You can use %SYSEVALF with an optional conversion type (BOOLEAN, CEIL, FLOOR, or INTEGER) that tailors the value returned by %SYSEVALF.
Question
What result will SAS write to the log when you submit the following statements?
   %let b=%sysevalf(10.5+20.8);
   %put 10.5+20.8 = &b;
ANSWER:
   10.5+20.8 = 30

## Using SAS Functions with Macro Variables

### `%SYSFUNC` macro function

You can use the %SYSFUNC macro function to execute SAS functions within the macro facility.
  %SYSFUNC (SAS-function(argument(s)) <, format>)
Because %SYSFUNC is a macro function, you don't enclose character values in quotation marks, as you do in SAS functions. You can specify an optional format for the value returned by the function. If you do not specify a format, numeric results are converted to a character string using the BEST12. format. SAS returns character results as they are, without formatting or translation.

You can use almost any SAS function with the %SYSFUNC macro function. The exceptions are shown in this table.

Function Type	- Function Name
Array processing	- DIM, HBOUND, LBOUND
Variable information	- VNAME, VLABEL, MISSING
Macro interface	- RESOLVE, SYMGET
Data conversion	- INPUT, PUT*
Other functions	- ORCMSG, LAG, DIF

*Use INPUTC and INPUTN in place of INPUT, and PUTC and PUTN in place of PUT.

Code Challenge
Write a statement that assigns the value of the current time to the macro variable current. Use the TIME. format for the value.
Hint: Use the TIME() function to obtain the current time.
The correct answer is
  %let current = %sysfunc(time(), time.);
You specify the keyword %LET, followed by the macro variable name. Then, you use the %SYSFUNC function to invoke the TIME function and format the result using the TIME. format.

## Using Macro Functions to Mask Special Characters

### Macro quoting functions

Macro quoting functions enable you to clearly indicate to the macro processor how it is to interpret special characters and mnemonics.

### %STR macro quoting function

The macro quoting function %STR masks (or quotes) special characters during compilation so that the macro processor does not interpret them as macro-level syntax.
  %STR (argument)
%STR can also be used to quote tokens that typically occur in pairs, such as the apostrophe, quotation marks, and open and closed parentheses. The unmatched token must be preceded by a %.
Here is a list of all of the special characters and mnemonics masked by %STR.
  + - * / < > = ¬ ^ ~ ; , # blank
  AND OR NOT EQ NE LE LT GE GT IN
  ' " ) (
Note that %STR does not mask the characters & or %.

### %NRSTR macro quoting function

`%NRSTR` masks the same characters as `%STR` and also masks the special characters & and %. Using %NRSTR instead of %STR prevents macro and macro variable resolution.
  %NSTR (argument)
Code Challenge:
Write a statement that will write the following text string to the log:
  This is the result of %NRSTR;
The correct answer is
  %put This is the result of %nrstr(%nrstr);
You specify the function %NRSTR to mask the % sign at compilation, so that the macro processor does not try to invoke %NRSTR a second time. If you did not use %NRSTR to mask the string %NRSTR, it would be interpreted as another call to the %NRSTR function, and SAS would issue a warning about a missing open parenthesis for the function.
