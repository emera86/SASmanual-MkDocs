## [McNemar's Test](https://en.wikipedia.org/wiki/McNemar%27s_test) vs [Cohen's Kappa Coefficient](https://en.wikipedia.org/wiki/Cohen%27s_kappa)

**McNemar's test** is a statistical test used on paired nominal data. It is applied to 2 × 2 contingency tables with a dichotomous trait, with matched pairs of subjects, to determine whether the row and column marginal frequencies are equal (that is, whether there is "marginal homogeneity"). 

The null hypothesis of marginal homogeneity states that the two marginal probabilities for each outcome are the same.

**Cohen's kappa coefficient** is a statistic which measures inter-rater agreement for qualitative (categorical) items. It is generally thought to be a more robust measure than simple percent agreement calculation, since $\kappa$ takes into account the possibility of the agreement occurring by chance. There is controversy surrounding Cohen’s Kappa due to the difficulty in interpreting indices of agreement. Some researchers have suggested that it is conceptually simpler to evaluate disagreement between items.

If the raters are in complete agreement then $\kappa=1$. If there is no agreement among the raters other than what would be expected by chance (as given by pe), $\kappa \le 0$.

Note that Cohen's kappa measures agreement between **two raters only**. The Fleiss kappa is a **multi-rater** generalization of Scott's pi statistic. Kappa is also used to compare performance in machine learning but the directional version known as Informedness or Youden's J statistic is argued to be more appropriate for supervised learning.

## Yates' Correction for Continuity

Yates' correction for continuity (or Yates' chi-squared test) is used in certain situations when testing for independence in a contingency table. It is a correction made to account for the fact that both Pearson’s chi-square test and McNemar’s chi-square test are biased upwards for a 2 x 2 contingency table. An upwards bias tends to make results larger than they should be. If you are creating a 2 x 2 contingency table that uses either of these two tests, the Yates correction is usually recommended

## Chi-Squared/Fisher Exact Test vs Cochran-Mantel-Haenszel Test

In statistics, the Cochran–Mantel–Haenszel test (CMH) is a test used in the **analysis of stratified or matched categorical data**. It allows an investigator to test the association between a binary predictor or treatment and a binary outcome such as case or control status while taking into account the stratification. It is often used in observational studies where random assignment of subjects to different treatments cannot be controlled, but confounding covariates can be measured.

The null hypothesis is that there is no association between the treatment and the outcome. More precisely, the null hypothesis is $H_{0}:R=1$ and the alternative hypothesis is $H_{1}:R\neq 1$.

*  The CMH test is a **generalization of the McNemar test** as their test statistics are identical when the strata are pairs. Unlike the McNemar test which can only handle pairs, the CMH test **handles arbitrary strata size**.
* **Conditional logistic regression** is more general than the CMH test as it can handle continuous variable and perform multivariate analysis. When the CMH test can be applied, the CMH test statistic and the score test statistic of the conditional logistic regression are identical.
* The CMH test supposes that the effect of the treatment is homogeneous in all strata. The **Breslow-Day for homogeneous association test** allows to test this assumption. It should be noted that this is not a concern if the strata are small e.g. pairs.



