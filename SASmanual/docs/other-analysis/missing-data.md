!!! summary "Check these websites"
    * Check out [this review](http://www.edmeasurement.net/surveydata/Tsikriktsis%202005.pdf) on techniques for treating missing data.
    * [A Conceptual Strategy and Macro Approach for Partial Date Handling in Data De-Identification](https://www.lexjansen.com/pharmasug/2018/BB/PharmaSUG-2018-BB05.pdf)

## Missing Data Mechanisms and Patterns

To use the more appropriate method to deal with your missing data, you should consider the missing data mechanism of your data which describes the process that is believed to have generated the missing values. According to [Rubin (1976)](https://doi.org/10.1093/biomet/63.3.581), there are three mechanisms under which missing data can occur:

* **Missing completely at random (MCAR)**:  neither the variables in the dataset nor the unobserved value of the variable itself predict whether a value will be missing
* **Missing at random (MAR)**: other variables (but not the variable itself) in the dataset can be used to predict missingness on a given variable
* **Missing not at random (MNAR)**: value of the unobserved variable itself predicts missingness

!!! summary "Check these websites"
    Check out the formal description of each missing mechanism in the "Missing data mechanisms" section of [this](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3701793/) paper.

## Objetives of Imputation

Depending on the **type of data and model** you will be using, techniques such as **multiple imputation** or **direct maximum likelihood** may better serve your needs. The main goals of statistical analysis with missing data are:

* Minimize bias
* Maximize use of available information
* Obtain appropriate estimates of uncertainty

Imputed values are **not** equivalent to observed values and serve only to help estimate the covariances between variables needed for inference.

![Techniques for handling missing data](https://lh3.googleusercontent.com/UnkDC9pWWIBLvrntQ85bdQyblLXlWRlnAXA-zDRJVLw_t0rBpsAyO1LBGuvEqw_-QLGk31A=s0 "Techniques for handling missing data")

Automated imputations generally fall into one of six categories: 

* Deterministic imputation 
* Model based imputation 
* Deck imputation 
* Mixed imputation 
* Expert Systems 
* Neural networks 

## Deletion procedures 

* **Complete case analysis (listwise deletion)**:  deleting cases in a particular dataset that are missing data on any variable of interest (for MCAR cases the power is reduced but it does not add any bias). It is a common technique because it is easy to implement and works with any type of analysis.
* **Available case analysis (pairwise deletion)**:  deleting cases where a variable required for a particular analysis is missing, but including those cases in analyses for which all required variables are present. One of the main drawbacks of this method is no consistent sample size because depending on the pairwise comparison examined, the sample size will change based on the amount of missing present in one or both variables. This method became popular because the loss of power due to missing information is not as substantial as with complete case analysis. Unless the mechanism of missing data is MCAR, this method will introduce bias into the parameter estimates. Therefore, this method is not recommended.

## Replacement procedures

Data replacement does not compensate for a badly designed instrument or for poor data collection. Overall, replacement procedures can be used in certain cases, as long as the researcher has a good reason for replacing.

The most important advantages of these procedures are the retention of the sample size (statistical power). To a greater or lesser extent, all replacement procedures are biased if there is a non-random distribution of missing values. In assessing the effectiveness of these procedures, both the accuracy of estimating the value of missing data and the accuracy of estimating the statistical effects have to be considered.

Many different missing data replacement procedures have been developed over the years. In general, the differences between the various methods decrease with: (a) larger sample size, (b) a smaller percentage of missing values, (c) fewer missing variables and (d) a decrease in the level of the correlations between the variables. 

### Single Imputation Methods

Single imputation denotes that the missing value is replaced by a value. However, the imputed values are assumed to be the real values that would have been observed when the data would have been complete. When we have missing data, this is never the case. We can **never be completely certain about imputed values**. 

* **Unconditional Mean Imputation / Mean Substitution**: replacing the missing values for an individual variable wih it's overall estimated mean from the available cases. Its more important problem is that it will result in an artificial reduction in variability due to the fact you are imputing values at the center of the variable's distribution. This also has the unintended consequence of changing the magnitude of correlations between the imputed variable and other variables.
* **Regression Imputation**: This is a two-step approach: first, the relationships among variables are estimated, and then the regression coefficients are used to estimate the missing value. The underlying assumption of regression imputation is the existence of a linear relationship between the predictors and the missing variable. The technique also assumes that values are missing at random (i.e., a missing value is not related to the value of the predictors).
    * **Stochastic Regression Imputation**: In recognition of the problems with regression imputation and the reduced variability associated with this approach, researchers developed a technique to incorporate or “add back” lost variability. A residual term, that is randomly drawn from a normal distribution with mean zero and variance equal to the residual variance from the regression model, is added to the predicted scores from the regression imputation thus restoring some of the lost variability. This method is superior to the previous methods as it will produce unbiased coefficient estimates under MAR. However, the standard errors produced during regression estimation while less biased then the single imputation approach, will still be attenuated.
    
![Deterministic vs Stochastic](https://lh3.googleusercontent.com/Wq-bz7LPVnRFzrlZkc0e79P9aGM3AwjD0JxZTKpU7eE74NkRpUaeeBlmhaK-AnVQHHB793c=s0 "Deterministic vs Stochastic")

*The deterministic imputations are exactly at the regression predictions and ignore predictive uncertainty. In contrast, the random imputations are more variable and better capture the range of the data.*

* **Hot-deck Imputation**: According to this technique, the researcher should replace a missing value with the actual score from a similar case in the dataset. One form of hot-deck imputation is called "last observation carried forward" (LOCF), which involves sorting a dataset according to any of a number of variables, thus creating an ordered dataset. The technique then finds the first missing value and uses the cell value immediately prior to the data that are missing to impute the missing value. This method is known to increase risk of increasing bias and potentially false conclusions. For this reason LOCF is not recommended for use.
* **Cold-deck Imputation**: This method replaces a missing value of an item with a constant value from an external source such as a value from a previous survey.

* **Single Imputation**:


### Multiple imputation

!!! summary "Check these websites"
    Visit [this website](http://lnr.li/YdyXo) for more information.

[*Bayesian Methods for Completing Data*](http://www.bias-project.org.uk/Missing2012/Lectures.pdf) are simply methods based on conditional probability.

Multiple Imputation is always superior to any of the single imputation methods because:

* A single imputed value is never used
* The variance estimates reflect the appropriate amount of uncertainty surrounding parameter estimates

There are several decisions to be made before performing a multiple imputation including **distribution**, **auxiliary variables** and **number of imputations** that can affect the quality of the imputation.

1. **Imputation phase (`PROC MI`)**:  the user specifies the imputation model to be used and the number of imputed datasets to be created
2. **Analysis phase (`PROG GLM`/`PROC GENMOD`)**: runs the analytic model of interest within each of the imputed datasets
3. **Pooling phase (`PROC MIANALYZE`)**: combines all the estimates across all the imputed datasets and outputs one set of parameter estimates for the model of interest

#### `MVN` vs `FCS`


#### Auxiliary variables

* They can can help improve the likelihood of meeting the MAR assumption 
* They help yield more accurate and stable estimates and thus reduce the estimated standard errors in analytic models 
*  Including them can also help to increase power

#### Number of imputations (m)

* Estimates of coefficients stabilize at much lower values of *m* than estimates of variances and covariances of error terms 
* A larger number of imputations may also allow hypothesis tests with less restrictive assumptions (i.e., that do not assume equal fractions of missing information for all coefficients)
* Multiple runs of m imputations are recommended to assess the stability of the parameter estimates
*  Recommendations: 
 *  For low fractions of missing information (and relatively simple analysis techniques) 5-20 imputations and 50 or more when the proportion of missing data is relatively high
 *  The number of imputations should equal the percentage of incomplete cases (*m*=max(FMI%)), this way the error associated with estimating the regression coefficients, standard errors and the resulting p-values is considerably reduced and results in an adequate level of reproducibility

#### More comments

* You should include the dependent variable (DV) in the imputation model unless you would like to impute independent variables (IVs) assuming they are uncorrelated with your DV
* Although MI can perform well up to 50% missing observations,  the larger the amount the higher the chance of finding estimation problems during the imputation process and the lower the chance of meeting the MAR assumption

## Model-based Procedures

### Direct Maximum Likelihood
This approach to analyzing missing data has many different forms. In its simplest form, it assumes that the observed data are a sample drawn from a multivariate normal distribution. The parameters are estimated by available data, and then missing scores are estimated based on the parameters just estimated. Contrary to the techniques discussed above, maximum likelihood procedures allow explicit modeling of missing data that is open to scientific analysis and critique. 

### Expectation Maximization 
This algorithm is an iterative process. The first iteration estimates missing data and then parameters using maximum likelihood. The second iteration re-estimates the missing data based on the new parameter estimates and then recalculates the new parameters estimates
based on actual and re-estimated missing data. The approach continues until there is convergence in the parameter estimates.

## Summary

The best technique to deal with your missing data depends on:

 1. The amount of missing data (what percentage of data is missing)
 2. Type of missing data (MAR, MCAR, NMAR)

According to [this nice review](http://www.edmeasurement.net/surveydata/Tsikriktsis%202005.pdf), if more than 10% data is missing, the best solution is:

* Maximum likelihood imputation if data are NMAR (non-missing at random)
* Maximum likelihood and hot-deck if data are MAR (missing at random)
* Pairwise deletion, hot-deck or regression if data are MCAR (missing completely at random)

Moreover, **multiple imputation** by chained equations is regarded the best imputation method by many researchers.
