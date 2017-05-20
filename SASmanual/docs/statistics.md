## Introduction to Statistics
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m551/m551_6_a_sum.htm)

### Basic Statistical Concepts

* ***Descriptive statistics (exploratory data analysis, EDA)***
  * Explore your data
* ***Inferential statistics (explanatory modelling)***
  * **How is X related to Y?**
  * Sample sizes are typically small and include few variables
  * The focus is on the parameters of the model
  * To assess the model, you use p-values and confidence intervals
* ***Predictive modelling***
  * **If you know X, can you predict Y?**
  * Sample sizes are large and include many predictive (input) variables
  * The focus is on the predictions of observations rather than the parameters of the model
  * To assess a predictive model, you validate predictions using holdout sample data
 
---
 
**How to generate random (representative) samples (population subsets)**

```
PROC SURVEYSELECT DATA=SAS-data-set 
                  OUT=name-of-output-data-set
                  METHOD=method-of-random-sampling
                  SEED=seed-value 
                  SAMPSIZE=number-of-observations-desired;
     <STRATA stratification-variable(s);>
RUN;
```

* **METHOD**: specifies the random sampling method to be used. For simple random sampling without replacement, use **METHOD=SRS**. For simple random sampling with replacement, use **METHOD=URS**. For other selection methods and details on sampling algorithms, see the SAS online documentation for PROC SURVEYSELECT.
* **SEED**: specifies the initial seed for random number generation. If no SEED option is specified, SAS uses the system time as its seed value. This creates a different random sample every time the procedure is run.
* **SAMPSIZE**: indicates the number of observations to be included in the sample. To select a certain fraction of the original data set rather than a given number of observations, use the **SAMPRATE** option.

---

