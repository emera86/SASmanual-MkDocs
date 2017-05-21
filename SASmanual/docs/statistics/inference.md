[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m554/m554_4_a_sum.htm)

How to **verify the assumptions** and **diagnose problems** that you encounter in **linear regression**?

##Examining Residuals
You can use the **residual values** (difference between each observed value of $Y$ and its predicted value) from the regression analysis to verify the **assumptions of the linear regression**. Residuals are estimates of the errors, so you can **plot the residuals to check the assumptions of the errors**.

* You can plot residuals vs the predicted values to check for **violations of equal variances**
* You can also use this plot to check for **violations of linearity and independence**
* You can plot the residuals vs the values of the independent variables to **further examine any violations of equal variances** (you can see which predictor contributes to the violation of the assumption)
* You can use a histogram or a normal probability plot of the residuals to determine whether or not the **errors are normally distributed**

You want to see a **random scatter of the residual values** above and below the reference line at 0. If you see **patterns or trends** in the residual values, the assumptions might not be valid and the models might have problems.

![Assumptions violation examples](https://lh3.googleusercontent.com/-84ce_WbduHI/WOOAkeq-iiI/AAAAAAAAADs/e2ZzJE_XoLE8DnfdqNt-aaHhOzw8Z-ucgCLcB/s0/assumption-violation.PNG "Assumptions violation examples")

!!! note
To take autocorrelation (correlated over time) into account, you might need to use a regression procedure such as **PROC AUTOREG**

You can also use these plots to **detect outliers**, which often reflect data errors or unusual circumstances. They can affect your regression results, so you want to know whether any outliers are present and causing problems and investigate if they result from **data entry error or some other problem** that you can correct.

```
PROC REG DATA=SAS-data-set PLOTS(ONLY)=(QQ RESIDUALBYPREDICTED RESIDUALS)<options>;
	<label:> MODEL dependent=regressor(s) </options>;
	ID variable4identification;
RUN;
QUIT;
```

* **QQ** requests a residual quantile-quantile plot to assess the normality of the residual error
* **RESIDUALBYPREDICTED** requests a plot of residuals by predicted values to verify the equal variance assumption, the independence assumption and model adequacy
* **RESIDUALS** requests a panel of plots of residuals by the predictor variables in the model. If any of the *Residual by Regressors* plots show signs of unequal variance, we can determine which predictor variable is involved in the problem.

##Identifying Influential Observations

An influential observation is different from an outlier. An **outlier** is an unusual observation that has a large residual compare to the rest of the points. An **influential observation** can sometimes have a large residual compared to the rest of the points, but it is an observation so far away from the rest of the data that it singlehandedly exerts influence on the slope of the regression line.

![Outlier vs influential observation](https://lh3.googleusercontent.com/-SRVHsMC3NQg/WOOVPEZxDLI/AAAAAAAAAEA/1vGwrG2XlWISRMTx2fguuh109zyLXfVGACLcB/s0/outlier_vs_influential-observation.PNG "Outlier vs influential observation")

---
***Using STUDENT residuals to detect outliers***

Also known as **studientized or standardized residuals**, the STUDENT residuals are calculated by dividing the **residual by their standard errors**, so you can think of them as roughly equivalent to a z-score. 

* For **relatively small sample sizes**, if the absolute value of the STUDENT **residual is $>2$**, you can suspect that the corresponding observation is an outlier
* For **large sample sizes**, it's very likely that even more STUDENT **residuals greater than $\pm2$** will occur just by chance, so you should typically use a larger cutoff value of $>3$

---
***Using Cook's D statistics to detect influential observations***

Fore each observation, the Cook's D statistic is **calculated as if that observation weren't in the data set** as well as the set of parameter estimates with all the observations in your regression analysis. 

* If any observation has a Cook's D **statistic $>4/n$** that observation is influential
* The Cook's D statistic is most useful for identifying influential observations when the purpose of your model is **parameter estimation**

---
***Using RSTUDENT residuals to detect influential observations***

RSTUDENT residuals are similar to STUDENT residuals. For each observation, the RSTUDENT residual is the **residual divided by the standard error estimated with the current observation deleted**.

* If the RSTUDENT residual is different from the STUDENT residual, the observation is probably influential
* If the absolute value of the RSTUDENT residuals is $>2$ or $>3$, you've probably detected an influential observation

---
***Using DFFITS statistics to detect influential observations***

DFFITS measures the impact that each observation has on its own predicted value. For each observation, DFFITS is **calculated using two predicted values**:

* The first predicted value is calculated from a model using the entire data set to estimate model parameters
* The second predicted value is calculated from a model using the data set with that particular observation removed to estimate model parameters
* The difference between the two predicted values is divided by the standard error of the predicted value, without the observation

If the **standardized difference** between these predicted values **is large**, that particular observation has a **large effect on the model fit**.

* The **general cutoff** value is $2$
* The more **precise cutoff** is $2 \cdot sqrt(p/n)$
* If the absolute value of DFFITS for any observation is $>$ cutoff value, you've detected an influential observation
* DFFITS is most useful for **predictive models**

---
***Using DFBETAS statistics to explore the influenced predictor variable***

To help identifying which parameter the observation might be influencing most you can use DFBETAS (difference in betas). It measure the change in each parameter estimate. 

* One DFBETA is calculated per predictor variable per observation
* Each value is calculated by taking the estimated coefficient for that particular predictor variable **using all the data**, subtracting the estimated coefficient for that particular predictor variable with the **current observation removed** and dividing by its standard error
* Large DFBETAS indicate observations that are influential in estimating a given parameter:
 * The **general cutoff** value is $2$
 * The more **precise cutoff** is $2 \cdot sqrt(1/n)$

---

```
PROC GLMSELECT DATA=SAS-data-set <options>;
	<label:> MODEL dependent(s) = regressor(s) / </options>;
RUN;
QUIT;

ODS OUTPUT RSTUDENTBYPREDICTED=name-rstud-data-set
	       COOKSDPLOT=name-cooksd-data-set
	       DFFITSPLOT=name-dffits-data-set
	       DFBETASPANEL=name-dfbs-data-set;
			   
PROC REG DATA=SAS-data-set PLOTS(ONLY LABEL)=
								(RSTUDENTBYPREDICTED 
								 COOKSD 
								 DFFITS 
								 DFBETAS) <options>;
	<label:> MODEL dependent=&_GLSIND </options>;
	ID variable4identification;
RUN;
QUIT;
	
DATA influential;
	MERGE name-rstud-data-set
		  name-cooksd-data-set
		  name-dffits-data-set
		  name-dfbs-data-set;
	BY observation;
		
	IF (ABS(RSTUDENT)>3) OR (COOKSDLABEL NE ' ') OR DFFITSOUT THEN FLAG=1;
	ARRAY DFBETAS{*} _DFBETASOUT: ;
	DO I=2 TO DIM(DFBETAS);
		IF DFBETAS{I} THEN FLAG=1;
	END;
		
	IF ABS(RSTUDENT)<=3 THEN RSTUDENT=.;
	IF COOKSDLABEL EQ ' ' THEN COOKSD=.;

	IF FLAG=1;
	DROP I FLAG;
RUN;
	
PROC PRINT DATA=influential;
	ID observation;
	VAR RSTUDENT COOKSD DFFITSOUT _DFBETASOUT: ;
RUN;
```

* PROC GLMSELECT automatically creates the **&_GLSIND** macro variable which stores the list of effects that are in the model whose variable order you can check in the *Influence Diagnostics* panel
* The **ODS** statement takes the data that creates each of the requested plots and saves it in the specified data set
* The **LABEL** option includes a label for the extreme observations in the plot (labeled with the observation numbers if there is not ID specified)

Having **influential observations doesn't violate regression assumptions**, but it's a major nuisance that you need to address:

 1. **Recheck** for data entry errors
 2. If the data appears to be valid, **consider whether you have an adequate model** (a different model might fit the data better). Divide the number of influential observations you detect by the number of observations in you data set: if the result is **$>5\%$ you probably have the wrong model**.
 3. Determine whether the influential observation is **valid but just unusual**
 4. As a general rule you should **not exclude data** (some unusual observations contain important information)
 5. If you choose to exclude some observations, include in your report a **description of the types of observations that you excluded and why** and discuss the limitation of the conclusions given the exclusions

## Detecting Collinearity

Collinearity (or multicollinearity) is a problem that you face in multiple regression. It occurs when two or more **predictor variables are highly correlated with each other** (**redundant information** among them, the predictor variables explain much of the same variation in the response). Collinearity doesn't violate the assumptions of multiple regression.

* Collinearity can **hide significant effects** (if you include only one of the collinear variables in the model it is significant but when there are more than one included none of them are significant)
* Collinearity **increases the variance** of the parameter estimates, making them **unstable** (the data points don't spread out enough in the space to provide stable support for the plane defined by the model) and, in turn, this **increases the prediction error** of the model

When an overall model is highly significant but the individual variables don't tell the same story, it's a **warning sign of collinearity**. When the **standard error for an estimate is larger than the parameter estimate** itself, it's not going to be statistically significant. The SE tells us how variable the corresponding parameter estimate is: when the standard errors are high, the **model lacks stability**.

```
PROC REG DATA=SAS-data-set <options>;
	<label:> MODEL dependent = regressors / VIF </options>;
RUN;
QUIT;
```

* The **VIF** (variance inflation factor, $VIF_i=1/(1-R_i^2)$) option measures the magnitude of collinearity in a model (VIF$>10$ for any predictor in the model, those predictors are probably involved in collinearity)
* Other options are **COLLIN** (includes the intercept when analyzing collinearity and helps identify the predictors that are causing the problem) and **COLLINOINT** (requests the same analysis as COLLIN but excludes the intercept)

---

***Effective modeling cycle***

 1. You want to get to know your data by **performing preliminary analysis**: 
	 * Plot your data
	 * Calculate descriptive statistics 
	 * Perform correlation analysis
 2. Identify some **good candidate models** using PROC REG: 
 * First check for collinearity 
 * Use all-possible regression or stepwise selection methods and subject matter knowledge to select model candidates
 * Identify the good ones with the Mallows' (prediction) or Hocking's (explanatory) criterion for $C_p$
 3. **Check and validate your assumtions** by creating residual plots and conducting a few other statistical tests
 
 4. Deal with any **problems in your data**: 
  * Determine whether any influential observations might be throwing off your model calculations
  * Determine whether any variables are collinear
 5. **Revise your model**
 
 6. **Validate your model** with data not used to build the  model (prediction testing)