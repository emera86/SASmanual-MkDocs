## Endpoints in Clinical Trials Related to Survival Analysis

### Overall Survival

OS is the **gold standard for demonstrating clinical benefit**. Defined as the time from **randomization to death**, this endpoint is unambiguous and is not subject to investigator interpretation. Survival is a direct clinical benefit to patients, and assessment can be calculated to the day. Patient benefit can be described as superior survival or noninferior survival after consideration of toxicity and the magnitude of benefit. A noninferiority analysis ensures that a survival advantage associated with an approved drug will not be lost with a new agent.

**Survival analysis requires a large sample size and may require long follow-up**. Survival analysis may be confounded because of subsequent therapies administered after a study drug is discontinued. OS should be evaluated in randomized, controlled trials.

### Time to Tumor Progression and Progression-Free Survival

**Time to tumor progression (TTP)**, is defined as the time from **randomization to time of progressive disease**. The **progression-free survival (PFS)** duration is defined as the time from **randomization to objective tumor progression or death**. Compared with TTP, PFS may be a preferred regulatory endpoint because it includes death and may correlate better with OS. In TTP analysis, deaths are censored either at the time of death or at an earlier visit. 

Assessment of either PFS or TTP needs to be conducted in randomized trials. Because of the subjectivity that may be introduced in endpoint assessment, blinding of trials or the use of an external blinded review committee is recommended. In assessing TTP or PFS, patients must be evaluated on a regular basis in all treatment arms, and an assessment of all disease sites should be performed. To reduce bias, the same assessment technique should be used at each follow-up, and the same evaluation schedule should be consistently used.

### Time to Treatment Failure

**Time to treatment failure (TTF)** is defined as the time from **randomization to treatment discontinuation for any reason**, including disease progression, treatment toxicity, patient preference, or death. From a regulatory point of view, TTF is generally not accepted as a valid endpoint. TTF is a composite endpoint influenced by factors unrelated to efficacy. Discontinuation may be a result of toxicity, patient preference, or a physician's reluctance to continue therapy. These factors are not a direct assessment of the effectiveness of a drug.


## What Is Survival Analysis?

!!! summary "Check these websites"
    * [Análisis de supervivencia](https://www.sgapeio.es/INFORMEST/VICongreso/taller/applets/biomates/super/super.htm)
    * [Introduction to survival analysis in SAS](https://stats.idre.ucla.edu/sas/seminars/sas-survival/)
    * [A SAS Macro to Generate Information Rich Kaplan-Meier Plots](https://www.lexjansen.com/pharmasug/2018/AD/PharmaSUG-2018-AD25.pdf)
    * [Kaplan-Meier Survival Plotting Macro %NEWSURV](http://www.sascommunity.org/wiki/Kaplan-Meier_Survival_Plotting_Macro_%25NEWSURV)

Survival analysis models factors that influence the time to an event. Ordinary least squares regression methods fall short because the time to event is typically not normally distributed, and the model cannot handle censoring, very common in survival data, without modification. **Nonparametric methods** ([`PROC LIFETEST`](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/viewer.htm#statug_lifetest_toc.htm)) provide simple and quick looks at the survival experience, and the **Cox proportional hazards regression model** ([`PROC PHREG`](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/viewer.htm#statug_phreg_overview.htm)) remains the dominant analysis method.

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

## Informative Censoring

!!! summary "Check these papers"
    * [Censoring in survival analysis: Potential for bias](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3275994/)
    * [Impact of Informative Censoring on the Kaplan-Meier Estimate of Progression-Free Survival in Phase II Clinical Trials](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4162501/)
