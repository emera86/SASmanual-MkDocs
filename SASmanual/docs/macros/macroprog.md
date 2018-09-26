## Basic Concepts

Macros are compiled programs that you can execute independently or call as part of a SAS program. Like macro variables, you generally use macros to generate text. But, macros provide additional capabilities. Macros can contain programming statements that enable you to control how and when the text is generated. Also, macros can accept parameters that specify variables. Using parameters, you can write generic macros that can serve a number of uses.

A SAS program can reference any number of macros, and you can invoke a macro any number of times within a single SAS program. There are three steps to create and use a macro: **define** the macro, **compile** the macro, and **call** the macro.

### Define a Macro

A macro definition is the container that holds a macro program. You begin a macro definition with a `%MACRO` statement and end it with a `%MEND` statement.
```
%MACRO macro-name;
  text
%MEND <macro-name>;
```
Each macro that you define has a distinct name. Choose a name for your macro that indicates what the macro does and follow standard SAS naming conventions. Avoid SAS language keywords or call routine names, as well as words that are reserved by the SAS macro facility. You are not required to include the macro name in the `%MEND` statement. But if you do, be sure that the two macro names match.

The text can include constant text, SAS data set names, SAS variable names, and SAS statements. It can also include macro variables (`&country`), macro functions (`%sysfunc()`), macro program statements (`%put sysdate=&sysdate;`) and any combination of the above.

### Compile a Macro  

To compile a macro, submit the code. If the macro processor finds syntax errors in the macro language statements, it writes any error messages to the SAS log and creates a dummy, non-executable macro.

If the macro processor does not find any macro-level syntax errors, it compiles the macro and stores the compiled definition in a temporary SAS catalog named `Work.Sasmacr`. Macros in this catalog are known as **session-compiled** macros and are available for execution during the SAS session in which they're compiled. SAS deletes the temporary catalog that stores the macros at the end of the session.

### Call a Macro  

To call a macro, precede the name of the macro with a percent sign anywhere in a program, except within the data lines of a `DATALINES` statement. The macro call requires no semicolon because it is not a SAS statement.
```
%macro-name
```

When you call a macro, the word scanner passes the macro call to the macro processor. The macro processor searches `Work.Sasmacr` for that macro. Then it executes compiled macro language statements within the macro and sends any remaining text to the input stack. When the SAS compiler receives a global SAS statement or encounters a SAS step boundary, the macro processor suspends macro execution. After the SAS code executes, the macro processor resumes execution of macro language statements. The macro processor ends execution when it reaches the `%MEND` statement.

## Using Macro Parameters

### Using Parameters in the Macro Definition

You can use parameter lists in order to update the macro variables within your macros. Each time that you call the macro, the parameter list passes values to the macro variables as part of the call, rather than by using separate %LET statements.
A parameter list is an optional part of the %MACRO statement. The list names one or more macro variables whose values you specify when you call the macro. When you call a macro, SAS automatically creates a macro variable for each parameter.
There are two types of parameters that you can use to update macro variables in your macro programs: positional parameters and keyword parameters.

#### Using Positional Parameters

To define macros that include positional parameters, you list the names of the macro variables in parentheses and separate the names using commas in the %MACRO statement.
```
%MACRO macro-name(parameter-1 <, ...parameter-n>);
  text
%MEND <macro-name>;
```
To call a macro that includes positional parameters, you precede the name of the macro with a percent sign and enclose the parameter values in parentheses. You must specify the values in the same order as in the macro definition and separate them with commas.
```
%macro-name(value-1 <, ...value-n>)
```
The values listed in a macro call can be text, macro variable references, macro calls, or null values. SAS assigns these values to the parameters using a one-to-one correspondence.
Example:
```
  /*define a macro*/
  %macro prtlast(dns,vars);
    proc print data=&dns;
      var = &vars;
    run;
  %mend;

  /* call a  macro */
  %prtlast(orion.city, City_Name Country)
```

