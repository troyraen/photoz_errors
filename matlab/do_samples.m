function [errs] = do_samples(Nsampszs, max_sampsz, Nruns, algor)
% Nsampszs = number of training sample sizes to test,
%               log spaced in [1000, length(specz)].
% max_sampsz = max number for sample size
% Nruns = number of trainings per sample size, results are pooled.
% algor =   'NN' does neural nets using do_fitnet
%           'RF' does random forest using do_fitrensemble
% loads data from file, see base_path and base_file below


%% Load data:
% ccols = {'id','redshift','u10','u10_m_g10','g10_m_r10','r10_m_i10','i10_m_z10','z10_m_y10'};
%           These must be the same as in data_proc.py!
test_N = 100000;
base_path = '/home/tjr63/Documents/photoz_errors/data/';
base_file = 'colors';

tmp = load(strcat(base_path,base_file,'0.mtxt')); % training data
dat = tmp(:,3:end);
specz = tmp(:,2);
N = length(specz); % number of training examples

tmp = load(strcat(base_path,base_file,'1.mtxt')); % test data
test_dat = tmp(1:test_N,3:end);
test_specz = tmp(1:test_N,2);

clear tmp
%%

%% Setup:
nsamps = uint32(logspace(log10(1000),log10(max_sampsz),Nsampszs));
% nsamp=[1000, 2500, 5000, 10000, 15000, 20000];
errs = zeros(Nsampszs,4); % column 1 = sample size, 2 = NMAD, 3 = out10, 4 = mse
errs(:,1) = nsamps';
%%


%% iterate over sample sizes
for i=1:Nsampszs
    n = nsamps(i); % sample size

    %% do Nruns for this sample size
    abs_dev = [];
    for nr=1:Nruns
        datn = dat(1+(nr-1)*n:nr*n,:);
        zn = specz(1+(nr-1)*n:nr*n);
        len_zn = length(zn)

        if algor=='NN'
            ulayers = [15,15,15]; % train with len(ulayers) hidden layers, # hidden units each
            [net, photz, mse, test_photz] = do_fitnet(ulayers, datn, zn, test_dat);
        elseif algor=='RF'
            [mdl, photz, mse, test_photz] = do_fitrensemble(datn, zn, test_dat);
        end

        ad = calc_absdev(test_specz, test_photz);
        size_ad = size(ad) % check this
        abs_dev = cat(1,abs_dev, ad); % pool this for all runs for this n
        size_abs_dev = size(abs_dev) % check this
    end
    %%

    [NMAD, out10] = calc_zerrors(abs_dev);
    errs(i,2) = NMAD;
    errs(i,3) = out10;
    errs(i,4) = mse;
    errs
end
%%

plot_errors(errs, algor, Nruns);
