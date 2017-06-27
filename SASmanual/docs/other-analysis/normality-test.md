## Saphiro-Wilk normality test

In statistics, the **Shapiro-Wilk test** is used to test the normality of a data set. It is considered one of the most powerful tests for normality contrast, especially for small samples ($n<50$).

Monte Carlo simulations have found that Shapiro–Wilk has **the best power for a given significance**, followed closely by Anderson–Darling when comparing the Shapiro–Wilk, Kolmogorov–Smirnov, Lilliefors, and Anderson–Darling tests.

The null-hypothesis of this test is that the population is normally distributed. Thus,

* if the p-value is less than the chosen alpha level, then the null **hypothesis is rejected** and there is evidence that the data tested are **not from a normally distributed population**
* if the p-value is greater than the chosen alpha level, then the null **hypothesis cannot be rejected** 

However, since the **test is biased by sample size**, it may be statistically significant from a normal distribution in any **large samples** and a **Q–Q plot would be required for verification** in addition to the test.

```
PROC UNIVARIATE DATA=SAS-data-set;
  VAR variable;
  OUTPUT OUT=normality PROBN=probn;
RUN;
```

!!! note
    You must provide a `VAR` statement when you use an `OUTPUT` statement. To store the same statistic for several analysis variables in the `OUT=` data set, you specify a list of names in the `OUTPUT` statement. `PROC UNIVARIATE` makes a one-to-one correspondence between the order of the analysis variables in the `VAR` statement and the list of names that follow a statistic keyword.   
