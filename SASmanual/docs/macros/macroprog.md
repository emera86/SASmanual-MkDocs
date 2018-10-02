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

You can use parameter lists in order to update the macro variables within your macros. Each time that you call the macro, the parameter list passes values to the macro variables as part of the call, rather than by using separate `%LET` statements.

A parameter list is an optional part of the `%MACRO` statement. The list names one or more macro variables whose values you specify when you call the macro. When you call a macro, SAS automatically creates a macro variable for each parameter.

There are two types of parameters that you can use to update macro variables in your macro programs: **positional parameters** and **keyword parameters**.

#### Using Positional Parameters

To define macros that include positional parameters, you list the names of the macro variables in parentheses and separate the names using commas in the `%MACRO` statement.
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

#### Using Keyword Parameters

When you use keyword parameters, you list both the name and the value of each macro variable in the macro definition. First specify the keyword, or macro variable name, then the equal sign, and then the value.
```
%MACRO macro-name(keyword=value, ..., keyword=value);
  text
%MEND <macro-name>;
```

You can list keyword parameters in any order. Whatever value you assign to each parameter, or macro variable, in the `%MACRO` statement becomes its default value. Null values are allowed.

To call a macro that includes keyword parameters, you specify both the keyword and the value for the desired parameters, in any order. If you omit a keyword parameter from the macro call, SAS assigns the keyword parameter its default value.
```
%macro-name(keyword=value, ..., keyword=value)
```

#### Mixed Parameter Lists
You can use a parameter list that includes both positional and keyword parameters. You must list all **positional parameters in the `%MACRO` statement before any keyword parameters**.
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

## Global and Local Symbol Tables

### Global Symbol Table

The **global symbol table** is created during SAS initialization, initialized with automatic macro variables and their values, and deleted at the end of the session. The values of user-defined macro variables are often stored in the global symbol table as well.

Macro variables stored in the global symbol table are called global macro variables. To create a global macro variable, you can use a `%LET` statement anywhere in a program, except within a macro definition. You can also call the `SYMPUTX` routine in a `DATA` step or use a `SELECT` statement that contains an `INTO` clause in a `PROC SQL` step.

The `%GLOBAL` statement enables you to create one or more global macro variables. You specify the keyword `%GLOBAL`, followed by a list of the macro variables that you want to create, separated by spaces.
```
%GLOBAL macro-variable-1 ...macro-variable-n;
```

You can use the `%GLOBAL` statement anywhere in a SAS program, either inside or outside a macro definition. If the named variables do not exist in the global symbol table, SAS creates them and assigns a null value. If the macro variables already exist, then this statement does not change their values.

To delete a macro variable from the global symbol table, you use the %SYMDEL statement.
```
%SYMDEL macro-variables;
```

### Working with Local Macro Variables

SAS creates a **local symbol table** when you call a macro that includes a parameter list or when a local macro variable is created during macro execution. You should use local macro variables instead of global macro variables whenever possible. Local macro variables exist only while the macro is executing. When the macro ends, SAS deletes the local symbol table and the memory used by that table can be reused.

To create local macro variables, you can use parameters in a macro definition or you can use one of the following methods inside a macro definition: a `%LET` statement, the `SYMPUTX` routine in a `DATA` step, or a `SELECT` statement that contains an `INTO` clause in a `PROC SQL` step.

The `SYMPUTX` routine only creates a local macro variable if a local symbol table already exists. If no local symbol table exists, the `SYMPUTX` routine creates a global variable. Another way to create a local macro variable is to use the `%LOCAL` statement inside a macro definition.
```
%LOCAL macro-variable-1 ...macro-variable-n;
```

You specify the keyword, `%LOCAL`, followed by a list of the macro variables that you want to create, separated by spaces. The `%LOCAL` statement creates one or more macro variables in the local symbol table and assigns null values to them. It has no effect on variables that are already in the local table.

Because local symbol tables exist separately from the global symbol table, it is possible to have a local macro variable and a global macro variable that have the same name and different values.

You should use a local variable as the index variable for macro loops. This prevents accidental contamination of a like-named macro variable in the global symbol table or in another local table. If you define a macro program that calls another macro program, and if both macros create local symbol tables, then two local symbol tables will exist while the second macro executes.

You can use the `SYMPUTX` routine with an optional third argument, scope, in order to specify where a macro variable should be stored.
```
CALL SYMPUTX(macro-variable, value <,scope>);
```

You specify either a scope of `G` to indicate that the macro variable is to be created in the global symbol table, or a scope of `L` to indicate that the macro variable is to be created in the local symbol table. If no local symbol table exists for the current macro, then one will be created.

## Writing Utility Macros

Sometimes there are routine tasks that you need to do repeatedly. It can be useful to define a macro so that the program code for these tasks can be easily reused. To save these utility macros so that you can reuse them in the future, **you can store the compiled macro definitions in a permanent SAS catalog**.

Setting the two system options, `MSTORED` and `SASMSTORE=`, enables you to store macros in a permanent library and specifies that the macro facility will search for compiled macros in the SAS data library that is referenced by the `SASMSTORE=` option. This libref cannot be work.
```
OPTIONS MSTORED | NOMSTORED;
OPTIONS SASMSTORE=libref;
```

To create a permanently stored compiled macro, you use the `STORE` option in the `%MACRO` statement when you submit the macro definition. You can assign a descriptive title for the macro entry in the SAS catalog, by specifying the `DES=` option.
```
%MACRO macro-name <(parameter-list)> / STORE <DES='description'>;
        text
%MEND <macro-name>;
```

To access a stored compiled macro, you must set the `MSTORED` and `SASMSTORE=` system options, if they are not already set, and then simply call the macro.
```
OPTIONS MSTORED;
OPTIONS SAMSTORE=libref;
%macro-name
```
