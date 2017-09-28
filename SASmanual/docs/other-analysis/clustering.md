## Gettin' Ready for a Cluster Analysis

### Check for Missing Data

Variables with missing data should be excluded from the calculation unless they can be imputed.

### Dealing with Categorical Variables

#### Composite variables
Other questionnaire data like binary (yes/no questions) or a spectrum of responses can be transformed into **composite variables** to capture multiple questions into a **ranked ordinal scale**. A **composite variable** is a variable created by combining two or more individual variables, called indicators, into a single variable. Each indicator alone doesn't provide sufficient information, but altogether they can represent the more complex concept.

A lot of work goes into creating composite variables. The indicators of the multidimensional concept must be specified. It's important that each indicator contribute unique information to the final score. The formula for combining the indicators into a single score, called aggregating data, must be established. The computation involved will depend on the type of data that is being aggregated. To aggregate the data, raw scores might be summed, averaged, transformed, and/or weighted.

#### Hot encoding
Check [this website](https://heuristically.wordpress.com/2013/02/11/dummy-coding-sas/) for a macro to generate dummy variables.

### Methods for data reduction
You may need to reduce the number of variables to include in the analysis. There are several methods for this:

* [Principal Component Analysis with `PROC FACTOR`](https://stats.idre.ucla.edu/sas/output/principal-components-analysis/)
* [Variable Reduction for Modeling using `PROC VARCLUS`](http://www2.sas.com/proceedings/sugi26/p261-26.pdf)

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

The `CLUSTER` procedure **hierarchically clusters the observations** in a SAS data set by using one of 11 methods. The data can be coordinates or distances. 

All methods are based on the usual agglomerative hierarchical clustering procedure. Each observation begins in a cluster by itself. The two closest clusters are merged to form a new cluster that replaces the two old clusters. Merging of the two closest clusters is repeated until only one cluster is left. The various clustering methods differ in how the distance between two clusters is computed.

```
data t;
	input cid $ 1-2 income educ;
cards;
c1 5 5
c2 6 6
c3 15 14
c4 16 15
c5 25 20
c6 30 19
run;

proc cluster simple noeigen method=centroid rmsstd rsquare nonorm out=tree;
id cid;
var income educ;
run;
```

* The `SIMPLE` option displays simple, descriptive statistics. 
* The `NOEIGEN` option suppresses computation of eigenvalues. Specifying the `NOEIGEN` option saves time if the number of variables is large, but it should be used only if the variables are nearly uncorrelated or if you are not interested in the cubic clustering criterion. 
* The `METHOD=` specification determines the clustering method used by the procedure. Here, we are using `CENTROID` method. The `Centroid Distance` that appears in the output is simply the Euclidian distance between the centroid of the two clusters that are to be joined or merged. It is a measure of the homogeneity of merged clusters and the value should be small.
* The `RMSSTD` option displays the root-mean-square standard deviation of each cluster. `RMSSTD` is the pooled standard deviation of all the variables forming the cluster. Since the objective of cluster analysis is to form homogeneous groups, the `RMSSTD` of a cluster should be as small as possible.
* The `RSQUARE` option displays the $R^2$ (`RSQ`) and semipartial $R^2$ (`SPRSQ`) to evaluate cluster solution. `RSQ` measures the extent to which groups or clusters are different from each other (so, when you have just one cluster `RSQ` value is, intuitively, zero). Thus, the `RSQ` value should be high.`SPRSQ` is a measure of the homogeneity of merged clusters, i.e. the loss of homogeneity due to combining two groups or clusters to form a new group or cluster.  Thus, its value should be small to imply that we are merging two homogeneous groups. 



* The `NONORM` option prevents the distances from being normalized to unit mean or unit root mean square with most methods. 
* The values of the `ID` variable identify observations in the displayed cluster history and in the `OUTTREE=` data set. If the `ID` statement is omitted, each observation is denoted by `OBn`, where n is the observation number.
* The `VAR` statement lists numeric variables to be used in the cluster analysis. If you omit the `VAR` statement, all numeric variables not listed in other statements are used.


### `PROC FASTCLUS`

The `FASTCLUS` procedure requires time proportional to the number of observations and thus can be used with much larger data sets than `PROC CLUSTER`. If you want to cluster a very large data set hierarchically, use `PROC FASTCLUS` for a preliminary cluster analysis to produce a large number of clusters. Then use `PROC CLUSTER` to cluster the preliminary clusters hierarchically (Example [here](https://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_cluster_sect027.htm)).

!!! tip "Interesting Examples"
    * [Multivariate Statistical Analysis in SAS: Segmentation and Classification of Behavioral Data](http://support.sas.com/resources/papers/proceedings13/447-2013.pdf)

### `PROC TREE`

The `TREE` procedure produces a tree diagram from a data set created by the `CLUSTER` or `VARCLUS` procedure that contains the results of hierarchical clustering as a tree structure.

```
proc tree data=tree out=clus3 nclusters=3;
id cid;
copy income educ;
```

The `TREE` procedure produces a tree diagram, also known as a dendrogram or phenogram, using a data set created by the `CLUSTER` procedure. The `CLUSTER` procedure creates output data sets that contain the results of **hierarchical clustering as a tree structure**. The `TREE` procedure uses the output data set to produce a diagram of the tree structure.

* The `NCLUSTERS=` option specifies the number of clusters desired in the `OUT=` data set.
* The `ID` variable is used to identify the objects (leaves) in the tree on the output. The `ID` variable can be a character or numeric variable of any length. 
* The `COPY` statement specifies one or more character or numeric variables to be copied to the `OUT=` data set.

## Choosing the Optimal Number of Clusters for the Analysis 

For hierarchical clustering try the Sarle's Cubic Clustering Criterion in PROC CLUSTER:
plot _CCC_ versus the number of clusters and look for peaks where _ccc_ > 3 or look for local peaks of pseudo-F statistic (_PSF_) combined with a small value of the pseudo-t^2 statistic (_PST2_) and a larger pseudo t^2 for the next cluster fusion.
For K-Means clustering use this approach on a sample of your data to determine the max limit for k and assign it to the maxc= option in PROC FASTCLUS on the complete data. 

For K-means cluster analysis, one can use `PROC FASTCLUS` like
`proc fastclus data=mydata out=out maxc=4 maxiter=20;`
and change the number defined by `MAXC=`, and run a number of times, then compare the **Pseduo F** and **CCC** values, to see which number of clusters gives peaks.
 
or one can use `PROC CLUSTER`:
`PROC CLUSTER data=mydata METHOD=WARD out=out ccc pseudo print=15;`
to find the number of clusters with **pseudo F**, **pseudo-$t^2$** and **CCC**, and also look at junp in Semipartial R-Square.
 
Sometimes these indications do not agree to each other. which indicator is more reliable?
If you are doubting between 2 k-values, you can use Beale's F-type statistic to determine the final number of clusters. It will tell you whether the larger solution is significantly better or not (in the latter case the solution with fewer clusters is preferable).
This technique is discussed in the "Applied Clustering Techniques" course notes.

!!! summary "Check these websites"
    * [The Number of Clusters](http://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_introclus_sect010.htm)
