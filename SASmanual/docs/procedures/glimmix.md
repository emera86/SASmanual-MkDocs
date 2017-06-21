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

* `DIST` specifies the built-in (conditional) probability distribution of the data ([distrubutions available](http://documentation.sas.com/?docsetId=statug&docsetTarget=statug_glimmix_syntax17.htm&docsetVersion=14.2&locale=es#statug.glimmix.gmxdisttable))
* `LINK` specifies the link function in the generalized linear mixed model ([link functions available](http://documentation.sas.com/?docsetId=statug&docsetVersion=14.2&docsetTarget=statug_glimmix_syntax17.htm&locale=es#statug.glimmix.gmxlinktable))
    * `LINK=LOGIT` to use the **logit** link
    * `LINK=GENLOGIT | GLOGIT` to use the **generalized logit** link
    * `LINK=CUMLOGIT | CLOGIT`to use the **cumulative logit** link

## Crossing Odds Ratio Estimation

In models with `LINK=LOGIT | GLOGIT | CLOGIT`, you can obtain estimates of odds ratios through the `ODDSRATIO` options in the `PROC GLIMMIX`, `LSMEANS`, and `MODEL` statements. Note that for these link functions the `EXP` option in the `ESTIMATE` and `LSMESTIMATE` statements also produces odds or odds ratios.

`EXP` requests exponentiation of the estimate. If you specify the `CL` or `ALPHA=` option, the (adjusted) confidence bounds are also exponentiated.

For more details check the [SAS documentation](http://documentation.sas.com/?docsetId=statug&docsetTarget=statug_glimmix_details49.htm&docsetVersion=14.2&locale=es).

```
PROC GLIMMIX DATA=SAS-data-set;
  CLASS categorical1 categorical2;
  MODEL response = continuous2 continuous2 categorical1 / DIST=BINARY LINK=LOGIT ODDSRATIO SOLUTION CL;
  RANDOM intercept / SUBJECT=categorical2 SOLUTION CL;
  COVTEST / WALD;
RUN;
```

