!!! note "Check these websites"
    * [The GLMSELECT Procedure](https://support.sas.com/documentation/onlinedoc/stat/141/glmselect.pdf)
    * [Introducing the GLMSELECT Procedure for Model Selection](http://www2.sas.com/proceedings/sugi31/207-31.pdf)
    * [Penalized Regression Methods for Linear Models in SAS](https://support.sas.com/rnd/app/stat/papers/2015/PenalizedRegression_LinearModels.pdf)

## Traditional Model Selection Algoritms

The `GLMSELECT` procedure extends the familiar forward, backward, and stepwise methods as implemented in the `REG` procedure to GLM-type models. Quite simply, `FORWARD` selection adds parameters one at a time, `BACKWARD` elimination deletes them, and `STEPWISE` selection switches between adding and deleting them.

### Forward Method (`FORWARD`)

It is important to keep in mind that forward selection bases the decision about what effect to add at any step by considering models that **differ by one effect from the current model**. This search paradigm cannot guarantee reaching a "best" subset model. Furthermore, **the add decision is greedy** in the sense that the effect deemed most significant is the effect that is added. However, if your goal is to find a model that is best in terms of some selection criterion other than the significance level of the entering effect, then even this one step choice might not be optimal. For example, the effect you would add to get a model with the smallest value of the `PRESS` statistic at the next step is not necessarily the same effect that has the most significant entry `F` statistic. 

Note that in the case where all effects are variables (that is, effects with one degree of freedom and no hierarchy), using `ADJRSQ`, `AIC`, `AICC`, `BIC`, `CP`, `RSQUARE`, or `SBC` as the selection criterion for forward selection produces the same sequence of additions. However, if the degrees of freedom contributed by different effects are not constant, or if an out-of-sample prediction-based criterion is used, then different sequences of additions might be obtained.

### Backward Method (`BACKWARD`)

The backward elimination technique starts from the full model including all independent effects. Then effects are deleted one by one until a stopping condition is satisfied. At each step, the effect showing the smallest contribution to the model is deleted. In traditional implementations of backward elimination, the contribution of an effect to the model is assessed by using an `F` statistic. At any step, the predictor producing the least significant `F` statistic is dropped and the process continues until all effects remaining in the model have `F` statistics significant at a stay significance level (`SLS`).

### Stepwise Method (`STEPWISE`)

In the traditional implementation of stepwise selection method, the same entry and removal F statistics for the forward selection and backward elimination methods are used to assess contributions of effects as they are added to or removed from a model. If at a step of the stepwise method, any effect in the model is not significant at the SLSTAY= level, then the least significant of these effects is removed from the model and the algorithm proceeds to the next step. This ensures that no effect can be added to a model while some effect currently in the model is not deemed significant. Only after all necessary deletions have been accomplished can another effect be added to the model.

For selection criteria other than significance level, `PROC GLMSELECT` optionally supports a further modification in the stepwise method. In the standard stepwise method, no effect can enter the model if removing any effect currently in the model would yield an improved value of the selection criterion. In the modification, you can use the `DROP=COMPETITIVE` option to specify that addition and deletion of effects should be treated competitively. The selection criterion is evaluated for all models obtained by deleting an effect from the current model or by adding an effect to this model. The action that most improves the selection criterion is the action taken.

### Code Examples

```
selection=forward
```
adds effects that at each step give the lowest value of the SBC statistic and stops at the step where adding any
effect would increase the SBC statistic.

```
selection=forward(select=SL)
```
adds effects based on significance level and stops when all candidate effects for entry at a step have a
significance level greater than the default entry significance level of 0.50.

```
selection=forward(select=ADJRSQ stop=SL SLE=0.2)
```
adds effects that at each step give the largest value of the adjusted R-square statistic and stops at the step
where the significance level corresponding to the addition of this effect is greater than 0.2.

```
selection=forward(select=SL stop=AIC)
```
terminates at the step where the effect to be added at the next step would produce a model with an `AIC` statistic larger than the `AIC` statistic of the current model.

Provided that the entry significance level is large enough that the local extremum of the named criterion occurs before the final step, specifying any of these options the same model is selected, but more steps are done in the second case:
```
selection=forward(select=SL choose=CRITERION)
selection=forward(select=SL stop=CRITERION)
```

In some cases there might be a better local extremum that cannot be reached if you specify the `STOP=` option but can be found if you use the `CHOOSE=` option. Also, you can use the `CHOOSE=` option in preference to the `STOP=` option if you want examine how the named criterion behaves as you move beyond the step where the first local minimum of this criterion occurs.

Note that you can specify both the `CHOOSE=` and `STOP=` options. You might want to consider models generated by forward selection that have at most some fixed number of effects but select from within this set based on a criterion you specify. The following example requests that forward selection continue until there are 20 effects in the final model and chooses among the sequence of models the one that has the largest value of the adjusted R-square statistic. 
```
selection=forward(stop=20 choose=ADJRSQ)
```

You can also combine these options to select a model where one of two conditions is met. The following example chooses whatever occurs first between a local minimum of the predicted residual sum of squares (`PRESS`) and a local minimum of corrected Akaike’s information criterion (`AICC`).
```
selection=forward(stop=AICC choose=PRESS)
```

`PROC GLMSELECT` enables you to specify the criterion to optimize at each step by using the `SELECT=` option. For example, the following example requests that at each step the effect that is added be the one that gives a model with the smallest value of the  Mallows’ $C_p$ statistic.
```
selection=forward(select=CP)
```

You can use `SELECT=` together with `CHOOSE=` and `STOP=`. If you specify only the `SELECT=` criterion, then this criterion is also used as the stopping criterion. In the previous example where only the selection criterion is specified, not only do effects enter based on the Mallows’ $C_p$ statistic, but the selection terminates when the $C_p$ statistic first increases.

```
selection=backward
```
removes effects that at each step produce the largest value of the Schwarz Bayesian information criterion (`SBC`) statistic and stops at the step where removing any effect increases the `SBC` statistic.

```
selection=backward(stop=press)
```

removes effects based on the `SBC` statistic and stops at the step where removing any effect increases the predicted residual sum of squares (`PRESS`).

```
selection=backward(select=SL)
```
removes effects based on significance level and stops when all candidate effects for removal at a step have a significance level less than the default stay significance level of 0.10.

```
selection=backward(select=SL choose=validate SLS=0.1)
```
removes effects based on significance level and stops when all effects in the model are significant at the 0.1 level. Finally, from the sequence of models generated, choose the one that gives the smallest average square error when scored on the validation data.

## Penalized Regression Methods for Linear Models

### Least Absolute Selection Shrinkage Operator (`LASSO`)

Lasso regression is what is called the Penalized regression method, often used in machine learning to select the subset of variables. It is a supervised machine learning method. Specifically, `LASSO` is a **Shrinkage and Variable Selection method for linear regression models**. 

The `LASSO` algorithm **imposes a constraint on the sum of the absolute values of the model parameters**, where the sum has a specified constant as an upper bound. This constraint **causes regression coefficients for some variables to shrink towards zero** allowing for a better interpretation of the model and to identifiying the variables most strongly associated with the response variable by obtaining the subset of predictors that minimizes prediction error. 

So why use Lasso instead of just using ordinary least squares (OLS) multiple regression? 

1. It can provide **greater prediction accuracy**. If the true relationship between the response variable and the predictors is approximately linear and you have a large number of observations, then OLS regression parameter estimates will have low bias and low variance. However, if you have **a relatively small number of observations and a large number of predictors, then the variance of the OLS parameter estimates will be higher**. In this case, `LASSO` regression is useful because shrinking the regression coefficients can reduce variance without a substantial increase in bias. 
2. `LASSO` regression can **increase model interpretability**. Often times, at least **some of the explanatory variables in an OLS multiple regression analysis are not really associated with the response variable** resulting in overfitted models which are more difficult to interpret. With Lasso Regression, the **regression coefficients for unimportant variables are reduced to zero** which effectively removes them from the model and produces a simpler one. 

In Lasso Regression, a tuning parameter, $\lambda$, is included in the model to control the strength of the penalty. As $\lambda$ increases, more coefficients are reduced to zero, that is fewer predictors are selected and there is more shrinkage of the non-zero coefficient. With Lasso Regression when $\lambda=0$ we have an OLS regression analysis. Bias increases and variance decreases as $\lambda$ increases. 

Although `LASSO` regression models can handle categorical variables with more than two levels, you can also create a serie of auxiliary binary categorical varaibles in order to improve the interpretability of the selected model. Binary substitutes variables for measure with individual questions. 

### Least Angle Regression (`LAR`)

The `LAR` algorithm starts with no predictors in the model and adds a predictor at each step. It first adds a predictor that is most correlated with the response variable and moves it towards least square estimate, until there is another predictor that is equally correlated with the model residual. It adds this predictor to the model and starts the least square estimation process over again, with both variables. The `LAR` algorithm continues with this process until it has tested all the predictors. Parameter estimates at any step are shrunk and predictors with coefficients that are shrunk to zero are removed from the model so the process starts all over again. 

### Code Examples

```
* LASSO multiple regression with LARS algorithm k=10 fold validation;
PROG GLMSELECT DATA=SAS-data-set PLOTS=ALL SEED=12345;
  PARTITION ROLE=selected(train='1' test='0');
  MODEL response=predictor1 predictor2 ... predictorN / SELECTION=LAR(CHOOSE=CV STOP=NONE) CVMETHOD=RANDOM(10);
RUN;
```

* The `PARTITION` statement assigns each observation a role, based on the variable called selected, to indicate whether the observation is a training or test observation. 

* After the slash of the `MODEL` statement, we specify the options we want to use to test the model. 
    * The `SELECTION` option tells us which method to use to compute the parameters for variable selection (`LAR` algorithm in this example). 
    * The `CHOOSE=CV` option, asks SAS to use cross validation to choose the final statistical model. 
    * `STOP=NONE` ensures that the model doesn't stop running until each of the candidate predictor variables is tested. 
    * `CVMETHOD=RANDOM(10)`, specifies that a K-fold cross-validation method with ten randomly selected folds will be used. 

The model with the lowest average means square error is selected by SAS as the best model. 

!!! tip
    In `LASSO` regression, the penalty term is not fair if the predictive variables are not on the same scale. Meaning that not all the predictors will get the same penalty. The SAS `GLMSELECT` procedure handles this by automatically standardizing the predictor variables, so that they all have a mean equal to zero and a standard deviation equal to one, which places them all on the same scale. 

### `LASSO` Regression Limitations

As with any statistical methods, the `LASSO` regression has some limitations. 

1. Selection of variables is 100% statistically driven. The `LASSO` selection process does not think like a human being, who take into account theory and other factors in deciding which predictors to include. There might be a good rational for including a predictor, even if it appears to have no association with response variable. 
2. If **predictors are strongly correlated with each other, the Lasso will arbitrarily select one of them**. You may have different ideas about which of the predictors you would choose include or whether it's important to keep more than one. 
3. Estimating **p-values for `LASSO` regression is not so straightforward**, although methods to calculate p-values have been developed. 
4. Different selection methods and even different software packages can produce different results. 
5. There's no guarantee that the model selected by the `LASSO` regression will not be overfitted or the best model. 

If you find yourself in a position which you have a large number of potential predictors of a response variable, what do you do? The best solution may be **a combination of machine learning, human intervention, and independent application**. 

## Model Selection Algorithms Pros and Cons

Note that while the model selection question seems reasonable, trying to answer it for real data can lead to problematic pitfalls, including

* The selected model is not guaranteed to be the "best"; there may be other, more parsimonious or more intuitively reasonable models that may provide nearly as good or even better models, but which the particular heuristic method employed does not find
* Model selection may be unduly affected by outliers
* There is a "selection bias" because a parameter is more likely to be selected if it is above its expected value than if it is below its expected value
* Standard methods of inference for the final model are invalid in the model selection context

However, certain features of `GLMSELECT`, in particular the procedure’s [extensive capabilities for customizing the selection and its flexibility and power in specifying complex potential effects](http://www2.sas.com/proceedings/sugi31/207-31.pdf), can partially mitigate these problems.

