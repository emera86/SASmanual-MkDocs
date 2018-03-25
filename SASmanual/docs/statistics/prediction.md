[Chapter summary in SAS](https://support.sas.com/edu/OLTRN/ECST131/m555/m555_3_a_sum.htm)

Inferential models, such as ANOVA and linear regression, are used to test hypotheses about the data and characterize the relationships between various types of predictor variables and a response variable. But, what if you want to go beyond explaining the relationship and **predict future values of the response variable**?

In predictive modeling, a statistical model is used to predict future values of a response variable, based on the existing values of predictor variables. In predictive modeling, the terms used to refer to the variables are often different from the terms used in explanatory modeling:

* Predictors are often called inputs, features, explanatory variables or independent variables 
* The response variable is often called a target, an outcome or dependent variable

In predictive modeling, the inputs and the target can be continuous, categorical, binary or any combination of these types.

## Introduction to Predictive Modeling

Before you can predict values, you must first build a predictive model. To build a predictive model, you can use `PROC GLMSELECT`.

* Describe the goal and uses of predictive modeling
* Explain how data partitioning is used in the hones assessment method of model selection
* Describe the relationship between model complexity and flexibility
* Use `PROC GLMSELECT` to build a predictive model

### What Is Predictive Modeling?

Predictive modeling uses historical data to predict future outcomes. The process of building and scoring a predictive model has two main parts: **building the predictive model on existing data and then deploying the model to make predictions on new data** (using a process call scoring).

A predictive model consists of either a formula or rules (depending on the type of analysis that you use) based on a set of input variables that are moes likely to predict the values of a target variable. Here we will deal with predictive models based on **regression models, which are parametric and have formulas**. Predictive models can also be based on **non-parametric models such as decision trees, which have rules**.

Model-based predictions are often called **fact-based predictions**. In contrast, decisions that are based completely on people's business expertise are often referred to as **intuition-based decisions**. Prediction modeling takes the guesswork out of the prediction process.

### Model Complexity

Whether you are doing predictive modeling or inferential modeling, you want to select a model that generalizes well, that is, the model that best fits the entire population.

You assume that a sample that is used to fit the model is representative of the population. However, any given sample typically has idiosyncracies that are not found in the population. The model that best fits a sample and the population is the model that has the right complexity.

A naive modeler might assume that most complex model should always outperform the others, but this is not the case. An overly complex model might be **too flexible**. This leads to **overfitting** that is, accomodating nuances of the random noise (the chance relationships) in the particular sample. Overfitting leads to models that have **higher variance when they are applied to a population**. For regression, including more terms in the model increases complexity.

On the other hand, an inssufficiently complex model might **not be flexible enough**. This leads to **underfitting** that is, systematically missing the signal (the true relationships). This leads to **biased inferences**, which are inferences that are not true of the population.

A model with just enough complexity, which also means **just enough flexibility**, gives the best generalization. The important thing to realize is that there is not one perfect model; there is always a balance between overfitting and underfitting.

## Scoring Predictive Models

`PROC GLMSELECT` and `PROC PLM` are used to score a new data set. The new data set is a holdout sample of data that was not used to create the model.