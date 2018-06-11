## Penalized Regression Methods for Linear Models

### Least Absolute Shrinkage and Selection Operator (LASSO)

### Least Angle Regression (LAR)

The `LAR` algorithm starts with no predictors in the model and adds a predictor at each step. It first adds a predictor that is most correlated with the response variable and moves it towards least square estimate, until there is another predictor that is equally correlated with the model residual. It adds this predictor to the model and starts the least square estimation process over again, with both variables. The `LAR` algorithm continues with this process until it has tested all the predictors.
