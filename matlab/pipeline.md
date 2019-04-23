# Call python to use hf.file_ow
<!-- fs -->
fow = 'plots/errsNN.png';
command = strcat("python -c $'import helper_fncs as hf; hf.file_ow(\'",fow,"\')'");
status = system(command);

<!-- fe # Call python to use hf.file_ow -->

# .
<!-- fs -->
use data/data_proc.py to convert datasets for matlab input.
<!-- fe -->

# Final Plots:
<!-- fs -->

## All errors, 1 plot
<!-- fs -->
cd data
```python
import plot_errors as pe
import helper_fncs as hf
base_path = '/Users/troyraen/Korriban/Documents/photoz_errors/data/'
flist = ['errorsNN_2x10.mtxt', 'errorsNN_3x15.mtxt', 'errorsRF.mtxt', 'errorsGPz.mtxt']
lgnd = ['NN_2x10', 'NN_3x15', 'RF', 'GPz']
styl = ['c', 'b', 'g', 'r']
title = 'Errors in Photo_z estimates'
fout = base_path+'errors_plots/errors.png'
fout_ow = hf.file_ow(fout)
pe.plot_errors(base_path=base_path, flist=flist, lgnd=lgnd, styl=styl, title=title, fout=fout)
```

<img src="../data/errors_plots/errors.png" alt="errors.png" width="900"/>


<!-- fe # All errors, 1 plot -->


## Individuals

<!-- fs -->
#### NN
__2x10__
<img src="plots/errorsNN_2x10.png" alt="errorsNN_2x10" width="500"/>

__3x10__
<img src="plots/errorsNN_3x15.png" alt="errorsNN_3x15" width="500"/>
<img src="plots/errorsNN.png" alt="errorsNN also 3x15" width="500"/>

#### RF
<img src="plots/errorsRF.png" alt="errorsRF" width="500"/>

#### GPz
<img src="plots/errorsGPz.png" alt="errorsGPz" width="500"/>

<!-- fe ## Individuals  -->

<!-- fe # Final Plots -->



# DEBUGGING and TESTING NOTES
<!-- fs -->

- [x] change # neural nets
- [x] look at RF settings
- [x] look at GPz



## Save errors to color data files
<!-- fs -->
```python
import data_proc as dp
df = dp.load_from_file(which='all')
cdf = dp.calc_colors(df)
```
<!-- fe ## Save errors to color data files -->


## - [x] Check RF
<!-- fs -->
use predict_photoz_testRF.m

- [x] training cycles nlc100, nlc500, nlc1000
    - all very similar to each other. short runtimes.
    - all terminate normally after requested number of training cycles
    <img src="plots/errorsRF_nlc100.png" alt="errorsRF_nlc100" width="400"/><img src="plots/errorsRF_nlc500.png" alt="errorsRF_nlc500" width="400"/><img src="plots/errorsRF_nlc1000.png" alt="errorsRF_nlc1000" width="400"/>

- [x] Cross validation nlc500_CVon
    - very similar to CVoff case. no noticeable runtime difference
    <img src="plots/errorsRF_nlc500_CVon.png" alt="errorsRF_nlc500_CVon" width="400"/>


<!-- fe ## Check RF -->



## - [x] Check NN
<!-- fs -->
use predict_photoz_testNN.m

