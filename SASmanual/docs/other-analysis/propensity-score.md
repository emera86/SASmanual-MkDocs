## Propensity Score

### What is it and what is it for

The objective of randomization in statistics is to obtain groups that are comparable in terms of both observed and unobserved characteristics. When randomization is not possible, causal inference is complicated by the fact that a group that received a treatment or experienced an event maybe very different from another group that did not experience the event or receive the treatment. Thus, it is **not clear whether a difference in certain outcome of interest is due to the treatment or is the product of prior differences among groups**. Propensity score methods were developed to facilitate the **creation of comparison groups that are similar in terms of the distribution of observed characteristics**.

The first step involves estimating the likelihood (the propensity score) that a person would have received the treatment given certain characteristics. More formally, the propensity score is the **conditional probability of assignment to a particular treatment given a vector of observed covariates**. Two key assumptions of propensity scores are that **both the outcome of interest and the treatment assignment do not depend on unobservable characteristics**.

### Computing the Propensity Score

In order to program the corresponding model in SAS, the response variable is the group/arm to which the patient belongs and the predictors are all the baseline variables which could affect the assignment to a certain group. While the model is fitted the propensity score value can be computed and kept in an output:

```
PROC LOGISTIC DATA=input-SAS-data-set;
	CLASS sex site(param=ref);
	MODEL arm = sex age weight site serologytests / FIRTH;
	OUTPUT OUT=output-SAS-data-set PROB=ps-variable-customized-name;
RUN;
```

This kind of analysis are commonly used in observacional studies on which the patient is not randomized to a certain group but it belongs to it due to a certain diagnostic. In order to correct the possible effect of unbalanced population groups, **the propensity score value can be included in the model** as a way to isolate the effects due to the treatment from the baseline characteristics.

## Matching methods

After estimating the propensity scores, they are used to group observations that are close to each other. One way of
accomplishing this is to classify treated and untreated observations into subgroups and then separately compare the outcome
for each subgroup. This method is usually referred as **subclassification on the propensity scores** (Rosenbaum and Rubin
1984). The other way is to match one treated unit to one or more untreated controls, which is usually referred as **matching on
the propensity score** (Rosenbaum and Rubin 1983).

Key in the implementation of matching using propensity scores is to **decide what metric to use when evaluating the distance between scores** (usually the absolute value or the Mahalanobis metric) and **what type of algorithm to implement** (local or global optimal).

### Pair-matching Methods

The most common implementation is 1:1 (1 to 1) or pair-matching in which pairs of treated and untreated subjects are formed which allows to estimate for average treatment effect in the treated (ATT).
	
#### Methods without Replacement

We match each untreated subject to at most one treated subject. Once an untreated subject has been matched to a treated subject, that untreated subject is no longer eligible for consideration as a match for other treated subjects.

* Global optimal matching: forms matched pairs so as to minimize the average within-pair difference in propensity scores
* Local optimal, greedy or nearest available neighbor matching: selects a treated subject and then selects as a matched control subject the one whose propensity score is closest to that of the treated subject (if multiple untreated subjects are equally close to the treated subject, one of these untreated subjects is selected at random). In each iteration, the best (optimal) control is chosen, but this process does not guarantee that the total distance between propensity scores is minimized.
    
Four different approaches:
    * Sequentially treated subjects from highest to lowest propensity score
    * Sequentially treated subjects from lowest to highest propensity score
    * Sequentially treated subjects in the order of the best possible match (the first selected treated subject is that treated subject who is closest to an untreated subject and so on)
    * Treated subjects in a random order

* Local optimal, greedy or nearest available neighbor matching within specified caliper widths: we can match treated and untreated subjects only if the absolute difference in their propensity scores is within a prespecified maximal distance (the caliper distance, defined as a proportion of the standard deviation of the logit of the propensity score)

!!! note
    Although the propensity score is the natural metric to use, when using caliper matching, a reduction in bias due to the use of different caliper widths has been described when matching on the logit of the propensity score.
    Although it is difficult to know beforehand the optimal choice of caliper width, some researchers (Rosenbuam & Rubin, 1985; Austin, 2011) have recommended using a caliper width that is equal to 0.2 of the standard deviation of the logit of the propensity score, i.e., $0.2\cdot\sqrt\left ( \sigma^2_1+\sigma^2_2 \right )/2$.
    
    * Sequentially treated subjects from highest to lowest propensity score
    * Sequentially treated subjects from lowest to highest propensity score
    * Sequentially treated subjects in the order of the best possible match (the first selected treated subject is that treated subject who is closest to an untreated subject and so on)
    * Treated subjects in a random order

!!! note
    Optimal matching and greedy nearest neighbor matching on the propensity score will result in all treated subjects being matched to an untreated subject (assuming that the number of untreated subjects is at least as large as the number of treated subjects). However, greedy nearest neighbor matching within specified caliper widths may not result in all treated subjects being matched to an untreated subject, because for some treated subjects, there may not be any untreated subjects who are unmatched and whose propensity score lies within the specified caliper distance of that of the treated subject. The objective of the caliper matching is to avoid bad matches.
		
#### Methods with replacement

Permits the same untreated subject to be matched to multiple treated subjects (because untreated subjects are recycled or allowed to be included in multiple matched sets, the order in which the treated subjects are selected has no effect on the formation of matched pairs). Matching with replacement minimizes the propensity score distance between the matched units since each treated unit is matched to the closest control, even if the control has been selected before.

* Nearest neighbor matching with replacement: matches each treated subject to the nearest untreated subject
* Nearest neighbor matching within specified caliper widths with replacement: matches each treated subject to the nearest untreated subject (subject to possible caliper restrictions)

### 1 to N Matching Methods

They include matching each treated unit to more than one control match. This can be done by creating N replicas of each treated unit and proceeding as described above. 

### Radius Matching

All the control units within a certain distance are chosen (Dehejia and Wahba 1999).

### Mahalanobis Metric Matching

In this type of matching, the definition of distance is changed. The similarity between the propensity score of treated and untreated units is evaluated using the multidimensional Mahalanobis metric matching:
		
$D_{ij}=\sqrt{\left ( x_i-y_j \right )^TS^{-1}\left ( x_i-y_j \right )}$

where $S^{-1}$ is the pooled variance-covariance matrix and x and y are multivariate vectors. Note that if the variance-covariance
matrix is an identity matrix the Mahalanobis metric is reduced to the familiar Euclidean metric. Usually the Mahalanobis metric
matching includes the propensity score and other covariates that are considered to be important and are hoped to be balanced
(Rosenbaum and Rubin 1985).
