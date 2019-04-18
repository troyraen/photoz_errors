function [mdl, res, mse, test_res] = do_fitGPz(dataPath, maxIter, Nexamples)
% Computes photozs using the GPz algorithm available at
%   https://github.com/troyraen/GPz (forked from OxfordML/GPz).
%   Most of this function is taken from the file GPz/demo_photoz.m
%
% dataPath = string. path to csv data file.
%   Required format is specified below.
% maxIter = int. maximum number of iterations.
% Nexamples = vector of ints. # examples in datasets: [training,validation,testing].
%
% Example usage:
%   % from matlab dir
%   [mdl, res, mse, test_res] = do_fitGPz('../GPz/data/sdss_sample.csv')
%   %!! mdl and res are currently set to []
%


addpath('../GPz/GPz/')
% addpath(genpath('minFunc_2012/'))       % path to minfunc
addpath(genpath('../GPz/minFunc_2012/'))
rng(1); % fix random seed


%%%%%%%%%%%%%% Model options %%%%%%%%%%%%%%%%

m = 100;                                % number of basis functions to use [required]

method = 'VD';                          % select a method, options = GL, VL, GD, VD, GC and VC [required]


heteroscedastic = true;                 % learn a heteroscedastic noise process, set to false if only interested in point estimates [default=true]

normalize = true;                       % pre-process the input by subtracting the means and dividing by the standard deviations [default=true]

% maxIter = 500;                          % maximum number of iterations [default=200]
maxAttempts = 50;                       % maximum iterations to attempt if there is no progress on the validation set [default=infinity]


% trainSplit = 0.2;                       % percentage of data to use for training
% validSplit = 0.2;                       % percentage of data to use for validation
% testSplit  = 0.6;                       % percentage of data to use for testing

inputNoise = true;                      % false = use mag errors as additional inputs, true = use mag errors as additional input noise

csl_method = 'normal';                  % cost-sensitive learning option: [default='normal']
                                        %       'balanced':     to weigh
                                        %       rare samples more heavily during training
                                        %       'normalized':   assigns an error cost for each sample = 1/(z+1)
                                        %       'normal':       no weights assigned, all samples are equally important

binWidth = 0.1;                         % the width of the bin for 'balanced' cost-sensitive learning [default=range(output)/100]
%%%%%%%%%%%%%% Prepare data %%%%%%%%%%%%%%
'Preparing data ...'
% dataPath = 'data/sdss_sample.csv';   % path to the data set, has to be in the following format m_1,m_2,..,m_k,e_1,e_2,...,e_k,z_spec
                                        % where m_i is the i-th magnitude, e_i is its associated uncertainty and z_spec is the spectroscopic redshift
                                        % [required]
outPath = [];                           % if set to a path, the output will be saved to a csv file.

% read data from file
X = csvread(dataPath);
Y = X(:,end);
X(:,end) = [];

[n,d] = size(X);
filters = d/2;

% select training, validation and testing sets from the data
% [training,validation,testing] = sample(n,trainSplit,validSplit,testSplit);

% you can also select the size of each sample
[training,validation,testing] = sample(n,Nexamples(1),Nexamples(2),Nexamples(3));

% get the weights for cost-sensitive learning
omega = getOmega(Y,csl_method,binWidth);

if(inputNoise)
    % treat the mag-errors as input noise variance
    Psi = X(:,filters+1:end).^2;
    X(:,filters+1:end) = [];
else
    % treat the mag-errors as input additional inputs
    X(:,filters+1:end) = log(X(:,filters+1:end));
    Psi = [];
end

%%%%%%%%%%%%%% Fit the model %%%%%%%%%%%%%%
'Fitting the Model ...'
% initialize the model
model = init(X,Y,method,m,'omega',omega,'training',training,'heteroscedastic',heteroscedastic,'normalize',normalize,'Psi',Psi);
% train the model
model = train(model,X,Y,'omega',omega,'training',training,'validation',validation,'maxIter',maxIter,'maxAttempts',maxAttempts,'Psi',Psi);


%%%%%%%%%%%%%% Compute Metrics %%%%%%%%%%%%%%
'Computing Metrics ...'
% use the model to generate predictions for the test set
[mu,sigma,nu,beta_i,gamma] = predict(X,model,'Psi',Psi,'selection',testing);

% mu     = the best point estimate
% nu     = variance due to data density
% beta_i = variance due to output noise
% gamma  = variance due to input noise
% sigma  = nu+beta_i+gamma



%%%%%%%%%%%%%% Set Output %%%%%%%%%%%%%%

%root mean squared error, i.e. sqrt(mean(errors^2))
rmse = sqrt(metrics(Y(testing),mu,sigma,@(y,mu,sigma) (y-mu).^2));
% fraction of data where |z_spec-z_phot|/(1+z_spec)<0.10
fr10 = metrics(Y(testing),mu,sigma,@(y,mu,sigma) 100*(abs(y-mu)./(y+1)<0.10));

%-------------------------------------------------------------
% Above here is almost exclusively from GPz/demo_photoz.m.
% Below here is my calculations.
%-------------------------------------------------------------


mdl = [];
res = [];
mse = rmse.^2;
test_res = mu;


% Check whether my calculations give the same results as GPz
zdev = calc_zdev(Y(testing), test_res);
[NMAD, out10] = calc_zerrors(zdev);

out10_eql = fr10 == out10
