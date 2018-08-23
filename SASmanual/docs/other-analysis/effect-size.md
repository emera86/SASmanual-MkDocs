The effect size will be larger if

1. The absolute difference between the averages is higher, or
2. the responses are consistently close to the average values and not widely spread out (the standard deviation is low).

## T-Test

A T-Test's effect size indicates whether or not the difference between two groups' averages is large enough to have practical meaning, whether or not it is statistically significant.

## [Cohen's d](https://en.wikipedia.org/wiki/Effect_size#Cohen's_d)

Cohen's d is defined as the difference between two means divided by a standard deviation for the data, i.e.

$d = \frac{\bar{x}_1-\bar{x}_2}{s}=\frac{\mu_1-\mu_2}{s}$.

By default SPSS and SAS compute the SD as an inferential statistic (i.e., S) rather than as the population parameter (i.e., $\sigma$) by using N-1 in the denominator of the SD equation rather than N. In order to obtain Cohen's d rather than Hedge's g, the inferential statistic S will be transformed to $\sigma$.

| **Effect size** | **d** | **Reference**    |
|-----------------|-------|------------------|
| Very small      | 0.01  | Sawilowsky, 2009 |
| Small           | 0.20  | Cohen, 1988      |
| Medium          | 0.50  | Cohen, 1988      |
| Large           | 0.80  | Cohen, 1988      |
| Very large      | 1.20  | Sawilowsky, 2009 |
| Huge            | 2.00  | Sawilowsky, 2009 |

## Macro Example

```
%macro effectsize(scorelist=,scorelablist=);
	%let nscore = %eval(%sysfunc(count(&scorelist,$)) + 1);
	%do iscore=1 %to &nscore;
		%let score&iscore=%scan(&scorelist.,&iscore.,$);
		%let scorelab&iscore=%scan(&scorelablist.,&iscore.,$);

		ods exclude all;
		proc ttest data=objetivos_cambio;
			paired &&score&iscore.._fin*&&score&iscore.._bs;
			ods output Statistics=stat_&iscore. TTests=ttest_&iscore.;
		run;

		proc means data=objetivos_cambio mean stddev n skewness kurtosis t prt CLM; 
			var cambio&&score&iscore..; 
			ods output Summary=means_&iscore.;
		run;

		data cohensd_&iscore.;
			set means_&iscore.;
			t = cambio&&score&iscore.._t;
			n = cambio&&score&iscore.._n;
			df = n-1;
			d = t/sqrt(n);
			ncp_lower = TNONCT(t,df,.975);
			ncp_upper = TNONCT(t,df,.025);
			d_lower = ncp_lower/sqrt(n);
			d_upper = ncp_upper/sqrt(n);
			d_ic = '('||trim(left(put(d_lower,6.2)))||','||trim(left(put(d_upper,6.2)))||')';
			Variable1 = "&&score&iscore.._fin";
			Variable2 = "&&score&iscore.._bs";
			output; 
		run; 
		ods exclude none;

		data tab_&iscore.;
			length label Variable1 Variable2 Difference $50;
			merge stat_&iscore. ttest_&iscore. cohensd_&iscore.(keep=Variable1 Variable2 d d_ic);
			by Variable1 Variable2;
			label = "&&scorelab&iscore";
		run;
	%end;

	data final_tab;
		set 
		%do iscore=1 %to &nscore;
			tab_&iscore. 
		%end;
		;
		meansd = trim(left(put(mean,6.2)))||' ('||trim(left(put(stddev,6.2)))||')';
		cimean = '('||trim(left(put(LowerCLMean,6.2)))||','||trim(left(put(UpperCLMean,6.2)))||')';
		minmax = '('||trim(left(put(Minimum,6.2)))||','||trim(left(put(maximum,6.2)))||')';
	run;

	proc report data=final_tab nowd headline style(header)={background=very light grey fontsize=8pt} missing 
	style(column)={fontsize=8pt } split='*';
		column  ("Tamaño del efecto para muestras pareadas de objetivos primario y secundarios" (label n meansd cimean minmax probt d d_ic));
		define label / display 'Cuestionario' flow;
		define n / display 'N' flow;
		define meansd / display 'Diff. Media (DE)' flow;
		define cimean / display 'IC Diff. Media (95%)' flow;
		define minmax / display '(Mínimo, Máximo)' flow;
		define probt / display 'p-valor' flow;
		define d / display f=5.2 'd de Cohen' flow;
		define d_ic / display 'IC d de Cohen (95%)' flow;
	run;

	proc datasets lib=work nowarn nolist nodetails; 
		delete tab_: stat_: ttest_: means_: cohensd_:;
  	run; 
  	quit; 

%mend;

*%effectsize(scorelist=varname1$varname2$varname3,
			scorelablist=Variable label 1$Variable label 2$Variable label 3);
```
