## Writing Utility Macros

Sometimes there are routine tasks that you need to do repeatedly. It can be useful to define a macro so that the program code for these tasks can be easily reused.
To save these utility macros so that you can reuse them in the future, you can store the compiled macro definitions in a permanent SAS catalog.
Setting the two system options, MSTORED and SASMSTORE=, enables you to store macros in a permanent library and specifies that the macro facility will search for compiled macros in the SAS data library that is referenced by the SASMSTORE= option. This libref cannot be work.
OPTIONS MSTORED | NOMSTORED;
OPTIONS SAMSTORE=libref;
To create a permanently stored compiled macro, you use the STORE option in the %MACRO statement when you submit the macro definition. You can assign a descriptive title for the macro entry in the SAS catalog, by specifying the DES= option.
%MACRO macro-name <(parameter-list)> / STORE <DES='description'>;
        text
%MEND <macro-name>;
To access a stored compiled macro, you must set the MSTORED and SASMSTORE= system options, if they are not already set, and then simply call the macro.
OPTIONS MSTORED;
OPTIONS SAMSTORE=libref;
%macro-name

## Minimizing Errors in Your Macros

You should use a five-step approach to developing macro programs that generate SAS code. This approach will streamline your development and debugging process:
Write and debug the SAS program without macro coding.
Generalize by replacing hardcoded values with macro variable references.
Create a macro definition with macro parameters.
Add macro-level programming for conditional and iterative processing.
Add data-driven customization.
There are several system options that are useful for macro debugging:
Option	Description
MCOMPILENOTE	issues a note to the SAS log after a macro completes compilation
MLOGIC	writes messages that trace macro execution to the SAS log
MPRINT	specifies that the text that is sent to the compiler when a macro executes is printed in the SAS log
SYMBOLGEN	displays the values of macro variables as they resolve
Your macros might benefit from comments. Comments can be especially helpful if you plan to save your macros permanently or share them with other users.
%* comment;
To use the macro comment statement, specify the percent sign, followed by an asterisk and then your comment. The comment can be any text. Like other SAS statements, each macro comment statement ends with a semicolon.
You can also use the comment symbols / * and * / inside a macro. When these symbols appear, the macro processor ignores the text within the comment.
