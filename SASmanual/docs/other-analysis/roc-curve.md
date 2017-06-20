In statistics, a **receiver operating characteristic curve (ROC curve)**, is a graphical plot that illustrates the diagnostic ability of a binary classifier system as its discrimination threshold is varied. The ROC curve is created by plotting the **true positive rate (TPR) against the false positive rate (FPR)** at various threshold settings. The true-positive rate is also known as **sensitivity**. The false-positive rate is also known as the fall-out and can be calculated as **(1 − specificity)**.

ROC analysis provides tools to **select possibly optimal models and to discard suboptimal ones** independently from (and prior to specifying) the cost context or the class distribution.

## Macro `ROCPLOT`

Produce a plot of the **Receiver Operating Characteristic (ROC)** curve associated with a fitted binary-response model. Label points on the ROC curve using statistic or input variable values. Identify optimal cutpoints on the ROC curve using several optimality criteria such as correct classification, efficiency, cost, and others. Plot optimality criteria against a selected variable.

When only an ROC plot with labeled points is needed, you can often produce the desired plot in `PROC LOGISTIC` without this macro. Using  `ODS graphics`, `PROC LOGISTIC` can plot the ROC curve of a model whether applied to the data used to fit the model or to additional data scored using the fitted model. Specify the `PLOTS=ROC` option in the `PROC LOGISTIC` statement, or specify the `OUTROC=` option in the `MODEL` and/or `SCORE` statements.

```
PROC LOGISTIC (…) plots(only)=roc(id=obs);
	MODEL (…) / OUTROC=ROC_data;
RUN;
```

More information on this macro [here](http://support.sas.com/kb/25/018.html).
