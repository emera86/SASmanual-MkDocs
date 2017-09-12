## `PROC CLUSTER`

The `CLUSTER` procedure hierarchically clusters the observations in a SAS data set by using one of 11 methods. The data can be coordinates or distances. 

All methods are based on the usual agglomerative hierarchical clustering procedure. Each observation begins in a cluster by itself. The two closest clusters are merged to form a new cluster that replaces the two old clusters. Merging of the two closest clusters is repeated until only one cluster is left. The various clustering methods differ in how the distance between two clusters is computed.

## `PROC FASTCLUS`

The `FASTCLUS` procedure requires time proportional to the number of observations and thus can be used with much larger data sets than `PROC CLUSTER`. If you want to cluster a very large data set hierarchically, use `PROC FASTCLUS` for a preliminary cluster analysis to produce a large number of clusters. Then use `PROC CLUSTER` to cluster the preliminary clusters hierarchically (Example [here](https://support.sas.com/documentation/cdl/en/statug/63033/HTML/default/viewer.htm#statug_cluster_sect027.htm)).

!!! tip "Interesting Examples"
    * [Multivariate Statistical Analysis in SAS: Segmentation and Classification of Behavioral Data](http://support.sas.com/resources/papers/proceedings13/447-2013.pdf)

## `PROC TREE`

The TREE procedure produces a tree diagram from a data set created by the CLUSTER or VARCLUS procedure that contains the results of hierarchical clustering as a tree structure.
