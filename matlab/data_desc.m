%% Python code to generate corrdf.mtxt
% cat_fnm = 'Catalog_Graham+2018_10YearPhot.dat'
% 
% cols = ['id','redshift','tu','tg','tr','ti','tz','ty','u10','uerr10','g10','gerr10','r10','rerr10','i10','ierr10','z10','zerr10','y10','yerr10']
% 
% df = pd.DataFrame( np.array( pd.read_csv(cat_fnm,delim_whitespace=True,comment='#',header=None) 
% ) )
% 
% df.columns = cols
% 
% corrdff = 'corrdf.mtxt' # formatted for matlab (strip header, etc)
% 
% corrdf = df.corr() 
% 
% corrdf.to_csv(corrdff, columns=cols[1:], header=False, index=False)
% 
% 

addpath('/Users/troyraen/Documents/ML_Spring19/Homework/matlab_functions')
load /Users/troyraen/Korriban/Documents/MLProject/data/corrdf.mtxt
%%
% write table
rows = {'redshift';'tu';'tg';'tr';'ti';'tz';'ty';'u10';'uerr10';'g10';'gerr10';'r10';'rerr10';'i10';'ierr10';'z10';'zerr10';'y10';'yerr10'};
zcorr = corrdf(:,1);
writelatextable('',{'Correlations with Redshift'}, rows, zcorr, 4)
%%


%%


%%


%%


%%


%%