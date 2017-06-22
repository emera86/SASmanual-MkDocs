Modelling a binary reponse variable:

```
PROC GLIMMIX DATA=SAS-data-set;
  CLASS categorical1 categorical2;
  MODEL response = continuous2 continuous2 categorical1 / DIST=BINARY LINK=LOGIT ODDSRATIO SOLUTION CL;
  RANDOM intercept / SUBJECT=categorical2 SOLUTION CL;
  COVTEST / WALD;
RUN;
```

Modelling a multinomial reponse variable:

```
PROC GLIMMIX DATA=SAS-data-set;
  CLASS categorical1 categorical2;
  MODEL response = continuous2 continuous2 categorical1 / DIST=MULTINOMIAL LINK=CLOGIT ODDSRATIO SOLUTION CL;
  RANDOM intercept / SUBJECT=categorical2 SOLUTION CL;
  COVTEST / WALD;
RUN;
```

* `LINK` specifies the link function in the generalized linear mixed model ([link functions available](http://documentation.sas.com/?docsetId=statug&docsetVersion=14.2&docsetTarget=statug_glimmix_syntax17.htm&locale=es#statug.glimmix.gmxlinktable))
    * `LINK=LOGIT` to use the **logit** link
    * `LINK=GENLOGIT | GLOGIT` to use the **generalized logit** link
    * `LINK=CUMLOGIT | CLOGIT` to use the **cumulative logit** link
* `DIST` specifies the built-in (conditional) probability distribution of the data ([distrubutions available and their corresponfing default link functions](http://documentation.sas.com/?docsetId=statug&docsetTarget=statug_glimmix_syntax17.htm&docsetVersion=14.2&locale=es#statug.glimmix.gmxdisttable))

## Estimating an Odds Ratio for a Variable Involved in an Interaction

In models with `LINK=LOGIT | GLOGIT | CLOGIT`, you can obtain estimates of odds ratios through the `ODDSRATIO` options in the `PROC GLIMMIX`, `LSMEANS`, and `MODEL` statements. Note that for these link functions the `EXP` option in the `ESTIMATE` and `LSMESTIMATE` statements also produces odds or odds ratios. The `ODDSRATIO` option on the `PROC GLIMMIX` statement, requests odds ratio calculations for main effects. 

`EXP` requests exponentiation of the estimate (`ESTIMATE` statement) or least squares means estimate (`LSMESTIMATE` statement). If you specify the `CL` or `ALPHA=` option, the (adjusted) confidence bounds are also exponentiated.

For nonnormal data, the `EXP` and `ILINK` options give you a way to obtain the quantity of interest on the scale of the
mean (inverse link). Results presented in this fashion can be much easier to interpret than data on the link scale. 

```
PROC GLIMMIX DATA=SAS-data-set;
  CLASS categorical1 categorical2;
  MODEL response = continuous2 continuous2 categorical1 / DIST=BINARY LINK=LOGIT ODDSRATIO SOLUTION CL;
  RANDOM intercept / SUBJECT=categorical2 SOLUTION CL;
  COVTEST / WALD;
RUN;
```

!!! note
    * For more details check the [SAS documentation](http://documentation.sas.com/?docsetId=statug&docsetTarget=statug_glimmix_details49.htm&docsetVersion=14.2&locale=es)
    * An example different procedures (`PROC LOGISTIC` and `PROC GLIMMIX`) can be found [here](http://support.sas.com/kb/24/455.html)
    * Some other options are also discussed [here](http://support.sas.com/resources/papers/proceedings11/216-2011.pdf) and [here](https://support.sas.com/resources/papers/proceedings11/351-2011.pdf)
