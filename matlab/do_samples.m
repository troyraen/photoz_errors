function [errs] = do_samples(Nsampszs, max_sampsz, Nruns, algor, fout_tag, aparams, machine)
% Nsampszs = number of training sample sizes to test,
%               log spaced in [1000, length(specz)].
% max_sampsz = max number for sample size
% Nruns = number of trainings per sample size, results are pooled.
% algor =   'NN' does neural nets using do_fitnet
%           'RF' does random forest using do_fitrensemble
%           'GPz'
% aparams = {parameters for algor}. see details below
% loads data from file, see base_path and fdat below
% machine = 'Roy' or 'Kor'. Determines which data files are used


%-------------------------------------------------------------
%% Load data:
% ccols = {'id','redshift','u10','u10_m_g10','g10_m_r10','r10_m_i10','i10_m_z10','z10_m_y10'};
%           !!! These must be the same as in data_proc.py !!!!
fprintf('\nSetting up for algorithm %2s\n', algor)
if machine == 'Kor'
    base_path = '/home/tjr63/Documents/photoz_errors/';
    fdat = 'CGcolors'; % data file prefix. overridden below for GPz.
    test_N = 100000; % test sample size
elseif machine == 'Roy'
    base_path = '/Users/troyraen/Korriban/Documents/photoz_errors/';
    fdat = 'CGsample'; % data file prefix. overridden below for GPz.
    test_N = 10000; % test sample size
else
    'MUST PASS machine TO do_samples'
    return
end


ferrs = strcat(base_path,'data/errors',algor,fout_tag,'.mtxt'); % file name to save errors
fplt = strcat(base_path,'matlab/plots/errors',algor,fout_tag,'.png'); % file name to save errors plot


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
    % fplt = aparams{3};
    GPz_params = aparams{3}; % = {heteroscedastic, csl_method, maxAttempts}

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

         % Get data subsample (unless doing GPz)
        if ~strcmp(algor,'GPz')
            strt = mod(1+(nr-1)*n,N);
            stp = mod(nr*n,N);
            if stp<strt % wrap to beginning of array
                d1 = dat(strt:end,:);
                d2 = dat(1:stp,:);
                datn = cat(1,d1,d2);
                z1 = specz(strt:end);
                z2 = specz(1:stp);
                zn = cat(1,z1,z2);
            else % just get the slices
                datn = dat(strt:stp,:);
                zn = specz(strt:stp);
            end
            len_zn = length(zn);
        end

        % Do algor fit
        if strcmp(algor,'NN')
            [net, photz, mse, test_photz] = do_fitnet(datn, zn, test_dat, aparams);

        elseif strcmp(algor,'RF')
            [mdl, photz, mse, test_photz] = do_fitrensemble(datn, zn, test_dat, aparams);

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

    % Calc and store errors
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
save(ferrs, 'errs', '-ascii');%, '-append');
plot_errors(errs, algor, Nruns, fplt);
%%
