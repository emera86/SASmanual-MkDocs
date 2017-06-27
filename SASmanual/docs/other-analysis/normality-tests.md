## Saphiro-Wilk normality test

In statistics, the **Shapiro-Wilk test** is used to test the normality of a data set. It is considered one of the most powerful tests for normality contrast, especially for small samples ($n<50$).

Monte Carlo simulations have found that Shapiro–Wilk has **the best power for a given significance**, followed closely by Anderson–Darling when comparing to the Kolmogorov–Smirnov, Lilliefors, and Anderson–Darling tests.

The null-hypothesis of this test is that the population is normally distributed. Thus,

* if the p-value is less than the chosen alpha level, then the null **hypothesis is rejected** and there is evidence that the data tested are **not from a normally distributed population**
* if the p-value is greater than the chosen alpha level, then the null **hypothesis cannot be rejected** 

However, since the **test is biased by sample size**, it may be statistically significant from a normal distribution in any **large samples** and a **Q–Q plot would be required for verification** in addition to the test.

### `PROC UNIVARIATE`

The `UNIVARIATE` procedure provides a variety of descriptive statistics, and draws Q-Q, stem-and-leaf, normal probability, and box plots. This procedure also conducts Shapiro-Wilk, Kolmogorov-Smirnov, Anderson-Darling and Cramer-von Misers tests. 

!!! note
    The Shapiro-Wilk `W` will be reported only if $N<2000$. 

```
PROC UNIVARIATE DATA=SAS-data-set NORMAL PLOT;
  VAR variable(s);
  QQPLOT variable /NORMAL(MU=EST SIGMA=EST COLOR=RED L=1);
  OUTPUT OUT=normality PROBN=probn;
RUN;
```

* `NORMAL` performs normality tests
* `PLOT` draws a stem-and-leaf and a box plots
* `QQPLOT` draws a Q-Q plot

!!! note
    You must provide a `VAR` statement when you use an `OUTPUT` statement. To store the same statistic for several analysis variables in the `OUT=` data set, you specify a list of names in the `OUTPUT` statement. `PROC UNIVARIATE` makes a one-to-one correspondence between the order of the analysis variables in the `VAR` statement and the list of names that follow a statistic keyword.   
    
### `PROC CAPABILITY`

Like `UNIVARIATE`, the `CAPABILITY` procedure also produces various descriptive statistics and plots. `CAPABILITY` can draw a P-P plot using the `PPPLOT` option but does not support stem-and-leaf, box, and normal probability plots (it does not have the `PLOT` option). 

```
PROC CAPABILITY DATA=SAS-data-set NORMAL;
  VAR variable(s);
  QQPLOT variable /NORMAL(MU=EST SIGMA=EST COLOR=RED L=1);
  PPPLOT variable /NORMAL(MU=EST SIGMA=EST COLOR=RED L=1);
  HISTOGRAM /NORMAL(COLOR=MAROON W=4) CFILL = BLUE CFRAME = LIGR;
  INSET MEAN STD /CFILL=BLANK FORMAT=5.2 ;
RUN; 
```

* `NORMAL` performs normality tests
* `QQPLOT`, `PPPLOT` and `HISTOGRAM` statements respectively draw a Q-Q plot, a P-P plot, and a histogram
* `INSET` statement adds summary statistics to graphs such as a histogram and a Q-Q plot
