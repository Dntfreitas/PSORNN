Skip to content
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@Dntfreitas 
Dntfreitas
/
PSORNN
1
0
0
 Code
 Issues 0
 Pull requests 0 Actions
 Projects 0
 Wiki
 Security 0
 Insights
 Settings
PSORNN/example5.text
@Dntfreitas Dntfreitas Updated README
19e9aed 2 minutes ago
904 lines (732 sloc)  41.3 KB
  
Introduction
============

Neural networks are a set of algorithms which are designed to identify patterns in the data. The resemblance with the human brain allows the neural networks to be used for many real-time applications, e.g., building self-driving cars, spam or non-spam prediction, detection of fraud, anomaly detection. The neural networks can perform a variety of tasks, e.g., classification, clustering and predictive modelling. This
study deals with exploring the concepts of predictive analytics by
time-series analysis and data fitting.

Time-Series Analysis
--------------------

Time-series is a collection of data based on time. As an instance, a
collection of sales data from the past six months daily or the number of
patients diagnosed with a disease, each month for a period of the last
five years. Time is an independent variable for time-series analysis
which is used future forecasting.

Time-series analysis requires vital factors to be considered, e.g.,
autocorrelation, seasonality or stationarity in the data.
Autocorrelation means similarity in the data after a fixed time lag,
whereas seasonality refers to the presence of periodic patterns in the
data.

Autocorrelation and seasonality are interrelated to each other in the
sense that autocorrelated data ensures data seasonality. On the other
hand, stationarity in the data means that the mean and variance in the
data do not alter with respect to time.

Time-series modelling requires mitigating the effect of autocorrelation
and seasonality and encouraging stationarity in the time-series.

Data Fitting
------------

Training a model can lead to the problem of overfitting or underfitting,
which ends up training inaccurate and less powerful models for
classification or regressions tasks. These problems arise due to lack of
optimised learnable parameters.

Data fitting, or curve fitting, helps in alleviating the effects of
overfitting or underfitting. It deals with enhancing the quality of
mapping between data and targets by optimising the learnable parameters.
It allows the selection of appropriate neural network architectures and
continuous learning of parameters until the termination condition is
reached. The termination conditions can be, e.g., achieving the maximum
number of iterations when no convergence is detected during model
training. The result of data fitting is the optimised parameters of the
model.

The study aims at using two optimisation algorithms:
Levnenberg--Maquardt algorithm (LMA) and Particle Swarm Optimisation
(PSO) for time-series analysis and data fitting, followed an analysis of
the results for both, in terms of Mean Squared Error (MSE) and
Coefficient of Correlation (R). Each data set was divided into
sequential blocks originating other three data sets: training (70%),
validation (15%) and test data set (15%).

This paper is organised as follows: in Section [2](#sec:methods), the methods and algorithms that will be used in this work to seasonal adjust the time-series and for feature selection are presented. Also, in this section, the LMA is introduced, as well as the PSO algorithm. In turn, Section [3](#sec:results) presents the results of the comparison between
the LMA and PSO. Finally, the last section presents some concluding
remarks.

Methods and Algorithms 
======================

Seasonal Adjustment
-------------------

Data variations on time-series are, in most cases, related with, e.g.,
the current economic situation, technological and health care
developments, and even with the environmental issues. As a consequence,
cyclical fluctuations can be present on the time-series over the time
considered. These repeated patterns can happen daily, weekly, monthly or
yearly, and are known as seasonal variations.

When one time-series has a strong seasonal component, the relations
between the independent variable(s) and the dependent variable(s) are
often obfuscated by these periodic fluctuations.

To overcome this problem, one should remove the seasonal variation of
the time-series, in order to obtain a different time-series, but with
less dispersion than original. Thus, it is possible to better understand
the relation between variables. The process of removing the seasonal
variation is known as seasonal adjustment.

Before getting into to the details of the method followed for the
seasonal adjustment, it essential to decompose the time-series into
three basic patterns: trend ($t$), seasonality ($s$) and irregular
variations ($\epsilon$). In this view, it is possible to distinguish two
types of models.

When the variance does not change over the time-series, one time-series
is said to follow an additive model. However, when the amplitude
increases with the level, the time-series is characterised as being a
multiplicative model.

If the model of the time-series is considered to be an additive model,
then each observation $k$ can be decomposed as follows: $$\label{eq:add}
    y_k = t_k + s_k + \epsilon_k.$$

On the other hand, when the model of the time-series is considered to be
a multiplicative model, the observation $k$ is given by:
$$\label{eq:multi}
    y_k = t_k \cdot s_k \cdot \epsilon_k.$$

According to Equation [\[eq:add\]](#eq:add){reference-type="eqref"
reference="eq:add"}, the seasonality component ($s$) can be removed from
the times series by taking: $$\label{eq:addyk}
    y_k - t_k  =  + s_k + \epsilon_k,$$ or, according to
Equation [\[eq:multi\]](#eq:multi){reference-type="eqref"
reference="eq:multi"}: $$\label{eq:multiyk}
    \dfrac{y_k}{t_k} = s_k \cdot \epsilon_k.$$

Thus, in order to compute an estimative of $s_k$, one needs to remove
the trend component first from the time-series, and then compute the
estimative of $s_k$, according to
Equations [\[eq:addyk\]](#eq:addyk){reference-type="eqref"
reference="eq:addyk"}
or [\[eq:multiyk\]](#eq:multiyk){reference-type="eqref"
reference="eq:multiyk"}. One commonly followed approach to identify the
different time-series' components is known as the X--11
method [@shiskin1965x], and it was introduced by Shiskin in 1965.

### The X--11 Method

The X--11 method is an iterative approach, for the reason that in order
to identify the seasonality, it is necessary to know the trend and to
obtain a good estimative of the trend, it is necessary to deseasonalise
the original series.

In this view, the X--11 method can be summarised into four main steps:

1.  Compute an estimative of the trend component using a two-sided
    centred moving averages, such as the Henderson filter;

2.  Having the estimative of the trend component, it is possible to
    obtain a new time-series with the seasonal and irregular components;

3.  Since this new time-series has both the seasonal and irregular
    components, a seasonal filter is applied in order to lessen the
    irregularities in the data;

4.  Compute the adjusted data, and return to step 1) using
    Equation [\[eq:add\]](#eq:add){reference-type="eqref"
    reference="eq:add"}
    or [\[eq:multi\]](#eq:multi){reference-type="eqref"
    reference="eq:multi"} only once.

