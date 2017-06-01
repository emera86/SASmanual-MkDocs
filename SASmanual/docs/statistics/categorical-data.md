[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m556/m556_5_a_sum.htm)

When you response variable is categorical, you need to use a different kind of regression analysis: **logistic regression**.

## Describing Categorical Data

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

Two distribution plots are associated with a frequency or crosstabulation table: a **frequency plot**, `PLOTS=(FREQPLOT)`, and a **cumulative frequency plot**.

In `PROC FREQ` output, the default order for character values is **alphaumeric**. To reorder the values of an ordinal variable in your `PROC FREQ` output you can:

* Create a **new variable** in which the values are stored in logical order
* Apply a [**temporary format**](https://support.sas.com/edu/OLTRN/ECST131/eclibjr/tempformat.htm) to the original variable
* How to [replace the variable's name with the variable's label in `PROC FREQ` output](http://support.sas.com/kb/23/350.html)

```
options validvarname=any;
PROC FREQ DATA=SAS-data-set (RENAME=(variable1="Label variable 1"n variable1="Label variable 1"n));
	TABLES "Label variable 1"n;
RUN;
```

## Tests of Association

### Pearson Chi-square Test

To perform a **formal test of association** between two categorical variables, you use the (Pearson) **chi-square test** which measures the difference between the observed cell frequencies and the cell frequencies that are expected if there is no association between variables ($H_0$ is true): 
$Expected=Row \ total\cdot Column\ total/Total \ sample \ size$

* If the **sample size decreases**, the **chi-square value decreases** and the **p-value for the chi-square statistic increases**
* Hypothesis testing: **$H_0$**: no association; **$H_a$**: association

### Cramer's V statistic

It is one **measure of strength of an association** between two categorical variables:

 * For two-by-two tables, Cramer's V is in the range of -1 to 1
 * For larger tables, Cramer's V is int he range of 0 to 1 
 * Values farther away from 0 indicate a relatively strong association between the variables

To measure the strength of the association between a binary predictor variable and a binary outcome variable, you can use an **odds ratio**: $Odds \ Ratio=\frac{Odds \ of \ Outcome \ in \ Group \ B}{Odds \ of \ Outcome \ in \ Group \ A}$; $Odds=p_{event}/(1-p_{event})$

 * The value of the odds ratio can range from 0 to $\infty$; it cannot be negative
 * When the odds ratio is 1 , there is no association between variables
 * When the odds ratio >1/<1, the group in the numerator/denominator is more likely to have the outcome
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

* `CHISQ` produces the Pearson chi-square test of association, the likelihood-ratio chi-square and the Mantel-Haenszel: $\sum \frac{(obs. \ freq. - exp. \ freq.)^2}{exp. \ freq.}$
* `EXPECTED` prints the expected cell frequencies
* `CELLCHI2` prints each cell's contribution to the total chi-square statistic: $ \frac{(obs. \ freq. - exp. \ freq.)^2}{exp. \ freq.}$
* `NOCOL` suppresses the printing of the column percentages
* `NOPERCENT` supresses the printing of the cell percentages
* `RELRISK` (relative risk) prints a table that contains risk ratios (probability ratios) and odds ratios; `PROC FREQ` uses the **classification in the first column** of the crosstabulation table as the **outcome of interest** and the first/second row in the numerator/denominator

### Mantel-Haenszel chi-square test

For **ordinal associations**, the **Mantel-Haenszel** chi-square test is a more powerful test.

* The levels must be in a **logical order** for the test results to be meaningful
* Hypothesis testing: **$H_0$**: no ordinal association; **$H_a$**: ordinal association
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

* `MEASURES` produces the Spearman correlation statistic along with other measurement of association
* `CL` produces confidence bounds for the statistics that the MEASURES option requests
* The confidence bounds are valid only if the sample size is large (>25)
* The asymptotic standard error (**ASE**) is used for large samples and is used to calculate the confidence intervals for various measures of association (including the Spearman correlation coefficient)

## Introduction to Logistic Regression

Logistic Regression is a generalized linear model that you can use to predict a categorical response/outcome on the basis if one or more continuous or categorical predictor variables. There are three models:

![Logistic regression types](https://lh3.googleusercontent.com/-_wxj3yC7ZCE/WOd2RpxTQOI/AAAAAAAAAEg/HYmLKYjBYr8Thq7HwseFdK3hU8Tnreo8ACLcB/s0/logistic_regression_types.PNG "Logistic regression types")

Some reasons why you **can't use linear regression** with a **binary response variable** are:

* Reason 1

## Multiple Logistic Regression
