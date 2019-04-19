

# Get and Plot errors data (1 file per algorithm)
<!-- fs -->
```Matlab
datadir = '/Users/troyraen/Korriban/Documents/photoz_errors/data';
err_files = dir(strcat(datadir,'/errors*'));
num_files = length(err_files);
for i=1:num_files
    % Get algorithm name and error data:
    tmp = strsplit(err_files(i).name, '.');
    tmp = strsplit(tmp{1}, 'errors');
    algor = tmp{2};

    path = strcat(err_files(i).folder, '/', err_files(i).name);
    algor_errs = load(strcat(err_files(i).folder, '/', err_files(i).name));

    % Plot
    Nruns = -1; % unknown number of runs
    save = 1; % save to file
    plot_errors(algor_errs, algor, Nruns, save);
end
```
<!-- fe Get and Plot errors data -->



# DEBUGGING and TESTING NOTES
<!-- fs -->

## Save errors to color data files
<!-- fs -->
```python
import data_proc as dp
df = dp.load_from_file(which='all')
cdf = dp.calc_colors(df)
```
<!-- fe ## Save errors to color data files -->

## Trying to bring down [NMAD, out10] = 0.0424, 0.1584
<!-- fs -->
```Matlab
fdat = '../data/CG_GPz.mtxt';
Nexamples = [100000, 100000, 100000];
maxIter = 200;
[other, test_specz, mse, test_photz] = do_fitGPz(fdat, maxIter, Nexamples);
other % = [out10, diff_frout10]
zdev = calc_zdev(test_specz, test_photz);
[NMAD, out10] = calc_zerrors(zdev) % = (0.0424, 0.1584 maxIter50); , 0.1189
```

- [ ] try with ugriz only

<!-- fe ## Trying to bring down [NMAD, out10] = 0.0424, 0.1584 -->



## NMAD, out10 don't make sense. Resolution: Korriban local file had unknown error.
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



<!-- fe # DEBUGGING and TESTING NOTES -->