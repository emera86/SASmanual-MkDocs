Survival analysis is a branch of statistics for analyzing the expected duration of **time until one or more events happen**. Survival analysis attempts to answer questions such as: what is the proportion of a population which will survive past a certain time? Of those that survive, at what rate will they die or fail? Can multiple causes of death or failure be taken into account? How do particular circumstances or characteristics increase or decrease the probability of survival? To answer such questions, it is necessary to define **lifetime** with [`PROC LIFETEST`](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/viewer.htm#statug_lifetest_toc.htm).

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

## P-value of a Lifetest Analysis

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

## Informative censoring

!!! summary "Check these papers"
    * [Censoring in survival analysis: Potential for bias](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3275994/)
    * [Impact of Informative Censoring on the Kaplan-Meier Estimate of Progression-Free Survival in Phase II Clinical Trials](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4162501/)
