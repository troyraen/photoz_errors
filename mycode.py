import pandas as pd
import numpy as np



# load data
# nrows = 3804010 #11000
cat_fnm = 'data/Catalog_Graham+2018_10YearPhot.dat'
cat_fnm = 'Catalog_Graham+2018_10YearPhot.dat'
cols = ['id','redshift','tu','tg','tr','ti','tz','ty', 'u10','uerr10','g10','gerr10','r10','rerr10','i10','ierr10','z10','zerr10','y10','yerr10']
df = pd.DataFrame( np.array( pd.read_csv(cat_fnm,delim_whitespace=True,comment='#',header=None) ) )#,nrows=nrows
# -or- load a sample (generated below)
cat_fnm = 'CGsample.dat'
df = pd.DataFrame( np.array( pandas.read_csv(cat_fnm,delim_whitespace=True,comment='#',header=None) ) )

df.columns = cols



# correlations
# corrdff = 'data/corrdf.txt'
corrdff = 'corrdf.mtxt' # formatted for matlab (strip header, etc)
corrdf = df.corr()
# strip id row and column
corrdf.iloc[1:].to_csv(corrdff, columns=cols[1:], header=False, index=False)
# load from file
corrdf = pd.read_csv(corrdff)
corrdf.sort_values('redshift', ascending=False)


# store a smaller sample
nsamp = 20000
for i in range(5):
	csampf = 'data/CGsample{}.dat'.format(i)
	csamp = df.sample(nsamp)
	csamp.to_csv(csampf)
