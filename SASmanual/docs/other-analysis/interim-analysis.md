The purpose of the `SEQDESIGN` procedure is to design interim analyses for clinical trials. 

In a **fixed-sample trial**, data about all individuals are first collected and then examined at the end of the study. In contrast, a **group sequential trial** provides for interim analyses before the completion of the trial while maintaining the specified overall Type I and Type II error probabilities.

A group sequential trial is most useful in situations where it is important to monitor the trial to prevent unnecessary exposure of patients to an unsafe new drug, or alternatively to a placebo treatment if the new drug shows significant improvement. In most cases, if a group sequential trial **stops early for safety concerns**, fewer patients are exposed to the new treatment than in the fixed-sample trial. If a trial **stops early for efficacy reasons**, the new treatment is available sooner than it would be in a fixed-sample trial. Early stopping can also save time and resources.

A **group sequential design** provides detailed specifications for a group sequential trial. In addition to the usual specification for a fixed-sample design, it provides the total number of stages (the number of interim stages plus a final stage) and a stopping criterion to reject, to accept, or to either reject or accept the null hypothesis at each interim stage. It also provides critical values and the sample size at each stage for the trial.

![Flowchart](http://support.sas.com/documentation/cdl/en/statug/68162/HTML/default/images/seqchart.png)

## `PROC SEQDESIGN`
You use the `SEQDESIGN` procedure compute the initial boundary values and required sample sizes for the trial. 

## `PROC SEQTEST`
You use the `SEQTEST` procedure to compare the test statistic with its boundary values.