A two-sided moving average (MA) is a statistical procedure identical to
a simple average; however, the average is centred in each observation
$k$. The objective of MA is to smooth the time-series, acting like a
filter, in order to estimate a component. The MA can be expressed as:
$$\text{MA}_k = \dfrac{1}{L}\sum^{d}_{j=-d} y_{k+j},$$ where $L$
corresponds to the period of the cycles in the time-series and is an odd
number given by $L=2d+1$. When $L$ is even, and thus defined by $L=2d$,
the MA can be expressed as:
$$\text{MA}_k = \dfrac{1}{L}\sum^{d-1}_{j=-d} y_{k+j}.$$

In turn, the Henderson filter is a more elaborated MA mechanism, that
considers both symmetrical and asymmetrical weights, especially for the
start and end values of the time-series.

Feature Selection
-----------------

Feature selection is an essential task in machine learning algorithms
and in statistics. The objective of the feature selection is to select a
subset of features, from all features collected, according to their
importance to the output variable(s).

By just selecting a subset of features, one is simplifying the model,
requiring less computational resources in order to compute it (e.g.,
execution time and memory), and also avoids that the model learns
specific information about the data set, such as noise (i.e., avoid
overfitting).

In order to select which subset of features are more relevant to the
output(s) variable(s), a myriad of strategies exist, such as from simply
use the variance in order to remove features with low variance, to using
the univariate feature selection based on F-tests.

Univariate feature selection is considered a filter method, meaning that
it only considers the relationship between each independent variable and
its importance for the output variable(s). In turn, the importance of
each independent feature to the output variable(s) is calculate by the
F-statistic, given by: $$\label{eq:fsts}
    F = \dfrac{\Big (\dfrac{\text{RSS}_1-\text{RSS}_2}{p_2-p_1}\Big )}{\Big ( \dfrac{\text{RSS}_2}{n-p_2} \Big )},$$
where $\text{RSS}_i$ and $p_i$ are, respectively, the residual sum of
square and the number of features of the model $i$. $n$, in turn,
denotes the number of samples in the data set.

Equation [\[eq:fsts\]](#eq:fsts){reference-type="eqref"
reference="eq:fsts"} compares the model one with model two, under the
null hypothesis that the model two does not prove to be statistically
better, in terms of fitting, when compared to model one. If the null
hypothesis is rejected, then the model two performs equal or better than
the model one.

Finally, features are sorted according to the computed F-statistic
value, and the user/researcher is then responsible for choosing the
number of features to be used in the predictive model.

Particle Swarm Optimisation
---------------------------

Particle swarm optimisation (PSO) is a stochastic optimisation technique
for linear and nonlinear functions (also known as fitness function),
suggested by Eberhart and Kennedy [@kennedy; @eberhart] in 1995.

PSO starts with random initialisation of particles between the
boundaries of the $d$-dimensional search space of the fitness function.
Each particle has its fitness value, which is decided by the fitness
function, a position and a velocity, which enables it to move in the
problem space.

The PSO algorithm is an iterative process which tends to find the
optimal solution by the movement of particles. In each iteration, every
particle is updated with its best fitness value $p_{\text{best}}$ and
global best fitness value achieved by any particle in the swarm
$g_{\text{best}}$. These values are then used for updating the particle
velocity, such as [@shi]: $$\label{eq:vel}
    v_{\text{new}}= \omega \cdot v + l_1 \cdot r_1 \cdot \Big( p_{\text{best}}-x \Big) + l_2\cdot r_2 \cdot \Big(g_{\text{best}}-x \Big),$$
