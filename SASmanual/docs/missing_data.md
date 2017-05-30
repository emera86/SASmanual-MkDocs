Check out [this review](http://www.edmeasurement.net/surveydata/Tsikriktsis%202005.pdf) on techniques for trating missing data.

## Missing Data Mechanisms and Patterns

To use the more appropriate method to deal with your missing data, you should consider the missing data mechanism of your data which describes the process that is believed to have generated the missing values:

* **Missing completely at random (MCAR)**:  neither the variables in the dataset nor the unobserved value of the variable itself predict whether a value will be missing
* **Missing at random (MAR)**: other variables (but not the variable itself) in the dataset can be used to predict missingness on a given variable
* **Missing not at random (MNAR)**: value of the unobserved variable itself predicts missingness

![Techniques for handling missing data](https://lh3.googleusercontent.com/Jgkhmjq9f7LyBBjp6ujj0jCRJc4UQDoe162bzfwHAWwbh5j3l9qbwcEIxX6YkTyMsbOiTyQ=s0 "Techniques for handling missing data")

## Deletion procedures 

* **Complete case analysis (listwise deletion)**:  deleting cases in a particular dataset that are missing data on any variable of interest (for MCAR cases the power is reduced but it does not add any bias). It is a common technique because it is easy to implement and works with any type of analysis.
* **Available case analysis (pairwise deletion)**:  deleting cases where a variable required for a particular analysis is missing, but including those cases in analyses for which all required variables are present. One of the main drawbacks of this method is no consistent sample size because depending on the pairwise comparison examined, the sample size will change based on the amount of missing present in one or both variables. This method became popular because the loss of power due to missing information is not as substantial as with complete case analysis. Unless the mechanism of missing data is MCAR, this method will introduce bias into the parameter estimates. Therefore, this method is not recommended.

## Replacement procedures

### Objetives of Imputation

Depending on the **type of data and model** you will be using, techniques such as **multiple imputation** or **direct maximum likelihood** may better serve your needs. The main goals of statistical analysis with missing data are:

* Minimize bias
* Maximize use of available information
* Obtain appropriate estimates of uncertainty

Imputed values are **not** equivalent to observed values and serve only to help estimate the covariances between variables needed for inference.

### Single Imputation Methods

Single imputation denotes that the missing value is replaced by a value. However, the imputed values are assumed to be the real values that would have been observed when the data would have been complete. When we have missing data, this is never the case. We can never be completely certain about imputed values. Therefore this missing data uncertaintly should be incorporated as is done in multiple imputation. 

* **Unconditional Mean Imputation / Mean Substitution**: replacing the missing values for an individual variable wih it's overall estimated mean from the available cases. Its more important problem is that it will result in an artificial reduction in variability due to the fact you are imputing values at the center of the variable's distribution. This also has the unintended consequence of changing the magnitude of correlations between the imputed variable and other variables.
* **Single Imputation**:
* **Stochastic Imputation**: 

In recognition of the problems with regression imputation and the reduced variability associated with this approach, researchers developed a technique to incorporate or “add back” lost variability. A residual term, that is randomly drawn from a normal distribution with mean zero and variance equal to the residual variance from the regression model, is added to the predicted scores from the regression imputation thus restoring some of the lost variability. This method is superior to the previous methods as it will produce unbiased coefficient estimates under MAR. However, the standard errors produced during regression estimation while less biased then the single imputation approach, will still be attenuated.


### Direct maximum likelihood

### Multiple imputation

Visit [this website](http://lnr.li/YdyXo) for more information.

Multiple Imputation is always superior to any of the single imputation methods because:

* A single imputed value is never used
* The variance estimates reflect the appropriate amount of uncertainty surrounding parameter estimates

There are several decisions to be made before performing a multiple imputation including **distribution**, **auxiliary variables** and **number of imputations** that can affect the quality of the imputation.

1. **Imputation phase (PROC MI)**:  the user specifies the imputation model to be used and the number 
	   of imputed datasets to be created
2. **Analysis phase (`PROG GLM`/`PROC GENMOD`)**: runs the analytic model of interest within each of the imputed datasets
3. **Pooling phase (`PROC MIANALYZE`)**: combines all the estimates across all the imputed datasets and outputs one set of parameter estimates for the model of interest

***MVN or FCS?***


***Auxiliary variables***

* They can can help improve the likelihood of meeting the MAR assumption 
* They help yield more accurate and stable estimates and thus reduce the estimated standard errors in analytic models 
*  Including them can also help to increase power

***Number of imputations (m)***

* Estimates of coefficients stabilize at much lower values of *m* than estimates of variances and covariances of error terms 
* A larger number of imputations may also allow hypothesis tests with less restrictive assumptions (i.e., that do not assume equal fractions of missing information for all coefficients)
* Multiple runs of m imputations are recommended to assess the stability of the parameter estimates
*  Recommendations: 
 *  For low fractions of missing information (and relatively simple analysis techniques) 5-20 imputations and 50 or more when the proportion of missing data is relatively high
 *  The number of imputations should equal the percentage of incomplete cases (*m*=max(FMI%)), this way the error associated with estimating the regression coefficients, standard errors and the resulting p-values is considerably reduced and results in an adequate level of reproducibility

**More comments**

* You should include the dependent variable (DV) in the imputation model unless you would like to impute independent variables (IVs) assuming they are uncorrelated with your DV
* Although MI can perform well up to 50% missing observations,  the larger the amount the higher the chance of finding estimation problems during the imputation process and the lower the chance of meeting the MAR assumption
