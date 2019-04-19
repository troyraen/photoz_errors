cd /home/tjr63/Documents/photoz_errors/matlab/

cols = {'redshift','tu','tg','tr','ti','tz','ty', ...
        'u10','uerr10','g10','gerr10','r10','rerr10', ...
        'i10','ierr10','z10','zerr10','y10','yerr10'};

% ccols = {'id','redshift','tu','tu_m_tg','tg_m_tr','tr_m_ti','ti_m_tz','tz_m_ty'}
ccols = {'id','redshift','u10','u10_m_g10','g10_m_r10','r10_m_i10', ...
            'i10_m_z10','z10_m_y10'};
%%%%% MAKE SURE THESE MATCH WHAT WAS WRITTEN USING data_proc.py %%%%%


Nsampszs = 5;
max_sampsz = 30000;
Nruns = 5;

%%% Neural Nets
[errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'NN', [])

%%% Random Forest
[errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'RF', [])

%%% GPz
% fdat = '../GPz/data/sdss_sample.csv'
fdat = '../data/CG_GPz.mtxt'
maxIter = 250
[errs] = do_samples(Nsampszs, max_sampsz, Nruns, 'GPz', [fdat, maxIter])
