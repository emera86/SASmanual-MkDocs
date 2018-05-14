## What Is Survival Analysis?

!!! summary "Check these websites"
    * [Análisis de supervivencia](https://www.sgapeio.es/INFORMEST/VICongreso/taller/applets/biomates/super/super.htm)
    * [Introduction to survival analysis in SAS](https://stats.idre.ucla.edu/sas/seminars/sas-survival/)
    * [A SAS Macro to Generate Information Rich Kaplan-Meier Plots](https://www.lexjansen.com/pharmasug/2018/AD/PharmaSUG-2018-AD25.pdf)
    * [Kaplan-Meier Survival Plotting Macro %NEWSURV](http://www.sascommunity.org/wiki/Kaplan-Meier_Survival_Plotting_Macro_%25NEWSURV)
    * [Application of Survival Analysis in Multiple Events Using SAS](https://www.lexjansen.com/pharmasug/2018/EP/PharmaSUG-2018-EP02.pdf)

Survival analysis models factors that influence the time to an event. Ordinary least squares regression methods fall short because the time to event is typically not normally distributed, and the model cannot handle censoring, very common in survival data, without modification. **Nonparametric methods** ([`PROC LIFETEST`](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/viewer.htm#statug_lifetest_toc.htm)) provide simple and quick looks at the survival experience and the **Cox proportional hazards regression model** ([`PROC PHREG`](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/viewer.htm#statug_phreg_overview.htm)) remains the dominant analysis method.

## Endpoints in Clinical Trials Related to Survival Analysis

### Overall Survival

OS is the **gold standard for demonstrating clinical benefit**. Defined as the time from **randomization to death**, this endpoint is unambiguous and is not subject to investigator interpretation. Survival is a direct clinical benefit to patients, and assessment can be calculated to the day. Patient benefit can be described as superior survival or noninferior survival after consideration of toxicity and the magnitude of benefit. A noninferiority analysis ensures that a survival advantage associated with an approved drug will not be lost with a new agent.

**Survival analysis requires a large sample size and may require long follow-up**. Survival analysis may be confounded because of subsequent therapies administered after a study drug is discontinued. OS should be evaluated in randomized, controlled trials.

### Time to Tumor Progression and Progression-Free Survival

**Time to tumor progression (TTP)**, is defined as the time from **randomization to time of progressive disease**. The **progression-free survival (PFS)** duration is defined as the time from **randomization to objective tumor progression or death**. Compared with TTP, PFS may be a preferred regulatory endpoint because it includes death and may correlate better with OS. In TTP analysis, deaths are censored either at the time of death or at an earlier visit. 

Assessment of either PFS or TTP needs to be conducted in randomized trials. Because of the subjectivity that may be introduced in endpoint assessment, blinding of trials or the use of an external blinded review committee is recommended. In assessing TTP or PFS, patients must be evaluated on a regular basis in all treatment arms, and an assessment of all disease sites should be performed. To reduce bias, the same assessment technique should be used at each follow-up, and the same evaluation schedule should be consistently used.

### Time to Treatment Failure

**Time to treatment failure (TTF)** is defined as the time from **randomization to treatment discontinuation for any reason**, including disease progression, treatment toxicity, patient preference, or death. From a regulatory point of view, TTF is generally not accepted as a valid endpoint. TTF is a composite endpoint influenced by factors unrelated to efficacy. Discontinuation may be a result of toxicity, patient preference, or a physician's reluctance to continue therapy. These factors are not a direct assessment of the effectiveness of a drug.

## Understanding the Basis of Survival Analysis

Understanding the mechanics behind survival analysis is aided by facility with the distributions used, which can be derived from the **probability density function** and **cumulative density functions** of survival times.

### The Probability Density Function

Imagine we have a random variable, $Time$, which records survival times. The function that describes likelihood of observing $Time$ at time $t$ relative to all other survival times is known as the probability density function (**pdf**), or $f(t)$. Integrating the pdf over a range of survival times gives the probability of observing a survival time within that interval. For example, if the survival times were known to be exponentially distributed, then the probability of observing a survival time within the interval $\left [ a,b \right ]$ is 

$Pr\left ( a \leq Time \leq b \right )=\int_{a}^{b}f(t)dt=\int_{a}^{b} \lambda e^{-\lambda t}dt$, 

where $\lambda$ is the rate parameter of the exponential distribution and is equal to the reciprocal of the mean survival time.

Most of the time we will not know *a priori* the distribution generating our observed survival times, but we can get and idea of what it looks like using nonparametric methods in SAS with `PROC UNIVARIATE`. 

```
PROC UNIVARIATE DATA=SAS-data-set(WHERE=(censoring-variable=1));
	VAR survival-time-variable;
	HISTOGRAM survival-time-variable / KERNEL;
RUN;
```

In the graph above we see the correspondence between pdfs and histograms. Density functions are essentially histograms comprised of bins of vanishingly small widths. Technically, because there are no times less than $0$, there should be no graph to the left $Time=0$.

### The Cumulative Distribution Function

The cumulative distribution function (**cdf**), $F(t)$, describes the probability of observing $Time$ less than or equal to some time $t$, or $Pr(Time \le t)$. Above we described that integrating the pdf over some range yields the probability of observing $Time$ in that range. Thus, we define the cumulative distribution function as:

$F(t)=\int_{0}^{t}f(t)dt$

The above relationship between the cdf and pdf also implies:

$f(t)=\frac{dF(t)}{dt}$

In SAS, we can graph an estimate of the cdf using `PROC UNIVARIATE`.

```
PROC UNIVARIATE DATA=SAS-data-set(WHERE=(censoring-variable=1));
	VAR survival-time-variable;
	CDFPLOT survival-time-variable;
RUN;
```

In the graph produced with the code above we can check the probability of surviving a number of days. In intervals where event times are more probable, the cdf will increase faster.

### The Survival Function

A simple transformation of the cumulative distribution function produces the survival function, $S(t)$:

$S(t) = 1 - F(T)$.

The survivor function, $S(t)$, describes the probability of surviving past time $t$, or $Pr(Time > t)$. If we were to plot the estimate of $S(t)$, we would see that it is a reflection of $F(t)$ (about $y=0$ and shifted up by $1$). We can use `PROC LIFETEST` to graph $S(t)$.

```
PROC LIFETEST DATA=SAS-data-set(WHERE=(censoring-variable=1)) PLOTS=SURVIVAL(ATRISK);
	TIME survival-time-variable*censoring-variable(0);
RUN; 
```

The probability of surviving beyond a number of days according to this survival plot can be confirmed by the cdf produced above, where the probability of surviving a number of days or fewer is equivalent.

### The Hazard Function

The primary focus of survival analysis is typically to **model the hazard rate**, which has the following relationship with the $f(t)$ and $S(t)$:

$h(t)=\frac{f(t)}{S(t)}$

The hazard function, then, describes the relative likelihood of the event occurring at time $t(f(t))$, conditional on the subject’s survival up to that time $t(S(t))$. The hazard rate thus describes the instantaneous rate of failure at time $t$ and ignores the accumulation of hazard up to time $t$ (unlike $F(t)$ and $S(t)$). We can estimate the hazard function is SAS as well using `PROC LIFETEST`:

```
PROC LIFETEST DATA=SAS-data-set(WHERE=(censoring-variable=1)) PLOTS=HAZARD(BW=200); /* BW = Bandwidth*/
	TIME survival-time-variable*censoring-variable(0);
RUN; 
```

The plot shows the Estimated Hazard Rate which is the expected number of failures per time unit (per day in our example).

### The Cumulative Hazard Function

Also useful to understand is the cumulative hazard function, which as the name implies, cumulates hazards over time. It is calculated by integrating the hazard function over an interval of time:

$H(t)=\int_{0}^{t}h(u)du$

Let us again think of the hazard function, $h(t)$, as the rate at which failures occur at time $t$. Let us further suppose, for illustrative purposes, that the hazard rate stays constant at $\frac{x}{t}$ ($x$ number of failures per unit time $t$) over the interval $[0,t]$. Summing over the entire interval, then, we would expect to observe $x$ failures, as $\frac{x}{t} t = x$, (assuming repeated failures are possible, such that failing does not remove one from observation). One interpretation of the cumulative hazard function is thus the expected number of failures over time interval $[0,t]$. It is not at all necessary that the hazard function stay constant for the above interpretation of the cumulative hazard function to hold, but for illustrative purposes it is easier to calculate the expected number of failures since integration is not needed. Expressing the above relationship as $\frac{d}{dt}H(t)=h(t)$, we see that the hazard function describes the rate at which hazards are accumulated over time.

Using the equations, $h(t)=\frac{f(t)}{S(t)}$ and $f(t)=−\frac{dS}{dt}$, we can derive the following relationships between the cumulative hazard function and the other survival functions:

$S(t)=exp(-H(t))$

$F(t)=1-exp(-H(t))$

$f(t)=h(t) \cdot exp(-H(t))$

From these equations we can see that the cumulative hazard function $H(t)$ and the survival function $S(t)$ have a simple monotonic relationship, such that when the Survival function is at its maximum at the beginning of analysis time, the cumulative hazard function is at its minimum. As time progresses, the Survival function proceeds towards it minimum, while the cumulative hazard function proceeds to its maximum. From these equations we can also see that we would expect the pdf, $f(t)$, to be high when $h(t)$ the hazard rate is high (its location depends on the study) and when the cumulative hazard $H(t)$ is low (the beginning, for all studies). In other words, we would expect to find a lot of failure times in a given time interval if 

1. the hazard rate is high and 
2. there are still a lot of subjects at-risk.

We can estimate the cumulative hazard function using `PROC LIFETEST`, the results of which we send to `PROC SGPLOT` for plotting. 

```
ODS OUTPUT ProductLimitEstimates=PLE;

PROC LIFETEST DATA=SAS-data-set whas500(WHERE=(censoring-variable=1)) NELSON OUTS=output-name;
	TIME survival-time-variable*censoring-variable(0);
RUN;

PROC SGPLOT DATA=PLE;
	SERIES x = survival-time-variable y = CumHaz;
RUN;
```

## Data Preparation and Exploration

### Structure of the Data

To work with `PROC LIFETEST` and `PROC PHREG` for survival analysis, data can be structured in one of these 2 ways:

1. **One row of data per subject**, with one outcome variable representing the time to event, one variable that codes for whether the event occurred or not (censored), and explanatory variables of interest, each with fixed values across follow up time. Both `PROC LIFETEST` and `PROC PHREG` will accept data structured this way.
2. **Multiple rows of data per subject** (only accepted by `PROC PHREG`) following the "counting process" style of input. For each subject, the whole follow up period is partitioned into intervals, each defined by a "start" and "stop" time. Covariates are permitted to change value between intervals. Additionally, another variable counts the number of events occurring in each interval (either 0 or 1 in Cox regression, same as the censoring variable). This structuring allows the modeling of time-varying covariates, or explanatory variables whose values change across follow-up time. 

Data that are structured in the first, single-row way can be modified to be structured like the second, multi-row way, but the reverse is typically not true.

### Data Exploration with `PROC UNIVARIATE` and `PROC CORR`

Any serious endeavor into data analysis should begin with data exploration, in which the researcher becomes familiar with the distributions and typical values of each variable individually, as well as relationships between pairs or sets of variables. Within SAS, [`PROC UNIVARIATE`]() provides easy, quick looks into the distributions of each variable, whereas [`PROC CORR`]() can be used to examine bivariate relationships.

## Nonparametric Methods ([`PROC LIFETEST`](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/viewer.htm#statug_lifetest_toc.htm))

```
oms = (lastcontact - starttreatment + 1) / 30.45
if exdate = . then censor = 1;
else censor = 0;

PROC LIFETEST DATA=SAS-data-set plots=(s);
  TIME osm * censor(1);   
	STRATA alg              /* aleatorization group, (= . they didn't get to randomization) */
RUN;
```

* In the `TIME` statement, only patients that haven't been censored are analysed 
* The `STRATA` statement includes only non-missing data points (no `WHERE` filtering is needed) 

!!! tip
    If you are performing a survival analysis which only applies to part of your population but you need the probabilities to be referred to the total population just define the excluded subpopulation as having event at time = 0. This way your plot will not start at 1/0. This applies, for example, to **locoregional control time** plots on which patients without complete response are excluded (event at time = 0) and 

### P-value Calculation

We select only 2 groups from the test data set (High and Low risk):

```
DATA bmt_small;
	SET SASHELP.bmt;
	WHERE group IN (2, 3);
RUN;
```

We generate the `OUTSURV` data set:

```
PROC LIFETEST DATA=bmt_small PLOTS=SURVIVAL(CL CB=HW STRATA=PANEL) METHOD=LT INTERVALS=(0 to 800 by 100) OUTSURV=bmt_param STDERR;
   TIME t * status(0);
   STRATA group / ORDER=INTERNAL; 
run;
```

We calculate the p-values from this data:

```
PROC SQL;
	SELECT t, range(survival) AS RangeSurvival, sqrt(sum(sdf_stderr**2)) AS Squares, range(survival)/sqrt(sum(sdf_stderr**2)) AS z,
	       probnorm(abs(range(survival)/sqrt(sum(sdf_stderr**2)))) AS pz, 2 * (1-probnorm(abs(range(survival)/sqrt(sum(sdf_stderr**2))))) AS pvalue
  	FROM btm_param 
	WHERE t > 0
   	GROUP BY t;
QUIT;
```

Other method:

```
DATA bmt600 ;
  brazo='A'; valor=1; contador=32; OUTPUT;
  brazo='A'; valor=2; contador=13; OUTPUT;
  brazo='B'; valor=1; contador=18; OUTPUT;
  brazo='B'; valor=2; contador=36; OUTPUT;
RUN;

PROC FREQ DATA=bmt600;
	TABLES brazo*valor / CHISQ MEASURES RISKDIFF PLOTS=(FREQPLOT(TWOWAY=GROUPVERTICAL SCALE=PERCENT));
	WEIGHT contador;
RUN;
```

## Cox Proportional Hazards Regression Model ([`PROC PHREG`](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/viewer.htm#statug_phreg_overview.htm))

## Censoring

* **Right-censoring**: for some subjects we do not know when they died after the issue, but we do know at least how many days they survived.

### Informative Censoring

!!! summary "Check these papers"
    * [Censoring in survival analysis: Potential for bias](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3275994/)
    * [Impact of Informative Censoring on the Kaplan-Meier Estimate of Progression-Free Survival in Phase II Clinical Trials](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4162501/)
