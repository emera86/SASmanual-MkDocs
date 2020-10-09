## Adjusted p-values as Part of Multiple Comparisons

We were commonly asked why multiple comparisons tests following one-way (or two-way) ANOVA don't report individual P values for each comparison, rather than simply reporting which comparisons are statistically significant. It sounds like a simple question, but the answer is not so simple. You have two options:

* Don't correct for multiple comparisons at all.  Making individual comparisons after ANOVA, without taking into account the number of comparisons. It is called the unprotected Fisher's LSD test.
* Report multiplicity adjusted p-values. 

### What are adjusted p-values?

The definition of the **adjusted p-value** is the answer to this question: **What is the smallest significance level, when applied to an entire family of comparisons, at which a particular comparison will be deemed statistically significant?**

The idea is pretty simple. There is nothing special about significance levels of 0.05 or 0.01... You can set the significance level to any probability you want. The adjusted P value is the smallest familywise significance level at which a particular comparison will be declared statistically significant as part of the multiple comparison testing.

Here is a simple way to think about it. You perform multiple comparisons twice. The first time you set the familywise significance level to 5%. The second time, you set it to 1% level. If a particular comparison is statistically significant by the first calculations (5% significance level) but is not for the second (1% significance level), its adjusted P value must be between 0.01 and 0.05, say 0.0323. 

A separate adjusted P value is computed for each comparison in a family of comparisons. But the value of these adjusted P values depends on the entire family. The adjusted P value for one particular comparison would have a different value if there were a different number of comparisons or if the data in the other comparisons were changed. 

Each comparison will have a unique adjusted P value. But these P values are computed from all the comparisons, and really can't be interpreted for just one comparison. If you added another group to the ANOVA, all of the adjusted P values would change.

## Why, When and How to Adjust Your p-values?