Code Challenge:
Write a call to invoke the macro that is defined here. Use a macro parameter to specify that the macro variable crsnum should have a value of 9.
  %macro prtstus(crsnum);
    proc print data=sasuser.all;
      var student_name;
      where course_number=&crsnum;
    run;
  %mend;
Write a call:
  ...
The correct answer is
  %prtstus(9)
First, specify the name of the macro program, preceded by a percent sign. Then specify the value for the parameter in parentheses after the macro program name.

#### Using Keyword Parameters

When you use keyword parameters, you list both the name and the value of each macro variable in the macro definition. First specify the keyword, or macro variable name, then the equal sign, and then the value.
```
%MACRO macro-name(keyword=value, ..., keyword=value);
  text
%MEND <macro-name>;
```

You can list keyword parameters in any order. Whatever value you assign to each parameter, or macro variable, in the %MACRO statement becomes its default value. Null values are allowed.

To call a macro that includes keyword parameters, you specify both the keyword and the value for the desired parameters, in any order. If you omit a keyword parameter from the macro call, SAS assigns the keyword parameter its default value.
```
%macro-name(keyword=value, ..., keyword=value)
```

Example:
```
  /*define a macro*/

  /* specify the default values of the dsn and vars macro variables*/
  %macro prtlast(dns=orion.city, vars=City_Name Country);
    proc print data=&dns;
      var = &vars;
    run;
  %mend;

  /* call a  macro */

  /*To assign the defaults for both parameters, you invoke the macro with empty parentheses*/
  %prtlast()

  /*To assign new values, you specify the keyword, and then an equal sign, followed by the value.*/
  dns=work.city, City_Name)
```

#### Mixed Parameter Lists
You can use a parameter list that includes both positional and keyword parameters. You must list all positional parameters in the %MACRO statement before any keyword parameters.
```
%MACRO macro-name(parameter-1<, ...parameter-n>
                  keyword=value, ..., keyword=value);
    text
%MEND <macro-name>;
```

Similarly, when you call a macro that includes a mixed parameter list, you must list the positional values before any keyword values.
```
%macro-name(value-1<, ...value-n>,
                        keyword=value, ..., keyword=value);
```

Example:
If you know that the value for the macro variable dsn is likely to be different every time that you call the macro, it probably makes sense to use a positional parameter for this value. On the other hand, if the values for the macro variable vars are likely to be the same, it makes sense to use a keyword parameter to set a default value for this item.

```
  /*define a macro*/

  /* specify the default values only for vars macro variable*/
  %macro prtlast(dns, vars=City_Name Country);
    proc print data=&dns;
      var = &vars;
    run;
  %mend;

  /* call a  macro */
  /*specify a value for the positional parameter - dsn, and omit the keyword parameter - vars. Because this call omits the keyword parameter vars, SAS will use the default value for that parameter.*/
  %prtlast(orion.city)

  /*To assign new values, you specify the keyword, and then an equal sign, followed by the value.*/
  dns=work.city, City_Name)
```

Code Challenge:
Review the macro definition for the macro attend.
Issue a call to invoke the attend macro. In the call, specify nocum as a value for Opts, a start date of 01jan2002, and a stop date of 31oct2002.
  %macro attend(opts,start=01jan2001,stop=31dec2001);
    %let start=%upcase(&start);
    %let stop=%upcase(&stop);
    proc freq data=sasuser.all;
      where begin_date between "&start"d and "&stop"d;
      table location / &opts;
      title1 "Enrollment from &start to &stop";
    run;
  %mend;
Write a call:
  ...
The correct answer is
  %attend(nocum, start=01jan2002, stop=31oct2002)
or
  %attend(nocum, stop=31oct2002, start=01jan2002)
Specify the macro name preceded by a percent sign, followed by the values for the parameters. Separate the values by commas and enclose them in parentheses. List the positional parameter value first.
