Depending on the **type of data and model** you will be using, techniques such as **multiple imputation** or **direct maximum likelihood** may better serve your needs. The main goals of statistical analysis with missing data are:

* Minimize bias
* Maximize use of available information
* Obtain appropriate estimates of uncertainty

### Missing Data Mechanisms

To use the more appropriate imputation method you should consider the missing data mechanism of your data which describes the process that is believed to have generated the missing values:

* **Missing completely at random (MCAR)**:  neither the variables in the dataset nor the unobserved value of the variable itself predict whether a value will be missing
* **Missing at random (MAR)**: other variables (but not the variable itself) in the dataset can be used to predict missingness on a given variable
* **Missing not at random (MNAR)**: value of the unobserved variable itself predicts missingness

Imputed values are **not** equivalent to observed values and serve only to help estimate the covariances between variables needed for inference.

### Main imputation techniques

Some of the imputation techniques are:

* **Complete case analysis (listwise deletion)**:  deleting cases in a particular dataset that are missing data on any variable of interest (for MCAR cases the power is reduced but it does not add any bias) 
* **Available case analysis (pairwise deletion)**:  deleting cases where a variable required for a particular analysis is missing, but including those cases in analyses for which all required variables are present
* **Mean Imputation**:
* **Single Imputation**:
* **Stochastic Imputation**: 

## Direct maximum likelihood

## Multiple imputation

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
