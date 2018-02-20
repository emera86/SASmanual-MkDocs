## One-sided vs Two-sided Tests: How do their p-values compare?

The default among statistical packages performing tests is to report two-tailed p-values.  Because the most commonly used test statistic distributions (standard normal, Student's t) are symmetric about zero, most one-tailed p-values can be derived from the two-tailed p-values.

The null hypothesis is that the difference in means is zero.  The two-sided alternative is that the difference in means is not zero. There are two one-sided alternatives that one could opt to test instead: that the difference is positive ($diff > 0$) or that the difference is negative ($diff < 0$). 

Note that the test statistic is the same for all of these tests. The two-tailed p-value is $P > |t|$. This can be rewritten as $P(>x)+P(<x)$. 

Because the t-distribution is symmetric about zero, these two probabilities are equal: $P > |t| = 2 \cdot  P(<x)$. Thus, we can see that **the two-tailed p-value is twice the one-tailed p-value** for the alternative hypothesis that ($diff < 0$).  The other one-tailed alternative hypothesis has a p-value of $P(>x)=1-(P<x)$. 

So, depending on the direction of the one-tailed hypothesis, its p-value is either $0.5 \cdot$(two-tailed p-value) or $1-0.5 \cdot$(two-tailed p-value) if the test statistic symmetrically distributed around zero. 

In summary, to understand the connection between the results, you have to carefully review the $H_a$ for each case: the one-sided analysis (there is a difference with a certain sign) is more restrictive and demanding than the two-sided (there is a difference). Therefore, it follows that
    
* the **one-tail p-value is half the two-tail p-value** and
* the **two-tail p-value is twice the one-tail p-value** (assuming you correctly predicted the direction of the difference).
    
!!! summary "Check these websites"
    * [What are the differences between one-tailed and two-tailed tests?](https://stats.idre.ucla.edu/other/mult-pkg/faq/general/faq-what-are-the-differences-between-one-tailed-and-two-tailed-tests/)
    * [One-tail vs two-tail p-values](https://www.graphpad.com/guides/prism/7/statistics/one-tail_vs__two-tail_p_values.htm?toc=0&printWindow)
    * [One-sided and two-sided tests and p-values](http://www.tandfonline.com/doi/abs/10.1080/10543409108835014)

## [McNemar's Test](https://en.wikipedia.org/wiki/McNemar%27s_test) vs [Cohen's Kappa Coefficient](https://en.wikipedia.org/wiki/Cohen%27s_kappa)

**McNemar's test** is a statistical test used on paired nominal data. It is applied to $2 \times 2$ contingency tables with a dichotomous trait, with matched pairs of subjects, to determine whether the row and column marginal frequencies are equal (that is, whether there is "marginal homogeneity"). 

The null hypothesis of marginal homogeneity states that the two marginal probabilities for each outcome are the same.

```
ODS EXCLUDE ALL;
PROC FREQ DATA=SAS-data-set;
	TABLE variable1 * variable2;
	EXACT MCNEM;
	ODS OUTPUT MCNEMARSTEST=mcnemarresults;
RUN;
ODS EXCLUDE NONE;
```

**Cohen's kappa coefficient** is a statistic which measures inter-rater agreement for qualitative (categorical) items. It is generally thought to be a more robust measure than simple percent agreement calculation, since $\kappa$ takes into account the possibility of the agreement occurring by chance. There is controversy surrounding Cohen’s Kappa due to the difficulty in interpreting indices of agreement. Some researchers have suggested that it is conceptually simpler to evaluate disagreement between items.

If the raters are in complete agreement then $\kappa=1$. If there is no agreement among the raters other than what would be expected by chance (as given by pe), $\kappa \le 0$.

Note that Cohen's kappa measures agreement between **two raters only**. The Fleiss kappa is a **multi-rater** generalization of Scott's pi statistic. Kappa is also used to compare performance in machine learning but the directional version known as Informedness or Youden's J statistic is argued to be more appropriate for supervised learning.

!!! summary "Check these websites"
    * [McNemar vs. Cohen's Kappa](http://math.usu.edu/jrstevens/biostat/projects2013/pres_mcnemarcohen.pdf)

## Yates' Correction for Continuity

Yates' correction for continuity (or Yates' chi-squared test) is used in certain situations when testing for independence in a contingency table. It is a correction made to account for the fact that both Pearson’s chi-square test and McNemar’s chi-square test are biased upwards for a 2 x 2 contingency table. An upwards bias tends to make results larger than they should be. If you are creating a 2 x 2 contingency table that uses either of these two tests, the Yates correction is usually recommended

## Cochran-Mantel-Haenszel Test

In statistics, the Cochran–Mantel–Haenszel test (CMH) is a test used in the **analysis of stratified or matched categorical data**. It allows an investigator to test the association between a binary predictor or treatment and a binary outcome such as case or control status while taking into account the stratification. It is often used in observational studies where random assignment of subjects to different treatments cannot be controlled, but confounding covariates can be measured.

The null hypothesis is that there is no association between the treatment and the outcome. More precisely, the null hypothesis is $H_{0}:R=1$ and the alternative hypothesis is $H_{1}:R\neq 1$. It follows a $\chi^{2}$ distribution asymptotically under $H_{0}$.

*  The CMH test is a **generalization of the McNemar test** as their test statistics are identical when the strata are pairs. Unlike the McNemar test which can only handle pairs, the CMH test **handles arbitrary strata size**.
* **Conditional logistic regression** is more general than the CMH test as it can handle continuous variable and perform multivariate analysis. When the CMH test can be applied, the CMH test statistic and the score test statistic of the conditional logistic regression are identical.
* The CMH test supposes that the effect of the treatment is homogeneous in all strata. The **Breslow-Day for homogeneous association test** allows to test this assumption. It should be noted that this is not a concern if the strata are small e.g. pairs.

!!! warning
    The Mantel-Haenszel statistic has 1 degree of freedom and assumes that either exposure or disease are **measured on an ordinal (or interval) scales** when you have **more than two levels**.

!!! summary "Check these websites"
    * [Example of CMH vs Fisher](http://www.biostathandbook.com/cmh.html)

## [Chi-Square test](https://en.wikipedia.org/wiki/Chi-squared_test) vs [T-test](https://en.wikipedia.org/wiki/Student%27s_t-test)

### Characteristics
A **t-test** can be either one-sided or two-sided.

The **chi-square** is The chi-squared test is essentially always a one-sided test. Here is a loose way to think about it: the chi-squared test is basically a **goodness of fit** test. Sometimes it is explicitly referred to as such, but even when it's not, it is still often in essence a goodness of fit. 

When the realized chi-squared value is way out on the right tail of it's distribution, it indicates a **poor fit**, and if it is far enough, relative to some pre-specified threshold, we might conclude that it is so poor that we don't believe the data are from that reference distribution. If we were to use the **chi-squared test as a two-sided test**, we would also be worried if the statistic were too far into the left side of the chi-squared distribution. This would mean that we are worried the **fit might be too good**. This is simply not something we are typically worried about. As a historical side-note, this is related to the controversy of whether Mendel fudged his data. The idea was that his data were too good to be true. See [here](http://www.amjbot.org/content/88/5/737.full) for more info if you're curious.

In summary, the $\chi^2$ is a two-sided test from which we are usually interested in only one of the tails of the distribution, indicating more disagreement, rather than less disagreement than one expects by chance.

### Null Hypothesis Tested
A **t-test** tests a null hypothesis about two **means**; most often, it tests the hypothesis that two means are equal, or that the difference between them is zero. 

A **chi-square** test tests a null hypothesis about the **relationship between two variables** (even with more than two levels). 

### Types of Data
A **t-test** requires two variables; **one must be categorical and have exactly two levels, and the other must be quantitative and be estimable by a mean**. 

A **chi-square** test requires **categorical variables**, usually only two, but each may have **any number of levels**.

### Relationship Between These Tests

You can refer $z$ to the standard normal table to get one-sided or two-sided $P-$values. Equivalently, for the two-sided alternative $H_0:\beta \ne \beta_0$, $z^2$ has a chi-squared distribution with $df = 1$. The $P-$value is then the right-tail chi-squared probability above the observed value. The **two-tail probability** beyond $\pm z$ for the **standard normal distribution** equals the **right-tail probability** above $z^2$ for the **chi-squared distribution with $df = 1$**. For example, the two-tail standard normal probability of $0.05$ that falls below $−1.96$ and above $1.96$ equals the right-tail chi-squared probability above $(1.96)^2 = 3.84$ when $df = 1$.

This relationship between normal and chi-square distributions can be extended to the relationship between **t-test distribution and chi-square** ones.

!!! summary "Check these websites"
    * [The difference between a t-test & a chi-square](https://sciencing.com/difference-between-ttest-chi-square-8225095.html)
    * [Introduction to Categorical Data Analysis, A. Agresti, 2007 (2nd ed.) page 11](https://mregresion.files.wordpress.com/2012/08/agresti-introduction-to-categorical-data.pdf)
    * [Test internal link Agresti 2007](../books/agresti-introduction-to-categorical-data.pdf)
