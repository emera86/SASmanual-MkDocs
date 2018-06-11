## Penalized Regression Methods for Linear Models

### Least Absolute Selection Shrinkage Operator (LASSO)

Lasso regression is what is called the Penalized regression method, often used in machine learning to select the subset of variables. It is a supervised machine learning method. Specifically, `LASSO` is a **Shrinkage and Variable Selection method for linear regression models**. 

The `LASSO` algorithm **imposes a constraint on the sum of the absolute values of the model parameters**, where the sum has a specified constant as an upper bound. This constraint **causes regression coefficients for some variables to shrink towards zero** allowing for a better interpretation of the model and to identifiying the variables most strongly associated with the response variable by obtaining the subset of predictors that minimizes prediction error. 

So why use Lasso instead of just using ordinary least squares (OLS) multiple regression? 

1. It can provide **greater prediction accuracy**. If the true relationship between the response variable and the predictors is approximately linear and you have a large number of observations, then OLS regression parameter estimates will have low bias and low variance. However, if you have **a relatively small number of observations and a large number of predictors, then the variance of the OLS parameter estimates will be higher**. In this case, `LASSO` regression is useful because shrinking the regression coefficients can reduce variance without a substantial increase in bias. 
2. `LASSO` regression can **increase model interpretability**. Often times, at least **some of the explanatory variables in an OLS multiple regression analysis are not really associated with the response variable** resulting in overfitted models which are more difficult to interpret. With Lasso Regression, the **regression coefficients for unimportant variables are reduced to zero** which effectively removes them from the model and produces a simpler one. 

In Lasso Regression, a tuning parameter, $\lambda$, is included in the model to control the strength of the penalty. As $\lambda$ increases, more coefficients are reduced to zero, that is fewer predictors are selected and there is more shrinkage of the non-zero coefficient. With Lasso Regression when $\lambda=0$ we have an OLS regression analysis. Bias increases and variance decreases as $\lambda$ increases. 

Although `LASSO` regression models can handle categorical variables with more than two levels, you can also create a serie of auxiliary binary categorical varaibles in order to improve the interpretability of the selected model. Binary substitutes variables for measure with individual questions. 

### Least Angle Regression (LAR)

The `LAR` algorithm starts with no predictors in the model and adds a predictor at each step. It first adds a predictor that is most correlated with the response variable and moves it towards least square estimate, until there is another predictor that is equally correlated with the model residual. It adds this predictor to the model and starts the least square estimation process over again, with both variables. The `LAR` algorithm continues with this process until it has tested all the predictors. Parameter estimates at any step are shrunk and predictors with coefficients that are shrunk to zero are removed from the model so the process starts all over again. 

### Code Example

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
