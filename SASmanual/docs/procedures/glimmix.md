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