All with 2x10 and 3x15
- [x] epoch 500 max_fail 100. errorsNN_2x10_e500mf100
    - looks good, can probably do max_fail=50 (didn't see any models that improved after that).
    <img src="plots/errorsNN_2x10_e500mf100.png" alt="errorsNN_2x10_e500mf100" width="400"/><img src="plots/errorsNN_3x15_e500mf100.png" alt="errorsNN_3x15_e500mf100" width="400"/>

<!-- fe ## Check NN -->


## Check GPz: Trying to bring down [NMAD, out10] = 0.0424, 0.1584
<!-- fs -->
Code run from predict_photoz_testGPz.m

- [x] CURRENT BEST: more sample sizes and maxIter250, inNoisefalse # fout_tag = mI250_iNfls
    - <img src="plots/GPz/maxIter250_inNoisefalse.png" alt="maxIter250_inNoisefalse" width="500"/>

- [x] Default Settings
    - <img src="plots/GPz/Defalts.png" alt="Defaults" width="500"/>

- [x] maxIter = 500;
    - A BIT BETTER AS TRAINING SIZE INCREASES
    - <img src="plots/GPz/maxItr500.png" alt="maxItr500" width="500"/>
    - [x] git add matlab/plots/GPz/maxItr500.png

- [x] csl_method = 'normalized';
    - SIMILAR NMAD, 7% HIGHER OUT10 WITH HIGHER VARIANCE btwn sample sizes
    - <img src="plots/GPz/cslNormalized.png" alt="cslNormalized" width="500"/>

- [x] heteroscedastic = false;
    - code notes say: "set to false if only interested in point estimates [default=true]"
    - 2-12% HIGHER NMAD, SIMILAR OUT10
    - <img src="plots/GPz/hskFalse.png" alt="hskFalse" width="500"/>

- [x] maxAttempts = 200;
    - NO DIFFERENCE
    - <img src="plots/GPz/maxatt200.png" alt="maxatt200" width="500"/>

- [x] fdat = '../GPz/data/sdss_sample.csv';
    - BETTER ALL AROUND
    - <img src="plots/GPz/SDSSdat.png" alt="SDSSdat" width="500"/>
    - [x] git add matlab/plots/GPz/SDSSdat.png

- [x] inputNoise = false; # BETTER ALL AROUND
    - BETTER ALL AROUND
    - <img src="plots/GPz/inNoiseFalse.png" alt="inNoiseFalse" width="500"/>
    - [x] git add matlab/plots/GPz/inNoiseFalse.png


- [x] check that input file was written correctly
- [ ] try with ugriz only


<!-- fe ## Check GPz: Trying to bring down [NMAD, out10] = 0.0424, 0.1584 -->




<!-- fe # DEBUGGING and TESTING NOTES -->


# Archive
<!-- fs -->


# Get and Plot errors data
<!-- fs -->
```Matlab
plotdir = '/Users/troyraen/Korriban/Documents/photoz_errors/matlab/plots';
datadir = '/Users/troyraen/Korriban/Documents/photoz_errors/data';
err_files = dir(strcat(datadir,'/errors*'));
% err_files = dir(strcat(datadir,'/errors*_ow_041919_1406.mtxt'));
num_files = length(err_files);
for i=1:num_files
    % Get algorithm name and error data:
    tmp = strsplit(err_files(i).name, '.');
    tmp = strsplit(tmp{1}, 'errors');
    tmp = strsplit(tmp{2}, '_');
    if max(size(tmp))>1 % get only most current/default file
        continue
    end
    algor = tmp{1}

    path = strcat(err_files(i).folder, '/', err_files(i).name);
    algor_errs = load(strcat(err_files(i).folder, '/', err_files(i).name));

    % Plot
    Nruns = 3;
    save = strcat(plotdir,'/errors_fit_',algor,'.png') % 0; % save to file
    plot_errors(algor_errs, algor, Nruns, save);
end
```
<!-- fe Get and Plot errors data -->




## - [x] NMAD, out10 don't make sense. Resolution: Korriban local file had unknown error.
<!-- fs -->
NMAD = 1.4651; out10 = 1 for fdat = '../data/CG_GPz.mtxt';
```Matlab
% fdat = '../GPz/data/sdss_sample.csv';
fdat = '../data/CG_GPz.mtxt';
Nexamples = [100000, 100000, test_N];
maxIter = 50;
[other, test_specz, mse, test_photz] = do_fitGPz(fdat, maxIter, Nexamples);
other % = [out10, diff_frout10] = 0.0260   -0.0000; 0.1584   -0.0000
zdev = calc_zdev(test_specz, test_photz);
[NMAD, out10] = calc_zerrors(zdev) % = 1.4653, 1; = 0.0231, 0.0260; 0.0424, 0.1584

```
- [ ] try with ugriz only
- [ ] try letting it set sample fractions


<!-- fe ## NMAD, out10 don't make sense -->


<!-- fe Archive -->
