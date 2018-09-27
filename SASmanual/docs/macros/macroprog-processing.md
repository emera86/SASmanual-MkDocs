## Processing Statements Conditionally

You can use `%IF-%THEN` and `%ELSE` statements to perform conditional processing in a macro program.
```
%IF expression %THEN text;
<%ELSE text;>
```

You specify the keyword `%IF` followed by an expression. The expression can be any valid macro expression that resolves to an integer. Then, you specify the keyword `%THEN` followed by some text. The text can be a SAS constant, a text expression, a macro variable reference, a macro call, or a macro program statement. The `%ELSE` statement is optional. The text in a `%ELSE` statement can also be a SAS constant, a text expression, a macro variable reference, a macro call, or a macro program statement.

If the expression following `%IF` **resolves to zero**, the expression is false and the `%THEN` text isn't processed. If you include an optional `%ELSE` statement, that text is processed instead of the `%THEN` text. If the expression **resolves to any integer other than zero**, then the expression is true and the `%THEN` text is processed. If the expression **resolves to null or to any noninteger value**, SAS issues an error message.

There are several important differences between the macro `%IF-%THEN` statement and the `DATA` step `IF-THEN` statement.

| `%IF-%THEN` | `IF-THEN` |
|---|---|
| Is used only in a macro program | Is used only in a `DATA` step program | 
| Executes during macro execution | Executes during `DATA` step execution | 
| Uses macro variables in logical expressions and cannot refer to `DATA` step variables in logical expressions | Uses `DATA` step variables in logical expressions| 
| Determines what text should be copied to the input stack | Determines what `DATA` step statement(s) should be executed | 
 
Macro expressions are similar to SAS expressions in the following ways:

* They use the same arithmetic, logical, and comparison operators as SAS expressions
* They are case sensitive
* Special `WHERE` operators are not valid

Macro expressions are dissimilar to SAS expressions in the following ways:

* Character operands are not quoted
* Expressions in which comparison operators surround a macro expression might resolve with unexpected results

You can use `%DO` and `%END` statements along with a `%IF-%THEN` statement to generate code that contains semicolons.
```
%IF expression %THEN %DO;
           text and/or macro language elements;
%END;
%ELSE %DO;
           text and/or macro language elements;
%END;
```

The syntax for using `%DO` and `%END` statements with a `%IF-%THEN` statement is shown here. The keyword `%DO` follows the keyword `%THEN`. You must pair each `%DO` statement with a `%END` statement. Between the `%DO` and the `%END` keywords, you insert one or more statements that contain constant text, text expressions, or macro statements.

## Using Conditional Processing to Validate Parameters: the `IN` operator

You can use the comparison operator `IN` to search for character and numeric values that are equal to one from a list of values. You can also use the `IN` operator when you evaluate arithmetic or logical expressions during macro execution.
```
%MACRO macro-name <(parameter-list) ></MINOPERATOR | NOMINOPERATOR;
```

To use the macro `IN` operator, you use the `MINOPERATOR` option with the `%MACRO` statement, preceded by a slash. Then you can use the macro `IN` operator to modify the `%IF` statement. The macro `IN` operator is similar to the SAS `IN` operator, but it doesn't require parentheses.

If you use `NOT` with the `IN` operator, `NOT` must precede the `IN` expression and parentheses are required around the expression.
You can use the `PROC SQL INTO` clause with the `SEPARATED BY` argument to create a macro variable that contains a list of unique values. You can combine `PROC SQL` with conditional processing to validate the parameters in a macro.

## Processing Statements Iteratively: the `%DO` statement

With the iterative `%DO` statement, you can repeatedly execute macro programming code and generate SAS code.
```
%DO index-variable=start %TO stop <%BY increment>;
           text and/or macro language elements;
%END;
```

* The values for `start`, `stop`, and `increment` must be integers or macro expressions that resolve to integer values.
* The `%BY` clause is optional. Increment specifies either an integer (other than 0) or a macro expression that generates an integer to be added to the value of the index variable in each iteration of the loop. By default, the increment is 1.
* A `%END` statement ends the iterative loop. 

!!! warning
    `%DO` and `%END` statements are valid **only inside a macro definition**.

### Generating Repetitive Pieces of Text Using `%DO` Loops

To generate repetitive pieces of text, use an iterative `%DO` loop. For example, the following macro, `NAMES`, uses an iterative `%DO` loop to create a series of names to be used in a `DATA` statement:

```
%macro names(name= ,number= );
   %do n=1 %to &number;
      &name&n
   %end;
%mend names;
```

The macro `NAMES` creates a series of names by concatenating the value of the parameter `NAME` and the value of the macro variable `N`. You supply the stopping value for `N` as the value of the parameter `NUMBER`, as in the following `DATA` statement:

```
data %names(name=dsn,number=5);
```

Submitting this statement produces the following complete `DATA` statement:

```
data dsn1 dsn2 dsn3 dsn4 dsn5;
```
