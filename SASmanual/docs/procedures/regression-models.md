## Interpreting the results of the `SOLUTION` option in the `MODEL` for categorical variables

In procedures that use the *GLM* parameterization for `CLASS` variables such as `PROC GLM`, `PROC MIXED` and `PROC GLIMMIX`, a predictor variable specified in the `CLASS` statement is represented in the model by a set of design variables created using *GLM* parameterization. 

This is a less than full-rank parameterization in which a `CLASS` variable with k levels is represented in the design matrix by a set of k 0,1-coded indicator (or *dummy*) variables. If the `SOLUTION` option in the `MODEL` statement is also specified, the following note is included in the displayed results below the parameter estimates table:

```
NOTE: The X'X matrix has been found to be singular, and a generalized inverse was used to solve the normal equations. Terms whose estimates are followed by the letter 'B' are not uniquely estimable.
```

Note that there are many possible parameterizations, each of which imposes a **different interpretation on the model parameters**.

!!! seealso
    * Check [this](http://support.sas.com/kb/38/384.html) for a full explanation of the interpretation of the results.
    * [Read more](http://support.sas.com/kb/22/585.html) about the *GLM* parametrization.
