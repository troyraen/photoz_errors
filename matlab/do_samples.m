function [errs] = do_samples(Nsampszs, max_sampsz, Nruns, algor, aparams)
% Nsampszs = number of training sample sizes to test,
%               log spaced in [1000, length(specz)].
% max_sampsz = max number for sample size
% Nruns = number of trainings per sample size, results are pooled.
% algor =   'NN' does neural nets using do_fitnet
%           'RF' does random forest using do_fitrensemble
%           'GPz'
% aparams = {parameters for algor}. see details below
% loads data from file, see base_path and fdat below


%-------------------------------------------------------------
%% Load data:
% ccols = {'id','redshift','u10','u10_m_g10','g10_m_r10','r10_m_i10','i10_m_z10','z10_m_y10'};
%           !!! These must be the same as in data_proc.py !!!!
fprintf('\nSetting up for algorithm %2s\n', algor)
test_N = 100000; % test sample size
fdat = 'CGcolors'; % data file prefix
base_path = '/home/tjr63/Documents/photoz_errors/';
ferrs = strcat(base_path,'data/errors',algor,'.mtxt'); % file name to save errors
fplt = strcat(base_path,'matlab/plots/errors',algor,'.png'); % file name to save errors plot


if ~strcmp(algor,'GPz')
    tmp = load(strcat(base_path,'data/',fdat,'0.mtxt')); % training data
    dat = tmp(:,3:end);
    specz = tmp(:,2);
    N = length(specz); % number of training examples

    tmp = load(strcat(base_path,'data/',fdat,'1.mtxt')); % test data
    test_dat = tmp(1:test_N,3:end);
    test_specz = tmp(1:test_N,2);

    clear tmp

else % GPz
    % aparams = [fdat, maxIter, fplt, GPz_params]
    fdat = aparams{1};
    maxIter = aparams{2};
    fplt = aparams{3};
    GPz_params = aparams{4}; % = {heteroscedastic, csl_method, maxAttempts}

end
%%

%-------------------------------------------------------------
%% Setup:
nsamps = uint32(logspace(log10(1000),log10(max_sampsz),Nsampszs));
% nsamp=[1000, 2500, 5000, 10000, 15000, 20000];
errs = zeros(Nsampszs,4); % column 1:sample size, 2:NMAD, 3:out10, 4:mse
errs(:,1) = nsamps';
%%


%-------------------------------------------------------------
%% iterate over sample sizes
for i=1:Nsampszs
    n = nsamps(i); % sample size
    fprintf('Doing sample size %6f\n', n)

    %% do Nruns for this sample size
    zdev = []; % pool results of calc_zdev() for Nruns
    for nr=1:Nruns
        fprintf('Doing run %2f\n', nr)
        if ~strcmp(algor,'GPz')
            datn = dat(1+(nr-1)*n:nr*n,:);
            zn = specz(1+(nr-1)*n:nr*n);
            len_zn = length(zn);
        end

        if strcmp(algor,'NN')
            ulayers = [15,15,15]; % train with len(ulayers) hidden layers, # hidden units each
            [net, photz, mse, test_photz] = do_fitnet(ulayers, datn, zn, test_dat);

        elseif strcmp(algor,'RF')
            [mdl, photz, mse, test_photz] = do_fitrensemble(datn, zn, test_dat);

        elseif strcmp(algor,'GPz')
            Nexamples = [n, n, test_N]; % [training,validation,testing]
            [other, test_specz, mse, test_photz] = do_fitGPz(fdat, maxIter, Nexamples, GPz_params);
            other % check this

        end

        zd = calc_zdev(test_specz, test_photz);
        % size_ad = size(ad) % check this
        zdev = cat(1,zdev, zd); % pool this for all runs for this n
        % size_zdev = size(zdev) % check this
    end
    %%

    [NMAD, out10] = calc_zerrors(zdev);
    errs(i,2) = NMAD;
    errs(i,3) = out10;
    errs(i,4) = mse;
end
%%

%-------------------------------------------------------------
%% Save errors and plots
command = strcat("python -c $'import helper_fncs as hf; hf.file_ow(\'",ferrs,"\')'");
status = system(command);
save(ferrs, 'errs', '-ascii');
plot_errors(errs, algor, Nruns, fplt);
%%
