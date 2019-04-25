# Questions
---

- [ ] Results
- [ ] GPz settings
- [ ] future work

NN 'poslin' is RELU function. try changing this.
try traingdx (or traingdm) for trainFnc option. seems most like what's used in modern literature

trainNetwork is more modern than fitnet. it's in the deep learning toolbox. has 'adam' optimizer which is more modern

- [ ] initialize GPz with constant random seed?

RF:
4:41 run 17 starts. 4:43 run 20 finishes. next sample size is 1.9e4
5:02 doing run 2 of 31623x500
8:26 doing run 12 of 138950x500
9:57 doing run 5 of 227585x500
11:27 doing run 14 of 227585x500
7:16 doing run 4 of 610540x500
8:56 doing run 8 of 610540x500
10:40 doing run 11 of 610540x500
12:33 doing run 13 of 610540x500
2:44 doing run 17 of 610540x500
4:42 doing run 20 of 610540x500
predict 24 hours for last sample size!?
5:58 doing run 1 of sample size 1000000
10:45 doing run 5 of 1000000x500
7:38 doing run 13 of 1000000x500
9:31 doing run 15 of 1000000x500
11:49 doing run 17 of 1000000x500
12:31 doing run 18 of 1000000x500
3:45 done.

NN:
9:10 started predict_photoz_testNN
9:48 doing run 2 , N=10000
10:40 doing run 2, N=31623
12:33 doing run 1, N=100000
2:44 doing run 3, N=100000
4:40 doing run 5, N=100000
predict 12 hours for last sample size
5:57 doing run 1, N=316228
10:45 doing run 2, N=316228
7:37 doing run 4, N=316228
9:31 doing run 5, N=316228
11:50 doing run 5, N=316228
2:00 done.


GPz
started 9:50, mIt250_cslBalanced
done 10:37
10:39 start mIt250_methodVC
crashed
5:58 start
6:05, done prepping data, on iter 38 of sample size 70000
6:58 doing run 2, sample size 70000
7:45 failed on sample size 200000, dataset too small
7:52 start sample size 70000



# See also

http://lsst-desc.org/WorkingGroups/PZ

http://lsst-desc.org/node/28


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


# Matlab crash report 4/24/19
<!-- fs -->
running mlterm from bash gave:
```
MATLAB is selecting SOFTWARE OPENGL rendering.

--------------------------------------------------------------------------------
      Floating point exception detected at Wed Apr 24 17:27:17 2019 -0400
--------------------------------------------------------------------------------

Configuration:
  Crash Decoding           : Disabled - No sandbox or build area path
  Crash Mode               : continue (default)
  Default Encoding         : UTF-8
  GNU C Library            : 2.17 stable
  MATLAB Architecture      : glnxa64
  MATLAB Root              : /usr/local/MATLAB/R2018b
  MATLAB Version           : 9.5.0.944444 (R2018b)
  Operating System         : "Scientific Linux release 7.6 (Nitrogen)"
  Process ID               : 37884
  Processor ID             : x86 Family 6 Model 63 Stepping 2, GenuineIntel
  Session Key              : b32f3aa6-828b-42be-8ff9-91789a46e6e7
  Static TLS mitigation    : Disabled: Unnecessary 1

Fault Count: 3


Abnormal termination

Register State (from fault):
  RAX = 000017577acb733c  RBX = 0000000000000400
  RCX = 00007fa0431e3cd8  RDX = 0000000000000000
  RSP = 00007fa020ef2b08  RBP = 0000000000000001
  RSI = 00007fa0431dbc10  RDI = 00007fa0431de210

   R8 = 00007fa0431dbb94   R9 = 0000000000000001
  R10 = 0000000000000002  R11 = 0000000000000246
  R12 = 0000000000000000  R13 = 00007fa0431dba54
  R14 = 00007fa042ee7c40  R15 = 00007fa0431dba40

  RIP = 00007fa042f20e76  EFL = 0000000000010246

   CS = 0033   FS = 0000   GS = 0000

Stack Trace (from fault):
[  0] 0x00007fa042f20e76 /usr/local/MATLAB/R2018b/bin/glnxa64/../../sys/os/glnxa64/libiomp5.so+00740982
[  1] 0x00007fa042ecfee6 /usr/local/MATLAB/R2018b/bin/glnxa64/../../sys/os/glnxa64/libiomp5.so+00409318 __kmp_wait_yield_4+00000166
[  2] 0x00007fa042ee6920 /usr/local/MATLAB/R2018b/bin/glnxa64/../../sys/os/glnxa64/libiomp5.so+00502048 __kmp_acquire_ticket_lock+00000064
[  3] 0x00007fa042eec4e5 /usr/local/MATLAB/R2018b/bin/glnxa64/../../sys/os/glnxa64/libiomp5.so+00525541
[  4] 0x00007fa042ec902a /usr/local/MATLAB/R2018b/bin/glnxa64/../../sys/os/glnxa64/libiomp5.so+00380970 ompc_set_num_threads+00000010
[  5] 0x00007fa062f1593e   /usr/local/MATLAB/R2018b/bin/glnxa64/libtbb.so.2+00178494
[  6] 0x00007fa062f140b4   /usr/local/MATLAB/R2018b/bin/glnxa64/libtbb.so.2+00172212
[  7] 0x00007fa062f0d039   /usr/local/MATLAB/R2018b/bin/glnxa64/libtbb.so.2+00143417
[  8] 0x00007fa062f0af8f   /usr/local/MATLAB/R2018b/bin/glnxa64/libtbb.so.2+00135055
[  9] 0x00007fa062f06616   /usr/local/MATLAB/R2018b/bin/glnxa64/libtbb.so.2+00116246
[ 10] 0x00007fa062f065a6   /usr/local/MATLAB/R2018b/bin/glnxa64/libtbb.so.2+00116134
[ 11] 0x00007fa066a52dd5                             /lib64/libpthread.so.0+00032213
[ 12] 0x00007fa06830dead                                   /lib64/libc.so.6+01040045 clone+00000109
[ 13] 0x0000000000000000                                   <unknown-module>+00000000

** This crash report has been saved to disk as /home/tjr63/matlab_crash_dump.37884-1 **



MATLAB is exiting because of fatal error
Killed

```
<!-- fe # Matlab crash report 4/24/19 -->
