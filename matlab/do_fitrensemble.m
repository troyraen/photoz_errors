function [mdl, res, mse, test_res] = do_fitrensemble(data, target, test_data)
% Builds a random forest.
% data should be matrix (rows=examples, columns=attributes)
% target should be 1 x Nexamples with correct answer
% test_data is matrix of test data

% mdl = fitrensemble(data,target, 'OptimizeHyperparameters','auto');
mdl = fitrensemble(data,target, 'Method','Bag', 'MinLeafSize',1);

res = predict(mdl, data);

test_res = predict(mdl, test_data);

mse = resubLoss(mdl); % = mse
