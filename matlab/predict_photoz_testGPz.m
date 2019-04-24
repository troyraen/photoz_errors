% cd /home/tjr63/Documents/photoz_errors/matlab/

cols = {'redshift','tu','tg','tr','ti','tz','ty', ...
        'u10','uerr10','g10','gerr10','r10','rerr10', ...
        'i10','ierr10','z10','zerr10','y10','yerr10'};

% ccols = {'id','redshift','tu','tu_m_tg','tg_m_tr','tr_m_ti','ti_m_tz','tz_m_ty'}
ccols = {'id','redshift','u10','u10_m_g10','g10_m_r10','r10_m_i10', ...
            'i10_m_z10','z10_m_y10'};
%%%%% MAKE SURE THESE MATCH WHAT WAS WRITTEN USING data_proc.py %%%%%


Nsampszs = 5;
max_sampsz = 30000;
Nruns = 2;
machine = 'Roy';

%%% GPz
'DOING GPz'
% use:
% fout_tag = '_mIt250_';
% params = {heteroscedastic, csl_method, maxAttempts, inputNoise, method};
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat, maxIter, ...
%                 params}, machine )
%
% fdat = '../GPz/data/sdss_sample.csv'
base_path = '/Users/troyraen/Korriban/Documents/photoz_errors/';
fdat = strcat(base_path, 'data/CG_GPz_Roy.mtxt');
maxIter = 250; % default 200

% defaults:
heteroscedastic = true;
csl_method = 'normal';
maxAttempts = 50;
inputNoise = true;
method = 'VD';


% EXITS WITH ERROR
% fout_tag = '_mIt250_methodVC';
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat, maxIter, ...
%                 {heteroscedastic, csl_method, maxAttempts, inputNoise, 'VC'}}, machine )


% fout_tag = '_mIt250_cslBalncd_methodVC';
% params = {heteroscedastic, 'balanced', maxAttempts, inputNoise, 'VC'};
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat, maxIter, ...
%                 params}, machine )



% fs not done
%
% fout_tag = '_mIt150_cslNormalized';
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat, maxIter, ...
%                 {heteroscedastic, 'normalized', maxAttempts, inputNoise}, machine })
%
%
% fout_tag = '_mIt150_cslNormalized_hetFalse';
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat, maxIter, ...
%                 {false, 'normalized', maxAttempts, inputNoise, method}, machine })
%
% fe not done


% fs completed
%
% Nsampszs = 5;
% max_sampsz = 30000;
% Nruns = 3;
%
%%% Neural Nets
% 'DOING NEURAL NETS'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'NN', [])
%
%%% Random Forest
% 'DOING RANDOM FOREST'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'RF', [])
%
% %%% GPz
% 'DOING GPz'
% % fdat = '../GPz/data/sdss_sample.csv'
% fdat = '../data/CG_GPz.mtxt'
% maxIter = 50
%
% % defaults:
% heteroscedastic = true;
% csl_method = 'normal';
% maxAttempts = 50;
% inputNoise = true;
% fplt = 'plots/GPz/Defalts.png'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', {fdat, maxIter, fplt, ...
%                 {heteroscedastic, csl_method, maxAttempts, inputNoise} })

%
% fplt = 'plots/GPz/hskFalse.png'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', {fdat, maxIter, fplt, ...
%                 {false, csl_method, maxAttempts} })
%
% fplt = 'plots/GPz/cslNormalized.png'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', {fdat, maxIter, fplt, ...
%                 {heteroscedastic, 'normalized', maxAttempts} })
%
% fplt = 'plots/GPz/maxatt200.png'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', {fdat, maxIter, fplt, ...
%                 {heteroscedastic, csl_method, 200} })
%
% %%
% fplt = 'plots/GPz/SDSSdat.png'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', {'../GPz/data/sdss_sample.csv', maxIter, fplt, ...
%                 {heteroscedastic, csl_method, maxAttempts, inputNoise} })
%
% fplt = 'plots/GPz/inNoiseFalse.png'
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', {fdat, maxIter, fplt, ...
%                 {heteroscedastic, csl_method, maxAttempts, false} })
%
%

% Nsampszs = 5;
% max_sampsz = 30000;
% Nruns = 2;
% machine = 'Roy';
%
% %%% GPz
% 'DOING GPz'
% % params = {heteroscedastic, csl_method, maxAttempts, inputNoise, method};
% % fdat = '../GPz/data/sdss_sample.csv'
% base_path = '/Users/troyraen/Korriban/Documents/photoz_errors/';
% fdat = strcat(base_path, 'data/CG_GPz_Roy.mtxt');
% maxIter = 250; % default 200
%
% % defaults:
% heteroscedastic = true;
% csl_method = 'normal';
% maxAttempts = 50;
% inputNoise = true;
% method = 'VD';
%
%
% fout_tag = '_mIt250_cslBalanced';
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat, maxIter, ...
%                 {heteroscedastic, 'balanced', maxAttempts, inputNoise, method}}, machine )
%
% fout_tag = '_mIt250_Defaults';
% params = {heteroscedastic, csl_method, maxAttempts, inputNoise, method};
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat, maxIter, ...
%                 params}, machine )
%
%
% fout_tag = '_mIt250_0errs';
% fdat0 = strcat(base_path, 'data/CG_GPz_0errs_Roy.mtxt');
% [errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', fout_tag, {fdat0, maxIter, ...
%                 {heteroscedastic, csl_method, maxAttempts, inputNoise, method}}, machine )
%
%
% fe completed
