## Linear Mixed Model General Concepts

The linear mixed model is an extension of the general linear model, in which factors and covariates are assumed to have a linear relationship to the dependent variable.

**Factors.** Categorical predictors should be selected as factors in the model. Each level of a factor can have a different linear effect on the value of the dependent variable.

* **Fixed-effects factors** are generally thought of as variables whose values of interest are all represented in the data file.
* **Random-effects factors** are variables whose values in the data file can be considered a random sample from a larger population of values. They are useful for explaining excess variability in the dependent variable.

!!! note
    For example, a grocery store chain is interested in the effects of five different types of coupons on customer spending. At several store locations, these coupons are handed out to customers who frequent that location; one coupon **selected at random** is distributed to each customer.
	  The type of coupon is a **fixed effect** because the company is interested in those particular coupons. The store location is a **random effect** because the locations used are a sample from the larger population of interest, and while there is likely to be store-to-store variation in customer spending, the company is not directly interested in that variation in the context of this problem.

**Covariates.** Scale predictors should be selected as covariates in the model. Within combinations of factor levels (or cells), values of covariates are assumed to be linearly correlated with values of the dependent variables.

**Interactions.** The Linear Mixed Models procedure allows you to specify factorial interactions, which means that each combination of factor levels can have a different linear effect on the dependent variable. Additionally, you may specify factor-covariate interactions, if you believe that the linear relationship between a covariate and the dependent variable changes for different levels of a factor.

**Random effects covariance structure.** The Linear Mixed Models procedure allows you to specify the relationship between the levels of random effects. By default, levels of random effects are uncorrelated and have the same variance. 

**Repeated effects.** Factors and covariates are features of the general linear model. In the Linear Mixed Models procedure, repeated effects variables are added, allowing you to relax the assumption of independence of the error terms. In order to model the covariance structure of the error terms, you need to specify the following:

* **Repeated effects variables** are variables whose values in the data file can be considered as markers of multiple observations of a single subject.
* **Subject variables** define the individual subjects of the repeated measurements. The error terms for each individual are independent of those of other individuals.
* The **covariance structure** specifies the relationship between the levels of the repeated effects. The types of covariance structures available allow for residual terms with a wide variety of variances and covariances.
	
!!! note 
    For example, if the grocery store recorded the purchasing habits of their customers for four consecutive weeks, then the variable Week would be a **repeated effects variable**. Specifying a subject variable denoting the Customer ID differentiates the repeated observations of separate customers. Specifying a first-order autoregressive covariance structure reflects your belief that a higher-than-average volume of purchases in one week will correspond to a higher (or lower)-than-average volume in the following week.

## SAS Formulation

```
PROC MIXED DATA=SAS-data-set;
  CLASS categorical1 categorical2;
  MODEL response = continuous1 categorical1 continuous1*categorical1 / solution;
  RANDOM categorical2;
  LSMEANS continuous1*categorical1 / CL PDIFF DIFFS E;
RUN;
QUIT;
```
