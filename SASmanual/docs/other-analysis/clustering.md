## Gettin' Ready for a Cluster Analysis

### Check for Missing Data

Variables with missing data should be excluded from the calculation unless they can be imputed.

### Methods for data reduction
You may need to reduce the number of variables to include in the analysis. There are several methods for this:

* [Principal Component Analysis with `PROC FACTOR`](https://stats.idre.ucla.edu/sas/output/principal-components-analysis/)
* [Variable Reduction for Modeling using `PROC VARCLUS`](http://www2.sas.com/proceedings/sugi26/p261-26.pdf)

### Dealing with Categorical Variables

#### Composite variables
Other questionnaire data like binary (yes/no questions) or a spectrum of responses can be transformed into **composite variables** to capture multiple questions into a **ranked ordinal scale**. A **composite variable** is a variable created by combining two or more individual variables, called indicators, into a single variable. Each indicator alone doesn't provide sufficient information, but altogether they can represent the more complex concept.

A lot of work goes into creating composite variables. The indicators of the multidimensional concept must be specified. It's important that each indicator contribute unique information to the final score. The formula for combining the indicators into a single score, called aggregating data, must be established. The computation involved will depend on the type of data that is being aggregated. To aggregate the data, raw scores might be summed, averaged, transformed, and/or weighted.

#### Hot encoding
Check [this website](https://heuristically.wordpress.com/2013/02/11/dummy-coding-sas/) for a macro to generate dummy variables.

### Standardize your Data
When performing multivariate analysis, having variables that are measured at different scales can influence the numerical stability and precision of the estimators. Standardizing the data prior to performing statistical analysis can often prevent this problem.

!!! summary "Check these websites"
    * [Standardization Procedures](https://support.sas.com/rnd/app/stat/procedures/Standardization.html)
    * [Standardization of Variables in Cluster Analysis](https://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_stdize_sect020.htm)

### Preliminary Discriminant Analysis

* [Discriminant Function Analysis in SAS (UCLA)](https://stats.idre.ucla.edu/sas/dae/discriminant-function-analysis/)
* [Introduction to Discriminant Procedures](http://documentation.sas.com/?docsetId=statug&docsetTarget=statug_introdisc_toc.htm&docsetVersion=14.2)

## SAS Procedures to Perform Cluster Analysis 

Ward's minimum-variance hierarchical clustering method using agglomerative (bottom-up) approach and Ward's linkage.

!!! summary "Check these websites"
    * [Introduction to Clustering Procedures](http://documentation.sas.com/?docsetId=statug&docsetTarget=statug_introclus_toc.htm&docsetVersion=14.2)

### `PROC CLUSTER`

The `CLUSTER` procedure hierarchically clusters the observations in a SAS data set by using one of 11 methods. The data can be coordinates or distances. 

All methods are based on the usual agglomerative hierarchical clustering procedure. Each observation begins in a cluster by itself. The two closest clusters are merged to form a new cluster that replaces the two old clusters. Merging of the two closest clusters is repeated until only one cluster is left. The various clustering methods differ in how the distance between two clusters is computed.

### `PROC FASTCLUS`

The `FASTCLUS` procedure requires time proportional to the number of observations and thus can be used with much larger data sets than `PROC CLUSTER`. If you want to cluster a very large data set hierarchically, use `PROC FASTCLUS` for a preliminary cluster analysis to produce a large number of clusters. Then use `PROC CLUSTER` to cluster the preliminary clusters hierarchically (Example [here](https://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_cluster_sect027.htm)).

!!! tip "Interesting Examples"
    * [Multivariate Statistical Analysis in SAS: Segmentation and Classification of Behavioral Data](http://support.sas.com/resources/papers/proceedings13/447-2013.pdf)

### `PROC TREE`

The `TREE` procedure produces a tree diagram from a data set created by the `CLUSTER` or `VARCLUS` procedure that contains the results of hierarchical clustering as a tree structure.

