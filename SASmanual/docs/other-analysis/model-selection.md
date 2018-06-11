## Penalized Regression Methods for Linear Models

### Least Absolute Selection Shrinkage Operator (LASSO)
Lasso regression is what is called the Penalized regression method, often used in machine learning to select the subset of variables. It is a supervised machine learning method. Specifically, `LASSO` is a **Shrinkage and Variable Selection method for linear regression models**. 

The `LASSO` algorithm **imposes a constraint on the sum of the absolute values of the model parameters**, where the sum has a specified constant as an upper bound. This constraint **causes regression coefficients for some variables to shrink towards zero** allowing for a better interpretation of the model and to identifiying the variables most strongly associated with the response variable by obtaining the subset of predictors that minimizes prediction error. 

So why use Lasso instead of just using ordinary least squares (OLS) multiple regression? 

1. It can provide **greater prediction accuracy**. If the true relationship between the response variable and the predictors is approximately linear and you have a large number of observations, then OLS regression parameter estimates will have low bias and low variance. However, if you have **a relatively small number of observations and a large number of predictors, then the variance of the OLS parameter estimates will be higher**. In this case, `LASSO` regression is useful because shrinking the regression coefficients can reduce variance without a substantial increase in bias. 
2. `LASSO` regression can **increase model interpretability**. Often times, at least **some of the explanatory variables in an OLS multiple regression analysis are not really associated with the response variable** resulting in overfitted models which are more difficult to interpret. With Lasso Regression, the **regression coefficients for unimportant variables are reduced to zero** which effectively removes them from the model and produces a simpler one. 

In Lasso Regression, a tuning parameter, $\lambda$, is included in the model to control the strength of the penalty. As $\lambda$ increases, more coefficients are reduced to zero, that is fewer predictors are selected and there is more shrinkage of the non-zero coefficient. With Lasso Regression when $\lambda=0$ we have an OLS regression analysis. Bias increases and variance decreases as $\lambda$ increases. 

Although Lasso Regression models can handle categorical variables with more than two levels, you can also create a serie of auxiliary binary categorical varaibles in order to improve the interpretability of the selected model. Binary substitutes variables for measure with individual questions. 

### Least Angle Regression (LAR)

The `LAR` algorithm starts with no predictors in the model and adds a predictor at each step. It first adds a predictor that is most correlated with the response variable and moves it towards least square estimate, until there is another predictor that is equally correlated with the model residual. It adds this predictor to the model and starts the least square estimation process over again, with both variables. The `LAR` algorithm continues with this process until it has tested all the predictors.

### Code Example

```
* LASSO multiple regression with LARS algorithm k=10 fold validation;
PROG GLMSELECT DATA=SAS-data-set PLOTS=ALL SEED=12345;
  PARTITION ROLE=SELECTED(train='1' test='0');
  MODEL response = predictor1 predictor2 ... predictorN / SELECTION = LAR(CHOOSE=CV STOP=NONE) CVMETHOD=RANDOM(10);
RUN;
```

### `LASSO` Regression Limitations
