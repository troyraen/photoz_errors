function [mdl, res, mse, test_res] = do_fitrensemble(data, target, test_data, params)
% Builds a random forest.
% data should be matrix (rows=examples, columns=attributes)
% target should be 1 x Nexamples with correct answer
% test_data is matrix of test data
% params is parameters for fitrensemble, = {NumLearningCycles}

% mdl = fitrensemble(data,target, 'OptimizeHyperparameters','auto');
mdl = fitrensemble(data,target, 'Method','Bag', 'NumLearningCycles',params{1})

res = predict(mdl, data); % takes an average over trees fit in previous step
% https://www.mathworks.com/help/stats/ensemble-algorithms.html#bsw8at7

test_res = predict(mdl, test_data);

mse = resubLoss(mdl); % = mse
