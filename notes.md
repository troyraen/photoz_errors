# Questions
---
- [ ] initialize GPz with constant random seed?



# To Do:

	- [ ] ANNz2
		- [ ] install Root
	- [ ] NN: understand/optimize
	- [ ] RF: try oobPredict, oobLoss, oobPermutedPredictorImportance
	- [?] KNN: knnsearch(X,Y)
	- [ ] If can't get ANNz2 working, do better job bagging "Average of misclassification errors on different data splits gives a better estimate of the predictive ability of a learning method" MHlec23. Also try boosting, possibly stacking.

algorithms:
	* neural net
	* random forest
	* k nearest neighbor
	* XG boost (variant of decision trees) python implementation (possibly use 'AdaBoostM1' in matlab: https://www.mathworks.com/matlabcentral/answers/423851-is-there-any-implementation-of-xgboost-algorithm-for-decision-trees-in-matlab)
	* ANNz2
	relevance vector machine


# Algorithms
---
<!-- fs -->

## ANNz2
<!-- fs -->
[git](https://github.com/troyraen/ANNZ)
[downloading Root](https://root.cern.ch/downloading-root)
[Root on Anaconda](https://anaconda.org/conda-forge/root)
Can do single model regression (classification), or stack models using "randomized regression".
> Randomized regression. An ensemble of regression methods is automatically generated. The randomized MLMs differ from each other in several ways. This includes setting unique random seed initializations, as well as changing the configuration parameters of a given algorithm (e.g., number of hidden layers in an ANN), or the set of input parameters used for the training.
Once training is complete, optimization takes place. In this stage, a distribution of photo-z solutions for each galaxy is derived. A selection procedure is then applied to the ensemble of answers, choosing the subset of methods which achieve optimal performance. The selected MLMs are then folded with their respective uncertainty estimates, which are derived using a KNN-uncertainty estimator (see Oyaizu et al, 2007). A set of PDF candidates is generated, where each candidate is constructed by a different set of relative weights associated with the various MLM components.
The final products are the best solution out of all the randomized MLMs, the full binned PDF(s) and the weighted and un-weighted average of the PDF(s), each also having a corresponding uncertainty estimator.

- ANN: artificial neural network.
- BDT: boosted decision tree(s).
- KNN: k-nearest neighbors.
ANN and BDT have best performance.


### annz2_env (conda env) install (Korriban):
azenv (activate alias)
```bash
conda create -n annz2_env python=3.7
source activate annz2_env
conda install -c anaconda libopenblas
conda install -c anaconda libgfortran
# conda install -c anaconda gfortran_osx-64 #failed
conda install -c anaconda gcc
# conda install -c anaconda gcc
conda install -c conda-forge root
# conda install -c conda-forge/label/gcc7 root
# cd /home/tjr63/Documents/
# git clone git@github.com:troyraen/ANNZ
# environment path: /home/tjr63/miniconda3/envs/annz2_env
# to remove: conda remove -n annz2_env --all
# path for env variables: /home/tjr63/miniconda3/envs/annz2_env/etc/conda/activate.d/env_vars.sh
python scripts/annz_singleReg_quick.py --make
```
[helpful link for setting environment-specific variables](https://stackoverflow.com/questions/46826497/conda-set-ld-library-path-for-env-only)


<!-- fe ANNz2-->


## random forest
<!-- fs -->
fitrensemble optimization results:
Method Bag
NumLearningCycles 495
LearnRate NaN
MinLeafSize 1


#### Matlab
fitrensemble creates [RegressionBaggedEnsemble](https://www.mathworks.com/help/stats/classreg.learning.regr.regressionbaggedensemble-class.html)
> Regression ensemble grown by resampling. RegressionBaggedEnsemble combines a set of trained weak learner models and data on which these learners were trained. It can predict ensemble response for new data by aggregating predictions from its weak learners.


See also:
[Bootstrap Aggregation (Bagging) and Random Forest](https://www.mathworks.com/help/stats/ensemble-algorithms.html#bsw8at7)
Estimate predictive power and errors:
> Use the oobPredict function to estimate predictive power and feature importance. For each observation, oobPredict estimates the out-of-bag prediction by averaging predictions from all trees in the ensemble for which the observation is out of bag.

> Estimate the average out-of-bag error by using oobError (for TreeBagger) or oobLoss (for bagged ensembles). These functions compare the out-of-bag predicted responses against the observed responses for all observations used for training. The out-of-bag average is an unbiased estimator of the true ensemble error.

> Obtain out-of-bag estimates of feature importance by using the OOBPermutedPredictorDeltaError property (for TreeBagger) or oobPermutedPredictorImportance property (for bagged ensembles). The software randomly permutes out-of-bag data across one variable or column at a time and estimates the increase in the out-of-bag error due to this permutation. The larger the increase, the more important the feature. Therefore, you do not need to supply test data for bagged ensembles because you can obtain reliable estimates of predictive power and feature importance in the process of training.


#### My model
mdl =
  classreg.learning.regr.RegressionBaggedEnsemble
             ResponseName: 'Y'
    CategoricalPredictors: []
        ResponseTransform: 'none'
          NumObservations: 1000
               NumTrained: 100
                   Method: 'Bag'
             LearnerNames: {'Tree'}
     ReasonForTermination: 'Terminated normally after completing the requested number of training cycles.'
                  FitInfo: []
       FitInfoDescription: 'None'
           Regularization: []
                FResample: 1
                  Replace: 1
         UseObsForLearner: [1000x100 logical]


#### Rongpu
from notebook random_forest_photo-z_simple.ipynb:
regrf = RandomForestRegressor(n_estimators=100, max_depth=50, random_state=1456, n_jobs=2)
regrf.fit(data_train, cat_train['redshift'])
RandomForestRegressor(bootstrap=True, criterion='mse', max_depth=50,
           max_features='auto', max_leaf_nodes=None,
           min_impurity_decrease=0.0, min_impurity_split=None,
           min_samples_leaf=1, min_samples_split=2,
           min_weight_fraction_leaf=0.0, n_estimators=100, n_jobs=2,
           oob_score=False, random_state=1456, verbose=0, warm_start=False)


<!-- fe -->


## k-Nearest Neighbors
<!-- fs -->
#### Matlab
[knnsearch(X,Y)](https://www.mathworks.com/help/stats/knnsearch.html)

See also: [createns](https://www.mathworks.com/help/stats/createns.html)

#### Wikipedia
(https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm#k-NN_regression)
> In k-NN regression, the k-NN algorithm is used for estimating continuous variables. One such algorithm uses a weighted average of the k nearest neighbors, weighted by the inverse of their distance. This algorithm works as follows:

1. Compute the Euclidean or Mahalanobis distance from the query example to the labeled examples.
2. Order the labeled examples by increasing distance.
3. Find a heuristically optimal number k of nearest neighbors, based on [RMSE](https://en.wikipedia.org/wiki/RMSE). This is done using cross validation.
4. Calculate an inverse distance weighted average with the k-nearest multivariate neighbors.

<!-- fe -->


<!-- fe algorithms -->


# Archive
<!-- fs -->
## To Do:

	- [x] create data files with colors
	- [x] run RF and NN for several sample sizes and plot
	- [-] find AdaBoostM1 (this is classification?)


<!-- fe Archive -->


# git
Beetled59Expounded84crucially18dilemma's55protesting
