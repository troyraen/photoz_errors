import pandas as pd
import numpy as np

cols = ['id','redshift','tu','tg','tr','ti','tz','ty', 'u10','uerr10','g10','gerr10','r10','rerr10','i10','ierr10','z10','zerr10','y10','yerr10']
ccols = ['id','redshift','tu','tu_m_tg','tg_m_tr','tr_m_ti','ti_m_tz','tz_m_ty']

def calc_colors(df):
	global cols
	global ccols
	clbls = ccols[3:]

	# instantiate
	cdf = df.loc[:,['id','redshift','tu']]

	# add colors
	for i in range(len(clbls)):
		nm = clbls[i]
		# get mags to be subtracted
		rdnm = nm[0:2]
		blnm = nm[-2:]
		# write color column
		cdf[nm] = df[rdnm]-df[blnm]

	return cdf

# cdf = calc_colors(df)



def load_from_file(which='sample'):
	global cols

	if which=='all':
		# nrows = 3804010 # all the rows
		cat_fnm = 'Catalog_Graham+2018_10YearPhot.dat'
		df = pd.DataFrame( np.array( pd.read_csv(cat_fnm,delim_whitespace=True,comment='#',header=None) ) )#,nrows=nrows

	if which=='sample':
		cat_fnm = 'CGsample.dat'
		df = pd.DataFrame( np.array( pandas.read_csv(cat_fnm,delim_whitespace=True,comment='#',header=None) ) )

	df.columns = cols

	return df


def correlations(dowhat='load', df=None):
	global cols
	corrdff = 'corrdf.mtxt' # formatted for matlab (strip header, etc)

	if dowhat=='save':
		corrdf = df.corr()
		corrdf.iloc[1:].to_csv(corrdff, columns=cols[1:], header=False, index=False) # strip id row and column

	elif dowhat=='load':
		corrdf = pd.read_csv(corrdff)
		# corrdf.sort_values('redshift', ascending=False)

	return 0


def write_sample(df, nfiles=5, nsamp=20000, fmt='mtxt', basenm='CGsample'):
	# store a smaller sample

	randdf = df.sample(frac=1).reset_index(drop=True) # randomize rows

	for i in range(nfiles):
		csampf = '{basenm}{n}.{fmt}'.format(basenm=basenm,n=i,fmt=fmt)
		csamp = randdf.loc[i*nsamp:(i+1)*nsamp-1]

		hdr=True
		idx=True
		if fmt=='mtxt': # strip index and header
			hdr=False
			idx=False

		csamp.to_csv(csampf, header=hdr, index=idx)

# write_sample(cdf,basenm='colors',nsamp=30000)
