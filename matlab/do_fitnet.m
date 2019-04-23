function [net, res, mse, test_res] = do_fitnet(data, target, test_data, params)
% data should be matrix (rows=examples, columns=attributes)
% target should be 1 x Nexamples with correct answer
% test_data is matrix of test data
% params is cell array of parameters = {ulayers, epochs, max_fail, transferFcn}


ulayers = params{1};
%% builds a function fitting neural network
net=fitnet(ulayers);

%%% use conjugate gradient to train the model
net.trainFcn='trainlm'; % default
% net.trainFcn='trainscg';
net.trainParam.epochs = params{2}; % 200;
net.trainParam.show = 10;
net.trainParam.max_fail= params{3}; % 1500;
net.trainParam.min_grad=1e-10;

for i=1:length(ulayers)
    net.layers{i}.transferFcn = params{4}
end

% if length(target)> 99999 % these runs are taking too long
%     net.trainParam.epochs = 200;
%     net.trainParam.max_fail = 100;
% end

[net, tr] = train(net,data',target');
% view(net)


%% runs learned network on inputs in data
res=net(data');
%%% mean classification error on the training data
class_error_train=sum(abs(target-round(res)'))/size(res,2);
%%% 'Mean squared error (mse) on the training data'
mse = perform(net,target',res);

res = res'; % transpose to column vector

%% check test data
test_res = net(test_data');
test_res = test_res'; % transpose to column vector
