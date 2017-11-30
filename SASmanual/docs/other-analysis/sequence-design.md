The aim is to form a multiple testing procedure that provides investigators with an opportunity to conduct periodic reviews of the data as they accumulate and thereby offers the chance for early termination should one treatment prove superior to the other early on while continuing to use essentially the single-phase decision rule should early termination not occur. The following is a brief description of the **O'Brien-Flemming procedure**:

1. Investigators plan to test $k$ times, including the final comparison at the end of the trial.
2. Data are reviewd periodically, with $m_1$ subjects receiving treatment 1 and $m_2$ subjects receiving treatment 2, between successive tests; there are a total of $k\cdot (m_1+m_2)$ subjects.
3. The constraint is to maintain an overall size $\alpha$, say, $\alpha = 0.05$.
4. Rule: After the $n$th test, $1 \le n \le k$, the study is terminated and $H_0$ is rejected if $(n/k)X^2 \ge P(k,\alpha)$ where $X^2$ is the usual Pearson's chi-squared statistic.