where $v_{\text{new}}$ is the new velocity, $\omega$ is known as the
inertia term and controls the influence of the previous velocity in the
next particle's velocity $v$. $l_1$ and $l_2$ are the learning
parameters, and $r_1$ and $r_2$ are random numbers with values ranging
between 0 and 1. Finally, $x$ is the current position of the particle.

In turn, the position of the particle is updated as: $$\label{eq:pos}
    x_{\text{new}} = x + v_{\text{new}}.$$

The algorithm stops on reaching the maximum number of iterations or when
an appropriate solution is found, according to a predefined accuracy,
being the output of the algorithm the position of the best particle in
the swarm.

In order to use the PSO algorithm to find the optimal weights of an
Artificial Neural Network (ANN), each particle can be seen as a
different ANN. The weights of the ANN represent the position of the
particle in the search space, and the fitness value is given by the MSE
of the ANN in the training data set.

Particles move in the search space according to
Equations [\[eq:vel\]](#eq:vel){reference-type="eqref"
reference="eq:vel"} and [\[eq:pos\]](#eq:pos){reference-type="eqref"
reference="eq:pos"}, and the output of the algorithm is the position
(i.e., the weights) of the best particle in the swarm in terms of the
MSE in the validation data set.

Levenberg--Marquardt Backpropagation
------------------------------------

The Levenberg--Marquardt algorithm (LMA) is an optimisation algorithm,
which is used to solve the least square fitting problem. It was
suggested by Kenneth Levenberg and improved later by Donald
Marquardt [@levenberg1944method; @marquardt1963algorithm].

Mathematically, given a set of pairs of dependent $(x_i)$ and
independent variable ($y_i$) as $(x_i,y_i)$, $i=1, 2, 3, \cdots, n$.,
the objective is to find the optimal set of parameters ($\mathbf{P}$),
such that the sum of squared error deviation $\mathbf{S(P)}$ can be
minimised as follows:
$$\mathbf{\hat{P}} \in \text{argmin}_{\mathbf{\hat{P}}} \; \mathbf{S(P)} \equiv \text{argmin}_{\mathbf{\hat{P}}} \sum_{i = 1}^{m}  \Big [y_i-f(x_i, \mathbf{P})\Big]^2,$$
being $m$ the number of samples in the data set.

The LMA is an iterative procedure which starts with random
initialisation of $\mathbf{P}$ (vector or scalar), and at each
iteration, $\mathbf{P}$ is updated, i.e., $\mathbf{P}$ is updated to
$\mathbf{P} + \mathbf{\delta}$.

For $\mathbf{\delta}$ value determination,
$f(x_i,\mathbf{P} + \mathbf{\delta})$ has to be linearised, so the
equation, according to the Taylor series expansion, becomes:
$$f(x_i,\mathbf{P} + \mathbf{\delta}) \approx f(x_i,\mathbf{P})+\mathbf{J}_i\mathbf{\delta},$$
where $\mathbf{J}$ is the gradient of $f$ with respect to $\mathbf{P}$
and it is given by (Jacobian matrix):
$$J_i = \frac{\partial f(x_i,\mathbf{P})}{\partial \mathbf{P}}$$

The minimum of $S(\mathbf{P})$ is found at $\mathbf{J}\delta=0$. The
first order approximation for $f(x_i,\mathbf{P} + \mathbf{\delta})$ is:
$$S(\mathbf{P}+\delta) = \sum_{i=1}^{m}\Big[y_i-f(x_i,\mathbf{P})-\mathbf{J}_i\delta \Big]^2.$$

The vectorised form of the above equation is as follows:
$$S(\mathbf{P}+\delta) = \parallel \mathbf{y}- \mathbf{f(P)} - \mathbf{J}\delta\parallel^2.$$

Differentiating the above term with respect the $\delta$ and equating it
to 0 gives:
$$(\mathbf{J}^T\mathbf{J})\delta=\mathbf{J}^T\Big[ \mathbf{y}-\mathbf{f}(\mathbf{P})  \Big],$$
where $J$ is the singular Jacobian matrix of size $m \times n$, and
$\mathbf{y}$ and $\mathbf{f}(\mathbf{P})$ are the vector components for
the $i^{\text{th}}$ sample $y_i$ and $f(x_i,\mathbf{P})$, respectively.

The above equation is given by Marquardt. In turn, Levenberg added an
parameter, $\lambda \mathbf{I}$, making it the damped version:
$$(\mathbf{J}^T\mathbf{J}+ \lambda \mathbf{I})\delta=\mathbf{J}^T\Big[ \mathbf{y}-\mathbf{f}(\mathbf{P})  \Big],$$
where $\mathbf{I}$ is an identity matrix and thus:
$$\delta= \Big [\mathbf{J}^T\mathbf{J}+ \lambda \mathbf{I} \Big]^{-1} \mathbf{J}^T\Big[ \mathbf{y}-\mathbf{f}(\mathbf{P})  \Big].$$

