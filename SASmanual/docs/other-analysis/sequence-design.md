## Theory of Hypothesis-Based Adaptive Design

An adaptive design is a design that allows adaptations or modifcations to some aspects of a trial after its initiation without undermining the validity and integrity of the trial. The adaptations may include, but are not limited to, sample-size reestimation, early stopping for effcacy or futility, response-adaptive randomization, and dropping inferior treatment groups. Adaptive designs usually require unblinding data and invoke a dependent sampling procedure. Therefore, theory behind adaptive design is much more complicated than that behind classical design.

Many interesting methods for adaptive design have been developed. Virtually all methods can be viewed as some combination of stagewise p-values. The stagewise p-values are obtained based on the subsample from each stage; therefore, they are mutually independent and uniformly distributed over [0,1] under the null hypothesis. 

The first method uses the same stopping boundaries as a classical group sequential design (**O'Brien and Fleming**, 1979; **Pocock**, 1977) and allows stopping for early efficacy or futility. Lan and DeMets (1983) proposed the **error spending method (ESM)**, in which the timing and number of analyses can be changed based on a prespecified error-spending function. ESM is derived from Brownian motion. The method has been extended to allow for sample-size reestimation (SSR) (Cui, Hung, and Wang, 1999). It can be viewed as a fixed-weight method (i.e., using fixed weights for z-scores from the first and second stages regardless of sample-size change). Lehmacher and Wassmer (1999) further degeneralized this weight method by using the inverse-normal method, in which the z-score is not necessarily taken from a normal endpoint, but from the inverse-normal function of stagewise p-values. Hence, the method can be used for any type of endpoint.

## O'Brien-Flemming

Let us start considering a two-arm trial. The usual settings for randomized two-arm clinical trials are:

1. Response is dichotomous and immediate
2. They are single-phase trials, with sample sizes fixed in advance
3. At the end of a trial, compare success rates (i.e. proportions) using a formal test of significance based on the usual Pearson, is chi-squared test.

The aim is to form a multiple testing procedure that provides investigators with an opportunity to conduct periodic reviews of the data as they accumulate and thereby offers the chance for early termination should one treatment prove superior to the other early on while continuing to use essentially the single-phase decision rule should early termination not occur. The following is a brief description of the **O'Brien-Flemming procedure**:

1. Investigators plan to test $k$ times, including the final comparison at the end of the trial.
2. Data are reviewd periodically, with $m_1$ subjects receiving treatment 1 and $m_2$ subjects receiving treatment 2, between successive tests; there are a total of $k\cdot (m_1+m_2)$ subjects.
3. The constraint is to maintain an overall size $\alpha$, say, $\alpha = 0.05$.
4. Rule: After the $n$th test, $1 \le n \le k$, the study is terminated and $H_0$ is rejected if $(n/k)X^2 \ge P(k,\alpha)$ where $X^2$ is the usual Pearson's chi-squared statistic.

Using the theory of Brownian motion, O'Brien and Fleming (1979) obtained the values for $P(k,\alpha)$ but, more importantly, they concluded that they are approximately the $(1-\alpha)th$ percentile of the chi-squared distribution with 1 degree of freedom -- almost independent of $k$.