* **Parameters**: numerical values (typically unknown, you can't measure the entire population) that summarize characteristics of a population (greek letters)
* **Statistics**: summarizes characteristics of a sample (standard alphabet)
* You use **statistics** to estimate **parameters**

---

* **Independent variable**: it can take different values, it affects or determines a **dependent variable**. It can be called predictor, explanatory, control or input variable.
* **Dependent variable**: it can take different values in response to an **independent variable**. Also known as response, outcome or target variable.

---

***Scale of measurement***: variable's classification
<br>

* **Quantitative/numerical variables**: counts or measurements, you can perform arithmetical operations with it
 * **Discrete data**: variables that can have only a countable number of values within a measurement range
 * **Continuous data**: variables that are measured on a scale that has infinite number of values and has no breaks or jumps
   * **Interval scale data**: it can be rank-ordered like ordinal data but also has a sensible spacing of observations such that differenes between measurements are meaningful but it lacks a true zero (ratios are meaningless)
   * **Ratio scale data**: it is rank-ordered with meaningful spacing and also includes a true zero point and can therefore accurately indicate the ratio difference between two spaces on the measurement scale
* **Categorical/attribute variables**: variables that denote groupings or labels
 * **Nominal data (qualitative/classification variable)**: exhibits no ordering within its observed levels, groups or categories
 * **Ordinal data**: the observed labels can be ordered in some meaningful way that implies that the differences between the groups or categories are due to magnitude

---

* **Univariate analysis** provides techniques for analyzing and describing a sigle variable. It reveals patterns in the data by looking at the **range** of values, measures of **dispersion**, the **central tendecy** of the values and **frequency distribution**.
* **Bivariate analysis** describes and explains the relationships between two variables and how they change or covary together. It include techniques such as **correlation analysis** and **chi-square tests of independance**.
* **Multivariate/Multivariable analysis** examines two or more variables at the same time in order to understand the relationships among them. 
 * Techniques such as **mutiple linear regression** and n-way **ANOVA** are typically called **multivariable** analysis (only one response variable). 
 * Techniques such as **factora analysis** and **clustering** are typically called **mutivariate** analysis (they consider more than one response variable).


### Descriptive Statistics

**Measures of central tendencies**: mean (affected by outliers), median (less sensitive to outliers), mode

25th percentile = 1st/lower quartile = Q1<br>
50th percentile = median = middle quartile = Q2<br>
75th percentile = 3rd/upper quartile = Q3<br>

The **interquartile range (IQR)** is the difference between Q1 and Q3, it is a **robust estimate of the variability** because changes in the upper/lower 25% of the data do not affect it. If there are **outliers** in the data, then the IQR is a more reliable measure of the spread than the overall range.

The **coefficient of variation (CV)** is a measure of the standard deviation expressed as a percentage of the mean (S/mean\*100)

### Picturing Your Data

**Normal distribution**: (&mu;-&sigma;,&mu;+&sigma;) = 68%; (&mu;-2&sigma;,&mu;+2&sigma;) = 95%; (&mu;-3&sigma;,&mu;+3&sigma;) = 99%

*How to check the normality of a sample?*

* Compare the **mean** and the **median**: if they are nearly equal, that is an indicator of symmetry (requirement for normality).
* Check that **skewness** and **kurtosis** are close to 0.

***Statistical summaries:*** **skewness** and **kurtosis** measure certain aspects of the shape of a distribution (they are **0** and **3** for a normal distribution, although SAS has standardized both to 0)

* **Skewness** measures the tendency of your data to be more spread out on one side of the mean than on the other (asymmetry of the distribution). 
 * You can think of the direction of skewness as the direction the data is trailing off to. 
 * A **right-skewed** distribution tells us that the mean is **greater than the median**.
* **Kurtosis** measures the tendency of your data to be concentrated toward the center or toward the tails of the distribution (peakedness of the data, tail thickness). 
 * A **negative kurtosis (platykurtic distribution)** means that the data has lighter tails than in a normal distribution. 
 * A **positive kurtosis (leptokurtic/heavy-tailed/outlier-prone distribution)** means that the data has heavier tails and is more concentrated around the mean than a normal distribution.
 * Rectangular, bimodal and multimodal distributions tend to have low values of kurtosis.
 * **Asymmetric distributions** also tend to have nonzero kurtosis. In these cases, understanding kurtosis is considerably more complex and can be difficult to assess visually.
* If **skewness/kurtosis**:
 * Both are greater than 1 or less than -1: data is not normal
 * Either is greater than 2 or less than -2: data is not normal

---

***PLOTS PRODUCED WITH PROC UNIVARIATE***

* **Histograms**
* **Normal probability plots**: expected percentiles from standard normal vs actual data values

![Normal Probability Plots](https://lh3.googleusercontent.com/oQg9v6o7-BVphCe0xL8cP2L49JBQL7hixl7_uwJUEKQkMdbotX-f906RXjowuwCe3llq05I=s0 "Normal Probability Plots")

***PLOTS PRODUCED WITH PROC SGSCATTER***

* **Scatter plots**: you can create a **single-cell** (simple Y by X) scatter plot, a **multi-cell** scatter plot with multiple independent scatter plots in a grid and a **scatter plot matrix**, which produces a matrix of scatter plots comparing multiple variables.

***PLOTS PRODUCED WITH PROC SGPLOT***

```
PROC SGPLOT DATA=SAS-data-set <options>;
        DOT category-variable </options>;
        HBAR category-variable </options>;
        VBAR category-variable </options>;
        HBOX response-variable </options>;
        VBOX response-variable </options>;
        HISTOGRAM response-variable </options>;
        SCATTER X=variable Y=variable </options>;
        NEEDLE X=variable Y=numeric-variable </options>;
        REG X=numeric-variable Y=numeric-variable </options>;
RUN;
```

Anywhere in the procedure you can add **reference lines**:<br>
```
REFLINE variable | value-1 <... value-n> </option(s)>`<br>
**E.g.:** `REFLINE 1200 / axis=y lineattrs=(color=blue);`</option(s)>
```
**E.g.:** 
```
REFLINE 1200 / axis=y lineattrs=(color=blue);
```

* **Scatter plots (SCATTER)**
* **Line graphs**
* **Histograms (HISTOGRAM)** with overlaid distribution curves
* **Regression lines (REG)** with confidence and prediction bands
* **Dot plots (DOT)**
* **Box plots (HBOX/VBOX)**: it makes it easy to see how spread out your data is and if there are any outliers. The box represents the middle 50% of your data (IQR). The lower/middle/upper **line of the box** represent Q1/Q2/Q3. The **diamond** denotes the mean (easy to check how close the mean is to the median). The **whiskers** extend as far as the data extends to a maximum length of 1.5 times the IQR above Q3. Any data points farther than this distance are considered possible outliers and are represented in this plot as **circles**.
* **Bar charts (HBAR/VBAR)**
* **Needle plot (NEEDLE)**: creates a plot with needles connecting each point to the baseline
* You can also **overlay plots together** to produce many different types of graphs

***PLOTS PRODUCED WITH PROC SGPANEL***

* **Panels of plots** for different levels of a factor or several different time periods depending on the classification variable
* **Side-by-side histograms** which provide a visual comparison for your data

***PLOTS PRODUCED WITH PROC SGRENDER***

* **Plots from graphs templates you have modified or written yourself**

---

To specify options for graphs you submit the **ODS GRAPHICS** statement:

```
ODS GRAPHICS ON <options>;
```

* To select/exclude specific test results, graphs or tables from you output, you can use **ODS SELECT** and **ODS EXCLUDE** statements.
* You can use ODS templates to modify the layout and details of each graph
* You can use ODS styles to control the general appearance and consistency of yous graphs and tables (by default **HTMLBLUE**).

Another way to control you output is to use the **PLOT** option which is usually available in the procedure statement:<br>
`PROC UNIVARIATE DATA=SAS-data-set PLOTS=options;`<br>
This option enables you to specify which graphs SAS should create, either in addtion or instead of the default plots.

### Confidence Intervals for the Mean

* A **point estimator** is a sample statistic used to estimate a population parameter
* An estimator takes on different values from sample to sample, so it's important to know its variance
* A statistic that measures the variability of your estimator is the **standard error**
* It differs from the standard deviation: the **standard deviation** deals with the variability of your data while **standard error** deals with the variability of you sample statistic

**E.g.:** Standard error of the mean = standard deviation/sqrt(sample size)

The **distribution of sample means** is always less variable than the data.

* Because we know that point estimators vary from sample to sample, it would be nice to have an estimator of the mean that directly accounts for this natural variability
* The **interval estimator** gives us a range of values that is likely to contain the population mean
* It is calculated from the **standard error** and a value that is determined by the **degree of certainty** we require (**significance level**)
* **Confidence intervals** are a type of interval estimator used to estimate the population mean
* You can make the confidence interval narrower by increasing the sample size and by decreasing the confidence level

CI = sample mean &plusmn; quantile * standard error

* The **CLM** option of **PROC MEANS** calculates the confidence limits for the mean, you can add **alpha=** to change the default 0.05 value for a 95% confidence level
* The **central limit theorem** states that the distribution of sample means is approximately normal regardless of the population distribution's shape, if the sample size is large enough (~30 observations)

### Hypothesis Testing

* The **null hypothesis (H0)** is what you assume to be true when you start your analysis
* The **alternative hypothesis (Ha/H1)** is your initial research hypothesis, that is, your proposed explanation

Decision-making process:
1. Define null and alternative hypothesis
2. Specify significance level (type I error rate)
3. Collect data
4. Reject or fail to reject the null hypothesis

![Error types](https://lh3.googleusercontent.com/KaQmpAoTHu1NsLpiBusArHKbs5Zn0AP5eV0CB2PwBObxixZQ98gaUDJVGZSnSj8Li4Hwfvw=s0 "Error types")

* The type I and II errors are **inversely related**: as one type increases the other decreases 
* The **power** is the probability of a **correct rejection** = 1 - &beta;
 * It is the ability of the statistical test to detect a true difference
 * It is the ability to successfully reject a false null hypothesis
 

* A **p-value** measures the probability of observing a value as extreme as the one observed
 * The p-value is used to determine **statistical significance**
 * It helps you assess whether you should reject the null hypothesis
* The **p-value** is affected by:
 * The **effect size**: the difference between the observed statistic and the hypothesized value
 * The **sample size**: the larger the sample size, the more sure you are about the sample statistics, the lower the p-value is
 
 
* A reference distribution enables you to quantify the probability (p-value) of observing a particular outcome (the calculated sample statistic) or a more extreme outcome, if the nul hypothesis is true
* Two common reference distributions for statistical hypothesis testing are the **t distribution** and the **F distribution**
* These distributions are characterized by the **degrees of freedom** associated with your data
* The **t distribution** arises when you're making inferences about a population mean and the population standard deviation is unknown and has to be estimated from the data
 * It is **approximately normal** as the **sample size grows larger**
 * The t distribution is a **symmetric distribution** like the normal distribution except that the t distribution has **thicker tails**
 * The **t statistic** is positive/negative when the sample is more/less than the hypothesized mean
 * If the data doesn't come from a normal distribution, then the t statistic approximately follows a t distribution as long as the sample size is large (**central limit theorem**)
 
Calculation with **PROC UNIVARIATE**:

```
ODS SELECT TESTSFORLOCATION;
PROC UNIVARIATE DATA=SAS-data-set MU0=number alpha=number;
  VAR variable(s);
  ID variable_to_relate;
  HISTOGRAM variables </options>;
  PROBPLOT variables </options>;
  INSET keywords </options>;
RUN;
```

* **TESTSFORLOCATION** displays only the p-values calculation
* By default **MU0 = 0**

## Analysis of Variance (ANOVA)

[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m552/m552_7_a_sum.htm)

![enter image description here](https://lh3.googleusercontent.com/xOC5eoOUs-6v-b-VnQU6ivGQQPIOQH7ACcKMS2jfrOTK1HJLuBbchpYm3cuganuJ_gNJsBU=s0 "ANOVA")

### Graphical Analysis of Associations

* Before analyzing your data, you need to have a general idea of any associations between **predictor variables** and **response variables**
* An **association** exists between two variables when the expected value of one variable differs at different levels of the other variable
* One method for doing this is to conduct a **graphical analysis** of your data
* Associations between **categorical** predictor variable and a **continuous** response variable can be explored with **SGPLOT** to product **box plots (box-and-whisker plots)** (**X** predictor variable vs **Y** response variable)
* If the **regression line** conecting the means of Y at each value of X is not horizontal **there might be an association** between them
* If the **regression line** is horizontal **there is no association**: knowing the value of X doesn't tell you anything about the value of Y

```
PROC SGPLOT DATA=SAS-data-set;
	VBOX response-variable / CATEGORY=predictor-variable
	CONNECT=MEAN DATALABEL=outlier-ID-variable;
RUN;
```

### Two-Sample t-Tests

* You can use a **one-sample t-test** to determine if the mean of a population is equal to a particular value or not
* When you collect a random sample of independent observations from two different populations, you can perform a **two-sample t-test**

When you compare the means of two populations using a **two-sample t-test** you make three assumptions:

* The data contains independent observations
* The distributions of the two populations are normal (check histograms and normal probability/Q-Q plots)
* The variances in these normal distributions are equal (**F-test** is the formal way to verify this assumption)
F statistic: $F=max(s_1^2,s_2^2)/min(s_1^2,s_2^2) \ge 1$
H0: &sigma;$_1^2$ $=$  &sigma;$_2^2\rightarrow F \approx 1$
Ha: &sigma;$_1^2$ $\ne$  &sigma;$_2^2\rightarrow F\gt 1$
The **Pr>F** value in the **Equality of Variances** table represents the **p-value** of the F-test for equal variances

**Two-sided Tests**

* **PROC TTEST** performs a two-sided two-sample t-test by default (confidence limits and ODS graphics included)
* It **automatically test the assumption of equal variances** and provides an exact two-sample t-test (**pooled**) when the assumptions are met and an approximate t-test (**scatterthwaite**) when it is not met 
* The pooled and scatterthwaite t-tests are equal when the variances are equal

```
PROC TTEST DATA=SAS-data-set <options>
    plots(shownull)=interval;         \* shownull = vertical reference line at the mean value of H0 *\
	CLASS variable;                   \* Classification variable *\
	VAR variable(s);                  \* Continuous response variables *\
RUN;
```

**One-sided Tests**

* It **can increase the power** of a statistical test, meaning that if you are right about the direction of the true difference, you will more likely detect a significant difference with a one-sided test than with a tow-sided test
* The difference between the mean values for the null hypothesis will be defined by the alphabetical order of the classification variables (e.g.: female - male)

```
PROC TTEST DATA=SAS-data-set 
    plots(only shownull)=interval H0=0 SIDES=u;     \* only = suppress the default plots; u/l = upper/lower-tailed t-test  *\
	CLASS variable;                                 \* Classification variable *\
	VAR variable(s);                                \* Continuous response variables *\
RUN;
```

### One-Way ANOVA

When you want to determine whether there are significant differences between the **means of two or more populations**, you can use analysis of variance (ANOVA).

* You have a continuous dependent (**response**) variable and a categorical independent (**predictor**) variable
* You can have **many levels of the predictor variable**, but you can have **only one predictor variable**
* The **squared value of the t statistic** for a two-sample t-test is equal to the **F statistic** of a one-way ANOVA with two populations
* With ANOVA the **H0** is that all of the population means are equal and **Ha** is that not all the population means are equal (at least one mean is different)

To perform an ANOVA test you make three assumptions:

* You have a **good, random, representative sample**
* The **error terms are normally distributed**
 * The **residuals** (each observation minus its group mean) are estimates of the error term in the model so you verify this assumption by examining diagnostic plots of the residuals (if they are approximately normal, the error terms will be too)
 * If your sample sizes are reasonably large and approximately equal across groups, then only severe departures from normality are considered a problem
 * Residuals always sum to 0, regardless of the number of observations.
* The **error terms have equal variances** across the predictor variable levels: you can conduct a formal test for equal variances and also plot the residuals vs predicted values as a way to graphically verify this assumption

You can use **PROC GLM** to verify the ANOVA assumptions and perform the ANOVA test. It fits a general linear model of which ANOVA is a special case and also displays the sums of squares associated with each hypothesis it tests.

```
PROC GLM DATA=SAS-data-set
         PLOTS(ONLY)=DIAGNOSTICS(UNPACK);     /* print each plot on a separated page */
	CLASS variable(s);
	MODEL dependents=intependents </options>;
	MEANS effects / HOVTEST </options>;    
RUN;
QUIT;
```

* **HOVTEST**: homogeneity of variance test option (Levene's test by default) + plot of residuals vs predicted values (means)

---

* Of the **between-group variability** is significantly larger than the **within-group variability**, you reject the null that all the group means are equal
* You partition out the variability using sums of squares: 
 * **Between-group** variation: also called Model Sum of Squares (SSM): $\sum n_i (\overline Y_i- \overline {\overline Y})^2$
 * **Within-group** variation: also called Error Sum of Squares (SSE): $\sum \sum (Y_{ij}- \overline Y_i)^2$
 * **Total** variation: also called the Total Sum of Squares (SST): $\sum \sum (Y_{ij}- \overline {\overline Y})^2$
* **SSM** and **SSE** represent pieces of **SST**: the SSM is the variability explanied by the predictor variable levels and SSE the variability not explained by the predictor variable levels
* You want the larger piece of the total to be better represented by what you can explain (SSM) vs what you cant't explain (SSE) 

### ANOVA with Data from a Randomized Block Design

In an **observational study**, you often examine what already occurred, and therefore have little control over factors contributing to the outcome. In a **controlled experiment**, you can manipulate the **factors of interest** and can more reasonably claim causation.

* The variation due to the **nuisance factors** (fundamental to the probabilistic model but are no longer of interest) is part of the random variation that the error sum of squares accounts for.
* Including a **blocking variable** in the model is in essence like adding a second predictor variable to the model in terms of the way you write it
* The way you set up your experiment and data collection is what defines it as a blocking factor
* Although you're not specifically interested in its effect, **controlling the blocking variable makes it easier to detect an effect of the factor of interest**
* In a model that does not include a blocking variable, its effects are lumped into the error term of the model (unaccounted for variation)
* When you include a blocking variable in your ANOVA model, any effects caused by the nuisance factors that are common within a sector are accounted for in the **model sum of squares rather than the error sum of squares**

You make two more assumptions when you include a blocking factor in the model:

* Primary variable levels are **randomly assigned** within each block
* The effects of the primary variable are **constant across the levels** of the blocking factor (the effects don't depend on the block they are in, there are **no interactions** with the blocking variable)

**Note:** Levene's test for homogeneity is **only available for one-way ANOVA models**, so in this case, you have to use the Residuals by Predicted plot.

```
PROC GLM DATA=SAS-data-set
         PLOTS(ONLY)=DIAGNOSTICS(UNPACK);   /* print each plot on a separated page */
	CLASS variable(s) blocking-factor(s);
	MODEL dependents=intependents blocking-factor(s)</options>;
RUN;
QUIT;
```

* ***Rule of thumb***: if the **F-value is > 1**, then it helped to add the blocking factor in your model 
* If you compare the MSE (*Mean Square* in the table) without and with including the blocking variable in the model,  there is a drop of its value meaning that **you have been able to account for a bit more of the unexplained variability due to the nuisance factors** helping o have more precise estimates of the effect of your primary variable
* It is also reflected in the *R-Square* value that is increased when a blocking factor is added to the model
* Thanks to adding a blocking variable to your model you can get your primary variable to be significant
* The **Type III SS** at the bottom of the output tests for the difference due to each variable, controlling for or adjusting for the other variable

### ANOVA Post Hoc Tests

This test is used to determine which means differ from other means and control the error rate using **multiple comparison method**.

Assuming the null hypothesis is true for your different comparisons, the probability that you conclude a difference exist at least one time when there really  isn't a difference increases with the more tests you perform. So **the chance that you make a Type I error increases each time you conduct a statistical test**.

* The **comparisonwise error rate (CER)** is the probability of a Type I error on a single pairwise test (&alpha;)
* The **experimentwise error rate (EER)** is the probability of making at least one Type I error when performing the whole set of comparisons. It takes into consideration the number of pairwise comparisons you make, so it increases as the number of tests increase: $EER=1-(1-\alpha)^{\# \\\ of \\\ comparisons}$

***Tukey's Multiple Comparison Method***

* This method, which is also known as the **Honestly Significant Difference** test, is a popular multiple comparison test that **controls the EER**
* This tests compares all possible pairs of means, so **it can only be used when you make pairwise comparisons**
* This method controls $EER=\alpha$ when **all possible pairwise comparisons are considered** and controls $EER<\alpha$ when fewer than all pairwise comparisons are considered

***Dunnett's Multiple Comparison Method***

* This method is a specialised multiple comparison test that allows you to **compare a single control group to all other groups**
* It controls $EER \le \alpha$ when all groups are compared to the reference group (control)
* It accounts for the correlation that exists between the comparisons and **you can conduct one-sided tests** of hypothesis against the reference group

```
PROC GLM DATA=SAS-data-set;
	CLASS variable(s);
	MODEL dependents=intependents </options>;
	LSMEANS effects </options-test-1>;  
	LSMEANS effects </options-test-2>;
	[...]
	LSMEANS effects </options-test-n>;  
RUN;
QUIT;
```

* **PDIFF=ALL** requests p-values for the differences between ALL the means and a **diffogram** is produced automatically displaying all pairwise least square means differences and indicating which are significant
 * It can be undestood as a least squares mean by least squares mean plot
 *  The point estimates for differences between the means for each pairwise comparison can be found at the intersections of the gray grid lines (intersection of appropriate indexes)
 * The red/blue diagonal lines show the **confidence intervals for the true differences of the means** for each pairwise comparison
 * The grey 45$^{\circ}$ reference line represents equality of the means (if the confidence interval crosses over it, then there is no significant difference between the two groups and the diagonal line for the pair will be **dashed and red**; if the difference is significant the line will be **solid and blue**)

![Diffogram](https://lh3.googleusercontent.com/-yuw0XR4JPqs/WNknWl3atwI/AAAAAAAAABk/V_lTXMtgO_QDm7VJ9jPy29h7MIxZbyhzQCLcB/s0/diffogram.png "Diffogram")

* The **ADJUST=** option specifies the adjustment method for multiple comparisons
* If you don't specify an option SAS uses the **Tukey method by default**, if you specify **ADJUST=Dunnett** the GLM procedure produces multiple comparisons using **Dunnett's method** and a **control plot** 
 * The control plot displays the least squares mean and confidence limits of each group compared to the reference group 
 * The middle **horizontal line represents its least square mean value** (you can see the arithmetic mean value un the **upper right corner** of the graph)
 * The **shaded area** goes from the **lower decision limit (LDL)** to the **upper decision limit (UDL)**
 * There is a vertical line for each group that you're comparing to the reference (control) group. If a **vertical line extends past the shaded area**, then the group represented by the line is **significantly different** (small p-value) than the reference group 

![Control plot](https://lh3.googleusercontent.com/-ZI5PKbFT1ns/WNkoofa4E3I/AAAAAAAAAB0/0RNlG7_94QMV3s864uB5UncYOw7VEMkYgCLcB/s0/controlplot.PNG "Control plot")

* **PDIFF=CONTROLU('value')** specifies the control group for the Dunnett's case: the direction of the sign in Ha is the same as the direction you are testing, so this is a **one-sided upper-tailed t-test**
* If you specify **ADJUST=T** SAS will make no adjustments for multiple comparisons: is not recommended as there's a tendency to find **more significant pairwise differences than might actually exist**

### Two-Way ANOVA with Interactions

When you have a continuous response variable and **two categorical predictor variables**, you use the **two-way ANOVA model**

* **Effect**: the magnitude of the expected change in the response variable presumably caused by the change in value of a predictor variable in the model
* In addition, the variables in a model can be referred to as effects or terms
* **Main effect**: is the effect of a single predictor variable
*  **Interaction effects**: when the relationship of the response variable with a predictor changes with the changing of another predictor variable (the effect of one variable depends on the value of the other variable)

![Interaction plot](https://lh3.googleusercontent.com/-GK8G9YC7d1s/WNk5aOIcxAI/AAAAAAAAACM/nuq7AoAjh98_cci-KnaWTzhjbsCW_mSHACLcB/s0/interactionplot.png "Interaction plot")

When you consider an ANOVA with more than one predictor variable, it's called **n-way ANOVA** where *n* represents the number of predictor variables

* The analysis in a **randomized block design** is actually a **special type of two-way ANOVA** in which you have one factor of interest and one blocking factor
* When you analyze a two-way ANOVA with interactions, you first look at any tests for **interactions among the factors**
 * If there is **no interaction between the factors** you can interpret the tests for the individual factor effects to determine their significance/non-significance
 * If an **interaction exists between any factors**, the tests for the individual factor effects might be misleading due to masking of these effect by the interaction (this is specially true for unbalanced data with different number of observations for each combination of groups)
* When the interaction is not statistically significant **you can analyze the main effect with the model in its current form** (generally the method you use when you analyze designed experiments)
* Even when you analyze designed experiments, some statisticians might suggest that if the interaction is not significant, **you can delete the interaction effect from your model, rerun the model and then just analyze the main effects** increasing the power of the main effects test
* If the **interaction term is significant**, it is good practice to keep the main effect terms that make up the interaction in the model, whether they are significant or not (this preserves model hierarchy)
* You have to make the **same three assumptions used in the ANOVA test**
* The interaction terms are also called **product terms** or **crossed effects**

```
PROC GLM DATA=SAS-data-set;
	CLASS independent1 independent2;
	MODEL dependent = independent1 independent2 independent1*independent2;
	or
	MODEL dependent = independent1 | independent2;
RUN;
QUIT;
```

This program is **fitting to this model**:
$Y_{ijk}=\mu + \alpha_i+\beta_j+(\alpha\beta)_{ij}+\epsilon_{ijk}$
dependent = overall mean + intependent1 + independent2 + interaction12 + unaccounted for variation 

* In **most situations** you will want to use the **Type III SS**
* The **Type I SS (sequential)** are the sums of squares you obtain from fitting the effects in the order you specify in the model 
* The **Type III SS (marginal)** are the sums of squares you obtain from fitting each effect after all the other terms in the model, that is the sums of squares for each effect corrected for the other terms in the model
* When examining these results you first have to **look at the interaction term and if it's significant** (p-value), the **main effects don't tell you the whole story**. It that is the case, you don't need to worry all that much about the significance of the main effects at this point for two reasons:
 * You know that the effect of each variable1 level changes for the different variable2 levels
 * You want to include the main effects in the model, whether they are significant or not, to preserve model hierarchy
* You can analyze the interaction between terms by looking at the **interaction plot** that SAS produces by default when you include an interaction term in the model
* To analyze and interpret the effect of one of the interacting variables you need to add the **LSMEANS** statement to your program

```
PROC GLM DATA=SAS-data-set ORDER=INTERNAL PLOTS(ONLY)=INTPLOT;
	CLASS independent1 independent2;
	MODEL dependent = intependent1 independent2 independent1*independent2;
	LSMEANS independent1*independent2 / SLICE= independent1;
RUN;
QUIT;
```

SAS creates two types of mean plots when you use the LSMEANS statement with an interaction term:

* The first plot displays the **least squares mean (LS-Mean) for every effect level** 
* The second plot contains the same information rearranged so you can **look a little closer at the combination levels**

---

You can add a **STORE** statement to save your analysis results in an **item store** (a binary file format that cannot be modified). This allows you to **run post-processing analysis** on the stored results even if you no longer have access to the original data set. The STORE statement applies to the following SAS/STAT procedures: GENMOD, GLIMMIX, GLM, GLMSELECT, LOGISTIC, MIXED, ORTHOREG, PHREG, PROBIT, SURVEYLOGISTIC, SURVEYPHREG, and SURVEYREG.

```
STORE <OUT=>item-store-name
	</ LABEL='label'>;
```
			
* **item-store-name** is a usual one- or two-level SAS name, similar to the names that are used for SAS data sets
* **label** identifies the estimate on the output (is optional)

To perform post-fitting statistical analysis and plotting for the contents of the store item, you use the **PLM procedure**. The statements and options that are available vary depending upon which procedure you used to produce the item store.

```
PROC PLM RESTORE=item-store-specification <options>;
	EFFECTPLOT INTERACTION(SLICEBY=variable) <plot-type <(plot-definition options)>> / CLM </ options>;
	LSMEANS <model-effects> </ options>;
	LSMESTIMATE model-effect <'label'> values
		<divisor=n><,...<'label'> values
		<divisor=n> </ options>;
	SHOW options;
	SLICE model-effect / SLICEBY=variable ADJUST=tukey </ options>;
	WHERE expression;
RUN;
```

* **RESTORE** specifies the source item store for processing
* **EFFECTPLOT** produces a display of the fitted model and provides options for changing and enhancing the displays
* **LSMEANS** computes and compares least squares means (LS-means) of fixed effects
* **LSMESTIMATE**	provides custom hypothesis tests among least squares means
* **SHOW** uses ODS to display contents of the item store. This statement is useful for verifying that the contents of the item store apply to the analysis and for generating ODS tables.
* **SLICE** provides a general mechanism for performing a partitioned analysis of the LS-means for an interaction (analysis of simple effects) and it uses the same options as the LSMEANS statement
* **WHERE** is used in the PLM procedure when the item store contains **BY-variable** information and you want to apply the PROC PLM statements to only a subset of the BY groups

## Regression
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m553/m553_6_a_sum.htm)

![Summary lessons 3-6](https://lh3.googleusercontent.com/-Y-23_trrs6A/WON7VhnzxPI/AAAAAAAAADY/vRxCZowh9tItWRSSGTHZYpa2Ur4Qh97nwCLcB/s0/summary3-6.png "Summary lessons 3-6")

### Exploratory Data Analysis

A useful set of techniques for investigating your data is known as **exploratory data analysis**.

***Scatter plots***

```
PROC SGSCATTER DATA=SAS-data-base;
	PLOT vairableY*(variableX1 variableX2) / REG;
RUN;
```

* If you have **so many observations** that the scatter plot of the whole data set is difficult to interpret, you might run PROC SGSCATTER on a **random sample of observations**

***Correlation analysis***

The closer the **Pearson** correlation coefficient is to +1/-1, the stronger the positive/negative linear relationship is between the two variables. The closer the correlation coefficient is to 0, the weaker the linear relationship and if it is 0 variables are uncorrelated.

* When you interpret the correlation, be cautious about the effect of **large sample sizes**: even a correlation of 0.01 can be statistically significant with a large enough sample size and you would almost always reject the hypothesis H0: &rho;=0, even if the value of your correlation is small for all practical purposes
* Some **common errors** on interpreting correlations are concluding a **cause-and-effect relationship** between the variables misinterpreting the kind of relationship between the variables and failing to recognize the influence of outliers on the correlation
	* The variables might be related but not causally
	* Correlation coefficients can be large because both variables are affected by other variables
	* Variables might be strongly correlated by chance
* Just because the correlation coefficient is close to 0 doesn't mean that no relationship exists between the two variables: they might have a **non-linear relationship**
* Another common error is failing to recognize the **influence of outliers** on the correlation
	* If you have an outlier you should report both correlation coefficients (with and without the outlier) to report how influential the unusual data point is in your analysis

The **PROC CORR** also produces **scatter plots** or a **scatter plot matrix**.

```
PROC CORR DATA=SAS-data-set RANK|NOSIMPLE PLOTS(ONLY)=MATRIX(NVAR=ALL HISTOGRAM)|SCATTER(NVAR=ALL ELLIPSE=NONE) <options>;
	VAR variable(s)X;
	WITH variable(s)Y;
	ID variable4label;
RUN;
```

### Simple Linear Regression
You use correlation analysis to determine the strength of the linear relationship between continuous response variables. Now you need to go a step further and **define the linear relationship itself**: $Y= \beta_0+\beta_1*X+\epsilon$

* $Y$ is the response variable 
* $X$ is the predictor variable
* $\beta_0$ is the intercept parameter
* $\beta_1$ is the slope parameter
* $\epsilon$ is the error term

The method of **least squares** produces parameter estimates $\hat \beta_0$ and $\hat \beta_1$ with certain **optimum properties** which make them the Best Linear Unbiased Estimators (**BLUE**):

* They are **unbiased estimates** of the population parameters
* They have **minimum variance**

To find out how much better is the model that takes the predictor variable into account than a model that ignores the predictor variable, you can compare the **simple linear regression model** to a **baseline model** ($Y= \bar Y$ independent of $X$). For your comparison, you calculate the **explained**, **unexplained** and **total variability** in the simple linear regression model.

* The **explained variability (SSM)** is the difference between the regression line and the mean of the response variable: $\sum(\hat Y_i-\bar Y)^2$
* The **unexplained variability (SSE)** is the difference between the observed values and the regression line: $\sum(Y_i-\hat Y_i)^2$
* The **total variability** is the difference between the observed values and the mean of the response variable: $\sum(Y_i-\bar Y)^2$

If we consider **hypothesis testing** for linear regression:

* H0: the regression model does not fit the data better than the baseline model (slope $= 0$)
* Ha: the regression model does fit the data better than the baseline model (slope $= \hat\beta_1 \ne 0$)

These **assumptions** underlie the hypothesis test for the regression model and have to be met for a simple linear regression analysis to be valid (last three assumptions are the same as for ANOVA):

* The mean of the response variable is linearly related to the value of the predictor variable
* The error terms are normally distributed with a mean of 0
* The error terms have equal variances
* The error terms are independent at each value of the predictor variable

```
PROC REG DATA=SAS-data-set <options>;
	MODEL dependent=regressor / CLM CLI </options>;
	ID regressor;
RUN;
QUIT;
```

To asses the level of precision around the mean estimates you can produce **confidence intervals** around the means. Confidence intervals become wider as you move away from the mean of the predictor variable. The wider the confidence interval the less precise it is. You might also want to construct **prediction intervals** for a single observation. A prediction interval is wider than a confidence interval because **single observations have more variability than sample means**.

For producing **predicted values** with PROC REG:

* Create a data set containing the values of the independent variables for which you want to make predictions
* Concatenate the new data set with the original data set
* Fit a simple linear regression model to the new data set and specify the **P** option in the MODEL statement

Because the concatenated observations contain **missing values** for the response variable, PROC REG does not include these observations when fitting the regression model. However, PROC REG does **produce predicted values** for these observations.

```
DATA SAS-predictions-data-set;
	INPUT dependent @@;
	DATALINES;
[new values separated with blanks]
;
RUN;

DATA SAS-new-data-set;
	SET SAS-predictions-data-set SAS-original-data-set;
RUN;

PROC REG DATA=SAS-new-data-set;
	MODEL dependent=regressor / P;
	ID regressor;
RUN;
QUIT;
```

When you use a model to predict future values of the response variable given certain values of the predictor variable, you must **stay within (or near) the range of values for the predictor variable used to create the model**. The relationship between the predictor variable and the response variable might be different beyond the range of the data.

If you have a large data set and have already fitted the regression model, you can predict values more efficiently by using **PROC REG** and **PROC SCORE**:

```
PROC REG DATA=SAS-original-data-set NOPRINT OUTEST=SAS-estimates-data-set;
	MODEL dependent=regressor </options>;
	ID regressor;
RUN;
QUIT;

PROC SCORE DATA=SAS-predictions-data-set
		SCORE=SAS-estimates-data-set
		OUT=SAS-scored-data-set
		TYPE=PARMS
		<options>;
	VAR variable(s);
RUN;
QUIT;
```

### Multiple Regression

In **multiple regression** you can model the relationship between the response variable and **more than one predictor variable**. It is a powerful tool for both **analytical or explanatory analysis and for prediction**.

$Y=\beta_0+\beta_1X_1+\beta_2X_2+...+\beta_kX_k+\epsilon$ ($k+1$ parameters)

***Advantages***

* Multiple linear regression is a more powerful tool
* You can determine whether a relationship exists between the response variable and more than one predictor variable at the same time

***Disadvantages***

* You need to perform a selection process to decide which model to use
* The more predictors you have, the more complicated interpreting the model becomes

If we consider **hypothesis testing** for linear regression:

* H0: the regression model does not fit the data better than the baseline model ($\beta_1=\beta_2=...=\beta_k= 0$)
* Ha: the regression model does fit the data better than the baseline model (at least one $\beta_i \ne 0$)

These **assumptions** have to be met for a multiple linear regression analysis to be valid (last three assumptions are the same as for ANOVA):

* A linear function of the $X$s accurately models the mean of the $Y$s
* The error terms are normally distributed with a mean of 0
* The error terms have constant variances
* The error terms are independent at each value of the predictor variable

The **regular $R^2$** values never decrease when you add more terms to the model, but the **adjusted $R^2$** value takes into account the number of terms in the model by including a penalty for the complexity of the model. The **adjusted $R^2$** value increases only if new terms that you add significantly improve the model enough to warrant increasing the complexity of the model. It enables proper comparison between models with different parameter counts. When an **adjusted $R^2$ increases by removing a variable** from the models, it strongly implies that the removed **variable was not necessary**.

``` 
PROC REG DATA=SAS-data-set <options>;
	MODEL dependent=regressor1 regressor2 </options>;
RUN;
QUIT;

PROC GLM DATA=SAS-data-set
	PLOTS(ONLY)=(CONTOURFIT);
	MODEL dependent=regressor1 regressor2;
	STORE OUT=SAS-multiple-data-set;
RUN;
QUIT;

PROC PLM RESTORE=SAS-multiple-data-set PLOTS=ALL;
	EFFECTPLOT CONTOUR (Y=regressor1 X=regressor2);
	EFFECTPLOT SLICEFIT (X=regressor2 SLICEBY=regressor1=250 to 1000 by 250);
RUN;
```

* In PROC GLM, when you run a linear regression model with only two predictor variables, the output includes a contour fit plot by default. We specify **CONTOURFIT** to tell SAS to overlay the contour plot with a scatter plot of the observed data

![Contour plot](https://lh3.googleusercontent.com/-NLdUzu7afu8/WOJldkIvudI/AAAAAAAAACs/Vo3RCSrIwvkcOUVi8mwEiurtjsOANjBTQCLcB/s0/contour-multiple-regression.png "Contour plot")

The plot shows **predicted values** of the response variable as **gradations of the background color** from blue, representing low values, to red, representing high values. The **dots**, which are similarly coloured, represent the **actual data**. Observations that are perfectly fit would show the same color within the circle as outside the circle. The **lines on the graph** help you read the actual predictions at even intervals.

* The **CONTOUR** option displays a contour plot of predicted values against two continuous covariates
* The **SLICEFIT** option displys a curve of predicted values vs a continuous variable grouped by the levels of another effect

Clearly the **PROC GLM** contour fit plot is **more useful**. However, if you do not have access to the original data set and can run **PROC PLM** only on the item store, this plot still gives you an idea of the relationship between the predictor variables and predicted values.
	
### Model Building and Interpretation

The brute force approach to find a good model is to start including all the predictor variables available and rerun the model **removing the least significant remaining term** each time **until** you're left with a model where **only significant terms remain**. With a small number of predictor variables a manual approach isn't too difficult but with a large number of predictor variables it's very tedious. Fortunately, if you specify the model selection technique to use, SAS finds good candidate models in an automatic way.

---

***All-possible regression methods***

SAS computes all possible models and ranks the results. Then, to evaluate the models, you compare statistics side by side ($R^2$, adjusted $R^2$ and $C_p$ statistic).

* **Mallows' $C_p$** statistic helps you detect model bias if you are underfitting/overfitting the model, it is a simple indicator of effective variable selection within a model
 
* To select the best model for prediction (most accurate model for predicting future values of $Y$), you should use the **Mallows' criterion**:  $C_p \le p$, which is the **number of parameters** in the model including the intercept
* To select the best model for parameter estimation (analytical or explanatory analysis), you should use **Hocking's criterion**: $C_p\le2p-p_{full}+1$

```
PROC REG DATA=SASdata-set PLOTS(ONLY)=(CP) <options>;
	<label:> MODEL dependent=regressors  / SELECTION=CP RSQUARE ADJRSQ BEST=n </options>;
RUN;
QUIT;
``` 

* **BEST** prints an specific number of the best candidate models according to a few different statistical criteria
* **SELECTION** option is used to specify the method used to select the model (**CP**, **RSQUARE** and **ADJRSQ** to calculate with the all-possible regression model; the first statistic determines the sorting order)
* For this all-possible regression model,we add the label **ALL_REG:**
* With **PLOTS=(CP)** we produce a plot:

![Mallows' Cp to select the best model](https://lh3.googleusercontent.com/-MKHCheN7vUA/WONM3WW0qSI/AAAAAAAAADE/tHJAjyHK-QE5j4UVlxmT7KHTA_bvGJLxwCLcB/s0/mallows_cp_best_model.png "Mallows' Cp to select the best model")

Each **star** represents the **best model** for a given number of parameters. The solid **blue line** represents **Mallows' criterion** for $C_p$, so using this line helps us find a good candidate model for prediction. Because we want the **smallest model possible**, we start at the left side of the graph, with the fewest number of parameters moving to the right until we find the **first model that falls below the solid blue line**. To find models for parameter estimation we have to look for models that falls below the **red solid line** which represent the **Hocking's criterion** for $C_p$ parameter estimation. If we hover over the star, we can see which variables are included in this model.

---

***Stepwise selection methods***

Here you choose a selection method (**stepwise**, **forward** or **backward** approaches) and SAS constructs a model based on that method. When you have a **large number of potential predictor variables**, the stepwise regression methods might be a better option. You can use either the **REG** procedure or the **GLMSELECT** procedure to perform stepwise selection methods

* **Forward selection** starts with no predictor variables in the model
 1. It selects the best one-variable model
 2. It selects the best two-variable model that includes the variable from the first model (after a variable is added to the model, it stays in even if it becomes insignificant later)
 3. It keeps adding variables, one at a time, until no significant terms are left to add
* **Backward selection/elimination** starts with all predictor variables in the model
 1. It removes variables one at a time, starting with the most non-significant variable (after a variable is removed from the model, it cannot reenter)
 2. It stops when only significant terms are left in the model
* **Stepwise selection** combines aspects of both forward and backward selection
 1. It starts with no predictor variables in the model and starts adding variables, one at a time, as in forward selection
 2. However, as in backward selection, stepwise selection can drop non-significant variables, one at a time
 3. It stops when everything in the model is currently significant and everything not in the model is not significant

Statisticians in general agree on first using **stepwise methods** to identify several good candidates models and then applying your **subject matter expertise** to choose the best model. Because the techniques for selecting or eliminating variables differ between the three selection methods, **they don't always produce the same final model**. There is no one method that is best and **you need to be cautious** when reporting statistical quantities produced by these methods:

* Using automated model selections results in **biases in parameter estimates**, **predictions** and **standard errors**
* **Incorrect** calculation of **degrees of freedom**
* **p-values** that tend to err on the side of **overestimating significance**

How can you **avoid these issues**?

* You can hold out some of your data in order to perform an honest assessment of how well your model performs on a different sample of data (**holdout/validation data**) than you use to develop the model (**training data**)
* Other honest assessment approaches include **cross-validation** (if your data set is not large enough to split) or **bootstraping** (a resampling method that tries to approximate the distribution of the parameter estimates to estimate the standard error and p-values)

```
PROC GLMSELECT DATA=SAS-data-set <options>;
	CLASS variables;
	<label:> MODEL dependent(s) = regressor(s) / </options>;
RUN;
QUIT;
```

* The **SELECTION** option specifies the method to be used to select the model (**FORWARD** | **BACKWARD** | **STEPWISE** = default value)
* The **SELECT** option specifies the criterion to be used to determine which variable to add/remove from the model (**SL** = significance level as the selection criterion)
* The **SLENTRY** option determines the significance level for a variable to enter the model (default = 0.5 for forward and 0.15 for stepwise)
* The **SLSTAY** option determines the significance level for a variable to stay in the model (default = 0.1 for backward and 0.15 for stepwise)
* You can display p-values in the *Parameter Estimates* table by including the **SHOWPVALUES** option int he MODEL statement
* The **DETAILS** option specifies the level of detail produced (**ALL** | **STEPS** | **SUMMARY**)

---

Recommendations to decide which model is best for your needs:

1. Run all model selection methods
2. Look for commonalities across the results 
3. Narrow down your choice of models by using your subject matter knowledge

### Information Criterion and Other Selection Options

There are other selection criteria that you can use to select variables for a model as well as evaluate competing models. These statistics are collectively referred to as **information criteria**. Each information criterion searched for a model that minimizes the **unexplained variability** with as **few effects in the model as possible**. The model with the **smaller information criterion is considered to be better***. For types are available in **PROC GLMSELECT**:

* Akaike's information criterion (SELECT=**AIC**)
* Correcterd Akaike's information criterion (SELECT=**AICC**)
* Sawa Bayesian information criterion (SELECT=**BIC**)
* Schwarz Bayesian information criterion (SELECT=**SBC**, it could be called **BIC** in some other SAS procedures)

The calculations of all information criteria begin the same way:

1. First you calculate $n\cdot log(SSE/n)$ 
2. Then, each criterion adds a penalty that represents the complexity of the model (each type of information criterion invokes a different penalty component)
 * AIC: $2p+n+2$
 * AICC: $n(n+p)/(n-p-2)$
 * BIC: $2(p+2)1-2q^2$
 * SBC: $p\cdot log(n)$

##Model Post-Fitting for Inference
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m554/m554_4_a_sum.htm)

How to **verify the assumptions** and **diagnose problems** that you encounter in **linear regression**?

###Examining Residuals
You can use the **residual values** (difference between each observed value of $Y$ and its predicted value) from the regression analysis to verify the **assumptions of the linear regression**. Residuals are estimates of the errors, so you can **plot the residuals to check the assumptions of the errors**.

* You can plot residuals vs the predicted values to check for **violations of equal variances**
* You can also use this plot to check for **violations of linearity and independence**
* You can plot the residuals vs the values of the independent variables to **further examine any violations of equal variances** (you can see which predictor contributes to the violation of the assumption)
* You can use a histogram or a normal probability plot of the residuals to determine whether or not the **errors are normally distributed**

You want to see a **random scatter of the residual values** above and below the reference line at 0. If you see **patterns or trends** in the residual values, the assumptions might not be valid and the models might have problems.

![Assumptions violation examples](https://lh3.googleusercontent.com/-84ce_WbduHI/WOOAkeq-iiI/AAAAAAAAADs/e2ZzJE_XoLE8DnfdqNt-aaHhOzw8Z-ucgCLcB/s0/assumption-violation.PNG "Assumptions violation examples")

**Note**: To take autocorrelation (correlated over time) into account, you might need to use a regression procedure such as **PROC AUTOREG**

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

###Identifying Influential Observations

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

### Detecting Collinearity

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

## Categorical Data Analysis
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m556/m556_5_a_sum.htm)

When you response variable is categorical, you need to use a different kind of regression analysis: **logistic regression**.

### Describing Categorical Data

When you examine the distribution of a **categorical variable**, you want to know the **values** of the variable and the **frequency or count** of each value in the data (**one-way frequency able**).

```
PROC FREQ DATA=SAS-data-set;
	TABLES variable1 variable2 variable3 </options>;
	<additional statements>
RUN;
```

To look for a possible **association** between two or more categorical variables, you can create a **crosstabulation**/**contingency table** (when it displays statistics for two variables is also called **two-way frequency able**).

```
PROC FREQ DATA=SAS-data-set;
	TABLES variable-rows*variable-columns </options>;
	<additional statements>
RUN;
```

Two distribution plots are associated with a frequency or crosstabulation table: a **frequency plot**, PLOTS=**(FREQPLOT)**, and a **cumulative frequency plot**.

In PROC FREQ output, the default order for character values is **alphaumeric**. To reorder the values of an ordinal variable in your FROC FREQ output you can:

* Create a **new variable** in which the values are stored in logical order
* Apply a [**temporary format**](https://support.sas.com/edu/OLTRN/ECST131/eclibjr/tempformat.htm) to the original variable

### Tests of Association

To perform a **formal test of association** between two categorical variables, you use the (Pearson) **chi-square test** which measures the difference between the observed cell frequencies and the cell frequencies that are expected if there is no association between variables (H0 is true): 
$Expected=Row \ total\cdot Column\ total/Total \ sample \ size$

* If the **sample size decreases**, the **chi-square value decreases** and the **p-value for the chi-square statistic increases**
* Hypothesis testing: **H0**: no association; **Ha**: association

**Cramer's V statistic** is one measure of strength of an association between two categorical variables

 * For two-by-two tables, Cramer's V is in the range of -1 to 1
 * For larger tables, Cramer's V is int he range of 0 to 1 
 * Values farther away from 0 indicate a relatively strong association between the variables

To measure the strength of the association between a binary predictor variable and a binary outcome variable, you can use an **odds ratio**: $Odds \ Ratio=\frac{Odds \ of \ Outcome \ in \ Group \ B}{Odds \ of \ Outcome \ in \ Group \ A}$; $Odds=p_{event}/(1-p_{event})$

 * The value of the odds ratio can range from 0 to $\infty$; it cannot be negative
 * When the odds ratio is $1$, there is no association between variables
 * When the odds ratio $>1$/$<1$, the group in the numerator/denominator is more likely to have the outcome
 * The odds ratio is approximately the same **regardless of the sample size**
 * To estimate the true odds ratio while taking into account the variability of the sample statistic, you can calculate **confidence intervals**
 * You can use an odds ratio to **test for significance** between two categorical variables
 * Odds ratio expressed as percent difference: $(odd \ ratio -1) \cdot 100$

```
PROC FREQ DATA=SAS-data-set;
	TABLES variable-rows*variable-columns / CHISQ EXPECTED </options>;
	<additional statements>
RUN;
```

* **CHISQ** produces the Pearson chi-square test of association, the likelihood-ratio chi-square and the Mantel-Haenszel: $\sum \frac{(obs. \ freq. - exp. \ freq.)^2}{exp. \ freq.}$
* **EXPECTED** prints the expected cell frequencies
* **CELLCHI2** prints each cell's contribution to the total chi-square statistic: $ \frac{(obs. \ freq. - exp. \ freq.)^2}{exp. \ freq.}$
* **NOCOL** suppresses the printing of the column percentages
* **NOPERCENT** supresses the printing of the cell percentages
* **RELRISK** (relative risk) prints a table that contains risk ratios (probability ratios) and odds ratios; PROC FREQ uses the **classification in the first column** of the crosstabulation table as the **outcome of interest** and the first/second row in the numerator/denominator

---

For **ordinal associations**, the **Mantel-Haenszel** chi-square test is a more powerful test.

* The levels must be in a **logical order** for the test results to be meaningful
* Hypothesis testing: **H0**: no ordinal association; **Ha**: ordinal association
* Similarly to the Pearson case, the Mantel-Haenszel chi-square statistic/p-value indicate whether an association exists but not its magnitude and they depend on and reflect the sample size

To measure the **strength of the association** between two ordinal variables you can use the **Spearman correlation** statistic.

* You should only use it if both variables are ordinal and are in logical order
* Is considered to be a rank correlation because it provides a degree of association between the ranks of the ordinal variables
* This statistic has a **range between -1 and +1**: values close to -1/+1 indicate that there is a relatively high degree of negative/positive correlation and values close to 0 indicate a weak correlation
* It is **not affected by the sample size**

```
PROC FREQ DATA=SAS-data-set;
	TABLES variable-rows*variable-columns / CHISQ EXPECTED </options>;
  <additional statements>
RUN;
```

* **MEASURES** produces the Spearman correlation statistic along with other measurement of association
* **CL** produces confidence bounds for the statistics that the MEASURES option requests
* The confidence bounds are valid only if the sample size is large ($>25$)
* The asymptotic standard error (**ASE**) is used for large samples and is used to calculate the confidence intervals for various measures of association (including the Spearman correlation coefficient)

### Introduction to Logistic Regression

Logistic Regression is a generalized linear model that you can use to predict a categorical response/outcome on the basis if one or more continuous or categorical predictor variables. There are three models:

![Logistic regression types](https://lh3.googleusercontent.com/-_wxj3yC7ZCE/WOd2RpxTQOI/AAAAAAAAAEg/HYmLKYjBYr8Thq7HwseFdK3hU8Tnreo8ACLcB/s0/logistic_regression_types.PNG "Logistic regression types")

Some reasons why you **can't use linear regression** with a **binary response variable** are:

* aaa

###Multiple Logistic Regression


## Model Building and Scoring for Prediction
[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m555/m555_3_a_sum.htm)

###Introduction to Predictive Modeling

###Scoring Predictive Models