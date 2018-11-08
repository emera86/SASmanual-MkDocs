https://www.stat-d.si/mz/mz13.1/p4.pdf

Odds Ratio, Hazard Ratio and Relative Risk

## Relative Risk

In medical studies, probability of seeing a certain event in some group is usually called risk, while epidemiologists might prefer the term incidence (Savitz, 1992). For comparison of risks between groups, **the ratio of risks, or the relative risk**, is a statistic of choice.
Formally, if $\pi_1$ is the probability of the event in group 1, and $\pi_2$ is the probability of the event in group 2, then the relative risk is 

$RR=\frac{\pi_1}{\pi_2}$

The reason of preferring relative risk over the difference of risks lies in the fact that the population risks of most diseases are rather small and so differences less dramatic (Walter, 2000).

## Odds Ratio

The other statistics, commonly encountered in medical literature, is the odds ratio (Bland and Altman, 2000). Odds are the ratio of the probability of an event occurring in a group, divided by the probability of that event not occurring

$odds= \frac{\pi}{1-\pi}$

For example, if probability of death in a group is 0.75, the odds are equal to 3, since the probability of death is three times higher than the probability of surviving.

If risk was the same in both groups, the odds would be equal. A comparison of odds, the odds ratio, might then make sense.

$OR= \frac{\frac{\pi_1}{1-\pi_1}}{\frac{\pi_2}{1-\pi_2}}$

This is very different from the relative risk calculated on the same data and may come as a surprise to some readers who are accustomed of thinking of odds ratio as of relative risk (Greenland, 1987).

## Hazard Ratio



## Comparison

### Relative risk and odds ratio

The literature dealing with the relation between relative risk and odds ratio is quite extensive. It can be deduced that 

$OR=RR \frac{1-\pi_2}{1-\pi_1}$

From this we see that OR is always further away from 1 than RR. But, more importantly, we see that the odds ratio is close to the relative risk **if probabilities of the outcome are small** (Davies et al., 1998). And it is this fact that enables us, most of the time, to approximate the relative risk with the odds ratio.

### Relative risk and hazard ratio

https://www.students4bestevidence.net/tutorial-hazard-ratios/

One of the main differences between **risk ratio (relative risk)** and **hazard ratio** is that risk ratio does not care about the timing of the event but only about the occurrence of the event by the end of the study (i.e. whether they occurred or not: the total number of events by the end of the study period). In contrast, hazard ratio takes account not only of the total number of events, but also of the timing of each event.

So most of the confusion, or wrong perception, probably comes from this 'natural' line of thought: if hazard ratio is $k$ at all times, then the relative risk must be $k$ at all times. And this is of course wrong.

Relative risk (RR) is a ratio of two probabilities: probability of an event in one group divided by the probability of the same event in the other group. When studying survival, we have to **explicitly state in which time interval we are calculating this probability**.

Maybe the easiest way to understand that a hazard ratio cannot be equal to the relative risk for any time t is to realize that eventually everybody dies, so the relative risk will approach 1 with time, even though the hazard ratio is constant.