The $\lambda$ is adjusted at each iteration of the algorithm to ensure
the minimisation of $S(\mathbf{P})$.

The LMA is also called the mixture of Gauss--Newton method and Gradient
Descent. If $S(\mathbf{P})$ is minimised at a faster rate, a small
change in $\lambda$ is required. This makes the algorithm to behave like
Gauss--Newton method. On the other hand, if the change in $\lambda$ is
not sufficient enough for minimisation, then $\lambda$ has to be
increased, leading to the algorithm to taking the steps in the direction
of the negative gradient. This makes the algorithm to behave like
Gradient Descent.

The initialisation of $\lambda$ is random. At the next step, it is
decreased by $\frac{\lambda}{v}$, where $v>1$. If this does not minimise
the $S(\mathbf{P})$, then the value of $\lambda$ can be increased by a
factor of $v^k(\lambda v^k)$, being $v$ and $k$ chosen by the
user/researcher.

Results {#sec:results}
=======

This study deals with time-series analysis for the urban traffic in São
Paulo -- Brazil, monthly milk production and data fitting for QSAR fish
toxicity and wine quality data sets. The neural network used for
time-series analysis is a nonlinear autoregressive with exogenous input
(NARX), whereas for data fitting a two-layered feed-forward network with
hidden sigmoid neurons and linear output neurons (`fitnet`) was used.

Two structures of NARX network were considered: open-loop and
closed-loop. In Fig. [1](#fig:archopen){reference-type="ref"
reference="fig:archopen"} and [2](#fig:archclosed){reference-type="ref"
reference="fig:archclosed"} a visual representation of both structures
is given, where $x(t)$ represents the independent variables and $y(t)$
the dependent variable values of a time-series. It also important to
note that number of delays was set to be two, meaning that the ANN will
be based on the previous two values to predict the following value in
the time-series.

In an open-loop architecture, the real output is used instead of feeding
back the estimated output given by the ANN, as it happens in the
closed-loop architecture. For the following tests, the ANN were trained
using an open-loop architecture. Nevertheless, the same ANN was also
used to test the closed-loop accuracy.

![An example of the NARX in open-loop for the urban traffic in São Paulo
-- Brazil -- data set.](img/arch.png){#fig:archopen width="\\linewidth"}

![An example of the NARX in closed-loop for the urban traffic in São
Paulo -- Brazil -- data set.](img/arch1.png){#fig:archclosed
width="\\linewidth"}

The ANNs for time-series analysis and data fitting were tested ten times
for each number of neurons in the hidden layer considered: 4, 7, 10, 12,
15 and 20. Besides that, the initial weights were set in the range
$[-2.4/I, 2.4/I]$, where $I$ is the number of inputs.

Each data set was split into a training (70%), validation (15%) and test
data set (15%), being divided using blocks of sequential indices.

On the other hand, the number of epochs was defined to be 5, and the
error limit was set to be zero. For this set of tests, the early
stopping of the algorithm was not used.

The LMA algorithm was parameterised so that the initial $\lambda$ was
set to be equal to 1, with increments of 10 and decrements of 0.1. On
the other hand, 24 particles were used with PSO. Besides that,
$\omega = 0.9$, $l_1 = 0.5$ and $l_2 = 0.3$.

Tests were executed from the above-mentioned data sets, under different
experimental conditions. In these experiments, it was included a
comparison between the performance of the LMA and PSO. The performance
metrics used for the evaluation of models are discussed in the next
subsection and were used only in the test data set.

Performance metrics
-------------------

### Mean Squared Error (MSE)

It is important to note that the MSE is computed as follows:
$$\text{MSE} = \dfrac{1}{m}\sum_{i=1}^{m}(Y_i - \hat{Y}_i)^2,$$ where
$m$ is the number of samples in the data set, $Y_i$ is the observed
value and $\hat{Y}_i$ the predicted value computed by the model. Of
course that, the closer $\hat{Y}_i$ is to $Y_i$, the lower the MSE value
will be.

### Coefficient of Correlation *R*

The coefficient of correlation measures the degree of correlation
between the actual and predicted target values. R is mathematically
defined as:
$$R_{Y\hat{Y}} = \dfrac{\sigma_{Y\hat{Y}}}{\sigma_{Y} \sigma_{\hat{Y}}},$$
where $\sigma_{Y\hat{Y}}$ is the population covariance, and $\sigma_{Y}$
and $\sigma_{\hat{Y}}$ are the population standard deviations

If $\sigma_{Y\hat{Y}} \approx \sigma_{Y} \sigma_{\hat{Y}}$, then the R
value will be approximately equal to 1 or -1, indicating that the model
has a strong positive or negative relationship with the real values.
Whereas when $\sigma_{Y\hat{Y}} >> \sigma_{Y} \sigma_{\hat{Y}}$ or
$\sigma_{Y\hat{Y}} << \sigma_{Y} \sigma_{\hat{Y}}$, R can stay away from
1, indicating that the model can not find a relationship between the
real target and the computed targets.

Urban Traffic in São Paulo -- Brazil
------------------------------------

This data set consists of the urban traffic behaviour of the São Paulo,
a city in Brazil. It includes the urban traffic data from December. 14,
2009, to December. 18, 2009, between 7:00 to 20:00, with a time interval
of 30 minutes. The data set contains 135 samples and 18 attributes:
hour, immobilised bus, broken truck, vehicle excess, accident victim,
running over, fire vehicles, occurrence involving freight, incident
involving dangerous freight, lack of electricity, fire, point of
flooding, manifestations, defect in the network of trolleybuses, tree on
the road, semaphore off, intermittent semaphore, and slowness in traffic
(the target variable).

### Seasonal Adjustment

Before analysing the data set, the seasonal adjustment procedure (X--11
method) was conducted in the time-series. In this case, the repeated
patters can happen daily, every thirty minutes.

The original and seasonally adjusted time-series can be found on
Fig. [3](#fig:traffori){reference-type="ref" reference="fig:traffori"}.
As can be seen in the original time-series, the amplitude increases with
the level, meaning that the time-series is characterised as being a
multiplicative model
(Equation [\[eq:multi\]](#eq:multi){reference-type="eqref"
reference="eq:multi"}).

![The original and the seasonally adjusted time-series of the urban
traffic in São Paulo -- Brazil.](img/traffori.eps){#fig:traffori
width="\\linewidth"}

The final time-series is a more smooth line, when compared with the
original time-series, that contains only the approximately constant
trend ($t$) and the irregular variations ($\epsilon$) components of the
original time-series.

### Feature Selection

When analysing the variance of the features of the data set presented in
Table [1](#tab:traffvar){reference-type="ref" reference="tab:traffvar"},
it is possible to observe that variables have a minimal variation, being
the broken truck, point of flooding and defect in the network of
trolleybuses the features with the highest variance. However, since the
seasonal component (i.e., the hour) was removed from the time-series, it
is expected that this variable contributes very little to the variation
of the dependent variable.

::: {#tab:traffvar}
  **Feature**                             **Variance**
--------------------------------------- --------------
  Broken Truck                            1.215
  Defect in the network of trolleybuses   0.671
  Point of flooding                       0.508
  Accident victim                         0.485
  Immobilised bus                         0.435
  Lack of electricity                     0.255
  Semaphore off                           0.215
  Running over                            0.120
  Manifestations                          0.050
  Tree on the road                        0.043
  Vehicle excess                          0.029
  Intermittent Semaphore                  0.015
  Fire Vehicles                           0.007
  Occurrence involving freight            0.007
  Incident involving dangerous freight    0.007
  Fire                                    0.007

  : Variance of the features of the urban traffic in São Paulo -- Brazil
  -- data set.
:::

Following the univariate feature selection approach, the features with
the highest importance for the target variable were the presence of a
broken truck, lack of electricity, point of flooding, defect in the
network of trolleybuses and semaphore off, as can be seen in
Fig. [4](#fig:trafffeat){reference-type="ref"
reference="fig:trafffeat"}, that depicts the scores according to its
importance to the target variable.

![Feature selection of the urban traffic in São Paulo -- Brazil -- data
set.](img/trafffeat.eps){#fig:trafffeat width="\\linewidth"}

### Levenberg--Marquardt Backpropagation

As already mentioned, the LMA algorithm was tested using a different
number of hidden neurons and, for each number of hidden units, ten tests
were executed.
Table [\[tab:lmatraff\]](#tab:lmatraff){reference-type="ref"
reference="tab:lmatraff"} summarises the results obtained with the LMA
algorithm, presenting the number of hidden neurons, the best and the
worst MSE achieved, and the respective R values, the average MSE and its
standard deviation (STD) only for the test portion of the data set.

It is important to note that slowness in traffic of the previous two
days was used to compute the prediction of the current day. Thus, the
predicted time-series has two missing points in its beginning.

As can be analysed from
Table [\[tab:lmatraff\]](#tab:lmatraff){reference-type="ref"
reference="tab:lmatraff"}, the lowest MSE value was obtained using an
ANN with four hidden units. However, a contrast was found, since one of
the worst MSE values was also obtained with ANN with four hidden units,
thus justifying its high STD.

When analysing the correlation coefficients, it is possible to verify
that, regardless of the number of hidden units, a strong positive
relationship has always found. Nevertheless, as the number of hidden
units increases, the average MSE also increases.

Two types of predictions were used in order to assess the fitness of the
model with the best ANN found (four hidden units): open-loop and
closed-loop. It is noteworthy that the ANNs, whose results were
presented in
Table [\[tab:lmatraff\]](#tab:lmatraff){reference-type="ref"
reference="tab:lmatraff"}, were trained using an open-loop architecture.
Thus, the results of the open-loop prediction are better than the
open-loop, as can be seen in
Fig. [\[fig:traffic\]](#fig:traffic){reference-type="ref"
reference="fig:traffic"}.

![image](img/traffic.eps){width="\\textwidth"}

### Particle Swarm Optimisation

Using the same seasonally adjusted time-series and the same ANN
architectures, the authors tested the use of the PSO algorithm, as an
alternative to using the LMA to find the optimal ANN weights that
minimise the MSE.

The results of the tests performed with the PSO are presented in
Table [\[tab:psotraff\]](#tab:psotraff){reference-type="ref"
reference="tab:psotraff"}, in which it is possible to observe that the
PSO is not at all a viable alternative for finding the optimal weights
for this time-series, since in all cases the algorithm did not converge,
leading to a high MSE value and a low correlation coefficient.

On possible justification for this problem may be related with the
choice of parameters used for the PSO, e.g., the number of particles,
swarm architecture, and the number of iterations, since PSO may require
more iterations in order to converge when compared to the LMA.

Not disregarding this, once again the best MSE value found belongs to an
ANN with four hidden units in the hidden layer and, on average, as the
number of hidden units increases, the worse the MSE gets. The values of
the STD, in turn, suggest that the use of the PSO algorithm for this
data set is not stable.

Monthly Milk Production
-----------------------

The data set includes the monthly production of milk per cow from
January 1962 to December 1975. It contains 168 samples of milk
production with three attributes: year, month and the milk production in
pounds per cow of that specific month. This study aimed at analysing the
data through time-series analysis.

In this case, feature selection is not required, since the seasonal
adjustment will remove the monthly cycle, and with this the month
feature. Thus, only the year remains as input variable.

### Seasonal Adjustment

Contrarily to the traffic data set, this time-series follows a
multiplicative model, since the amplitude increases with the level.
Thus, the seasonal adjustment was done taking into consideration the
Equation [\[eq:multi\]](#eq:multi){reference-type="eqref"
reference="eq:multi"}.

As already mentioned, the repeated patters can happen monthly. The
original and the final seasonally adjusted series can be found on
Fig. [5](#fig:milkori){reference-type="ref" reference="fig:milkori"},
where it is possible to analyse that the time-series has a approximately
linear growing trend.

![The original and the easonally adjusted time-series of milk
production.](img/milkori.eps){#fig:milkori width="\\linewidth"}

### Levenberg--Marquardt Backpropagation

Following the same structure of tests used in the traffic data set, each
ANN architecture was tested ten times with different number of hidden
units in the single hidden layer. The results of these tests are
presented in Table [\[tab:lmamilk\]](#tab:lmamilk){reference-type="ref"
reference="tab:lmamilk"}.

According to Table [\[tab:lmamilk\]](#tab:lmamilk){reference-type="ref"
reference="tab:lmamilk"}, the lowest MSE value was found, like the
traffic data set, by an ANN with four hidden units. However, when we
consider the average MSE, ANNs with fifteen hidden units found in most
of the tests the best architecture.

Besides that, the STD is high in the six number of hidden neurons
considered, meaning that one can obtain good results in some tests, but
other tests may also perform poorly, especially for the case of four and
twenty hidden units, that also showed the highest average MSE value.

In either case, the correlation coefficient performed well, having
values higher than 0.990 for the best ANN of each number of hidden
units.

Using the best ANN with four hidden units, the authors computed the
prediction using the open and closed-loop. The visual result is
presented in Fig. [\[fig:milk\]](#fig:milk){reference-type="ref"
reference="fig:milk"}, where is possible to very that the ANN in
open-loop architecture can predict with high accuracy the values of the
time-series. As expected, the closed-loop does not perform as good as
the open-loop.

Like the traffic data set, since the data was divided into sequential
blocks, the first 70% of time-series was used to train the network, the
next 15% to validation, and the last 15% can be seen as a test to the
ANN's predictive capacity.

![image](img/milk.eps){width="\\textwidth"}

### Particle Swarm Optimisation

Once again, the PSO algorithm did not perform as well as the LMA, as can
be seen by the best and the worst MSE values presented in
Table [\[tab:psomilk\]](#tab:psomilk){reference-type="ref"
reference="tab:psomilk"}.

Interestingly, the ANN with the lowest MSE is one with twenty hidden
units, i.e., the highest number of neuronal units considered. In terms
of average MSE value, ANNs with ten or fifteen hidden units performed
similarly, but overall results indicate that accuracy of the ANN for
each number of hidden units is not stable between tests.

As a result, the PSO algorithm is not, by any means, a good alternative
for time-series fitting. In the following tests, a comparison between
the LMA and PSO will be presented, taking into consideration regression
tasks.

QSAR fish toxicity
------------------

QSAR fish toxicity data set includes 908 samples with five features and
acute aquatic toxicity for fish as a target attribute. This data set is
used to fit the data using two-layered feed-forward neural network.

### Feature Selection

Table [2](#tab:fishvar){reference-type="ref" reference="tab:fishvar"}
shows the variance of features for predicting the acute aquatic toxicity
towards the fish. Variance also gives an insight into the outliers
present in the data. It is clear from the variance values that the data
is well scaled, except the MLOGP feature, that has the highest variance,
suggesting its use on the feature set.

The univariate feature selection performs F-tests individually for each
feature with the predictor variable followed by the ranking of features
using the p-value of F-test statistics.
Fig. [6](#fig:fishfeat){reference-type="ref" reference="fig:fishfeat"}
presents the score of each feature, showing that NdsCH and NdssC have
relatively very less score and hence can be excluded from the feature
set.

::: {#tab:fishvar}
  **Feature**   **Variance**
------------- --------------
  MLOGP         2.054
  NdssC         0.741
  CIC0          0.571
  NdsCH         0.366
  SM1~Dz~       0.183
  GATS1i        0.155

  : Variance of features of the fish data set.
:::

![Feature selection of the QSAR fish toxicity data
set.](img/fishfeat.eps){#fig:fishfeat width="\\linewidth"}

### Levenberg--Marquardt Backpropagation

Data fitting requires fitting of parameters at every iteration. This
fitting is done using an optimisation algorithm which guides the process
of updating the learnable parameters, i.e., the weights of the ANN.

Table [\[tab:lmafish\]](#tab:lmafish){reference-type="ref"
reference="tab:lmafish"} shows the MSE and R values for the different
number of neuron units in the hidden layer. The best performance was
achieved at using the ANN with twelve hidden units, achieving the
minimum MSE and maximum R value, whereas ANN with fifteen neuron units
in the hidden layer performs worst achieving the highest MSE and one of
the lowest R values.

Nevertheless, ANNs with seven units perform, on average and in terms of
MSE value, better than other types of ANN architectures.

### Particle Swarm Optimisation

The PSO algorithm was also used as an optimisation algorithm for data
fitting of the fish data set.

The MSE and R results for various hidden neuron units are presented in
Table [\[tab:psofish\]](#tab:psofish){reference-type="ref"
reference="tab:psofish"}.

ANN with seven hidden units achieved the lowest MSE, and highest MSE was
achieved by twenty hidden units containing ANN, depicting the worst
performance. Thus, the highest R value was also achieved by ANN with
seven hidden units, whereas the twenty hidden units performed worst,
achieving the lowest R value.

It is important to note that both LMA and PSO achieved very similar best
MSE values (0.777 and 0.735, respectively); however, the PSO algorithm
just needed seven hidden units, while the LMA required twelve. It is
also noteworthy that the STD increases with the increase in the number
of neurons in the hidden layer. This leads to the conclusion that a
smaller number of neurons in the hidden layer is more beneficial for
PSO.

Wine Quality
------------

The data set was prepared for red and white wine, with the same number
of attributes. It consists of total 4898 (1600 for red and 3298 for
white wine) samples and twelve features, out of which the quality is
used as a response variable based on other attributes in the data set.

### Feature Selection

The wine data set consist of data related to 2 types of wine: red and
white with the same number of features.

The variance of both data sets is shown in
Table [3](#tab:redwinevar){reference-type="ref"
reference="tab:redwinevar"}
and [4](#tab:whitewinevar){reference-type="ref"
reference="tab:whitewinevar"}, respectively, where it is possible to
verify that the total and free sulfur dioxide for both the data sets
have a substantial variance.

The Fig. [7](#fig:redfeat){reference-type="ref" reference="fig:redfeat"}
and [8](#fig:whitefeat){reference-type="ref" reference="fig:whitefeat"}
shows the selection of useful features for data fitting tasks. Thus, for
the red wine data set, the chosen features are: fixed acidity, volatile
acidity, citric acid, chlorides, total sulfur dioxide, density,
sulphates and alcohol. For the white wine, a smaller set of features was
used: citric acid, Chlorides, density and alcohol.

::: {#tab:redwinevar}
  **Feature**            **Variance**
---------------------- --------------
  Total sulfur dioxide   1806.085
  Free sulfur dioxide    289.242
  Residual sugar         25.725
  Density                8.945
  Slcohol                1.514
  Fixed acidity          0.712
  pH                     0.022
  Citric acid            0.014
  Sulphates              0.013
  Volatile acidity       0.01
  Chlorides              0

  : Variance of features for the red wine data set.
:::

::: {#tab:whitewinevar}
  **Feature**            **Variance**
---------------------- --------------
  Total sulfur dioxide   1082.102
  Free sulfur dioxide    109.414
  Density                3.562
  Fixed acidity          3.031
  Residual sugar         1.987
  Alcohol                1.135
  Citric acid            0.037
  Volatile acidity       0.032
  Sulphates              0.028
  pH                     0.023
  Chlorides              0.002

  : Variance of features for the white wine data set.
:::

![Feature selection of the red wine data
set.](img/redfeat.eps){#fig:redfeat width="\\linewidth"}

![Feature selection of the white wine data
set.](img/whitefeat.eps){#fig:whitefeat width="\\linewidth"}

### Levenberg--Marquardt Backpropagation

Like the fish data set, the LMA was used as an optimisation algorithm
for parameter optimisation.
Table [\[tab:LMAredwine\]](#tab:LMAredwine){reference-type="ref"
reference="tab:LMAredwine"} and
Table [\[tab:lmawhitewine\]](#tab:lmawhitewine){reference-type="ref"
reference="tab:lmawhitewine"} show the MSE and R values for the
different values of hidden units in the ANNs.

**Red Wine Analysis:**

The least MSE is achieved by fifteen hidden units containing ANN,
whereas the worst performance was achieved by ANN with four hidden
units. Thus, the best performance was achieved by ANN with fifteen
hidden units and worst-performing ANN was 4 hidden units containing ANN,
in terms of R value.

It is important to note that in the case where MSE and R is not able to
suggest a single architecture, the means MSE can also be used as a part
of the analysis. From the table it is clear that least average MSE is
for fifteen hidden units in the hidden layer network, so for red wine
data set fifteen hidden units in the hidden layer of the ANN model can
be used for further analysis. Nevertheless, regardless of the number of
neurons in the hidden layer, the average was found to be similar.

**White Wine Analysis:**

The least MSE was achieved by twenty hidden units containing ANN,
whereas the worst performance was achieved by ANN with 4 hidden units.
The best performance was also achieved by ANN with twenty hidden units
and worst-performing ANN was 4 hidden units containing ANN, in terms of
R value. Thus, twenty hidden units containing architecture can be used
for further analysis since it has the highest R value and least average
MSE value.

In this case, it is possible to identify a trend in the data, since has
the number of hidden units increase, the MSE value decreases, indicating
that the use of a higher number of hidden units may be more beneficial
for the LMA algorithm.

From the three data sets above, is clear that, giving the low STD
values, the LMA is a more stable training algorithm when it comes to
fitting applications than for time-series analysis.

### Particle Swarm Optimisation

The MSE and R value for different ANN architectures using PSO as an
optimisation algorithm is shown in
Table [\[tab:psoredwine\]](#tab:psoredwine){reference-type="ref"
reference="tab:psoredwine"}
and [\[tab:psowhitewine\]](#tab:psowhitewine){reference-type="ref"
reference="tab:psowhitewine"}.

**Red Wine analysis:**

Table [\[tab:psoredwine\]](#tab:psoredwine){reference-type="ref"
reference="tab:psoredwine"} shows the MSE and R values for different
neural units for the red wine data set. The least MSE and highest R
value was achieved by ANN with seven hidden units, whereas ANN with
twenty hidden units showed the highest MSE and lowest R value and
thereby the worst performance. Choosing the ANN architecture is
straightforward in this case since MSE, and R value analysis are
pointing to the same network architecture.

When compared with the PSO algorithm, for similar MSE values, the PSO
required a lower number of hidden units, i.e., the PSO required seven
hidden units and obtained the best value of MSE of 0.477, whereas LMA
required fifteen hidden units to get the best MSE of 0.411.

### White wine analysis

Table [\[tab:psowhitewine\]](#tab:psowhitewine){reference-type="ref"
reference="tab:psowhitewine"} shows the MSE and R values for different
neural units for the red wine data set. The least MSE value was achieved
by ANN with four hidden units, whereas ANN with twenty hidden units
showed the highest MSE. The best performing model in terms of R value is
the ANN architecture with seven hidden units and worst with fifteen
hidden units. In this scenario, the best network is a network with seven
hidden units.

In all tests, the PSO performed better, in terms of best MSE, than the
LMA, and required a lower number of hidden units to achive similiar
accuracy in terms of best MSE values.

Conclusion
==========

This study highlights two important concepts: time-series analysis and
data fitting. It includes using two data sets: milk production and urban
traffic behaviours in the São Paulo data set for time-series analysis
and QSAR fish toxicity and wine data set for data fitting.

The experiments were conducted altering the number of neurons in the
hidden layer. Two optimisation algorithms (Levenberg-Maquardt algorithm
and Particle Swarm Optimisation) were used for both tasks. LMA worked
better for time-series analysis and PSO for data fitting tasks. This
could be due to the ability of PSO to handle high dimensionality of data
than LMA.

On the one hand, the LMA algorithm was more stable than the PSO
algorithm, especially in regression tasks; however, for the same
accuracy, the PSO algorithm required a lower number of hidden units, as
can be seen in Table [\[tab:final\]](#tab:final){reference-type="ref"
reference="tab:final"}.

As future work, we are going to test the PSO algorithm with different
parameters, different velocity update equations and different topologies
of swarms.

Before using the algorithms to find the optimal ANN's weights, feature
selection methods were used for this study and were based on the
variance of each feature and on its rank based on its p-values of F-test
statistics.

Although for other data sets, combination of the average MSE and R value
have suggested neural networks in the way that both were pointing to the
same network architecture, this may not always be the case. Finally, it
can be concluded that selection of algorithm is dependent on the type of
task, as seen in the study.
© 2020 GitHub, Inc.
Terms
Privacy
Security
Status
Help
Contact GitHub
Pricing
API
Training
Blog
About
