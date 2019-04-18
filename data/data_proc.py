# import data_proc as dp # import this module
import pandas as pd
import numpy as np

cols = ['id','redshift','tu','tg','tr','ti','tz','ty', 'u10','uerr10','g10','gerr10','r10','rerr10','i10','ierr10','z10','zerr10','y10','yerr10']
# ccols = ['id','redshift','tu','tu_m_tg','tg_m_tr','tr_m_ti','ti_m_tz','tz_m_ty']
ccols = ['id','redshift','u10','u10_m_g10','g10_m_r10','r10_m_i10',
            'i10_m_z10','z10_m_y10']
Ntot = 3804010 # Number of samples in Catalog_Graham+2018_10YearPhot.dat

def load_from_file(which='all'):
	global cols

	if which=='all':
		cat_fnm = 'Catalog_Graham+2018_10YearPhot.dat'
		df = pd.DataFrame( np.array( pd.read_csv(cat_fnm,delim_whitespace=True,comment='#',header=None) ) )#,nrows=nrows

	if which=='sample':
		cat_fnm = 'CGsample.dat'
		df = pd.DataFrame( np.array( pandas.read_csv(cat_fnm,delim_whitespace=True,comment='#',header=None) ) )

	df.columns = cols

	print('Loaded data from {}'.format(cat_fnm))
	print('df columns = {}'.format(cols))

	return df
# df = dp.load_from_file(which='all')


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
		rdnm, __, blnm = clbls[i].split('_')
		# write color column
		cdf[nm] = df[rdnm]-df[blnm]

	return cdf
# cdf = dp.calc_colors(df)


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


def write_sample_GPz(fout='CG_GPz.mtxt'):
    # Format cat_fnm for use with GPz
    # GPz req's columns [m_1,m_2,..,m_k,e_1,e_2,...,e_k,z_spec]
    df = load_from_file(which='all')

    gpz_cols = ['u10','g10','r10','i10','z10','y10', \
                'uerr10','gerr10','rerr10','ierr10','zerr10','yerr10', \
                'redshift']

    hdr = False
    idx = False
    df.to_csv(fout, columns=gpz_cols, header=hdr, index=idx)

    return None
# dp.write_sample_GPz()

def write_sample(df, nfiles=5, nsamp=20000, fmt='mtxt', basenm='CGsample'):
	# store a smaller sample
    global Ntot

    randdf = df.sample(frac=1).reset_index(drop=True) # randomize rows

    for i in range(nfiles):
        csampf = '{basenm}{n}.{fmt}'.format(basenm=basenm,n=i,fmt=fmt)
        end_loc = (i+1)*nsamp-1 if ( (i+1)*nsamp-1 < Ntot) else Ntot
        csamp = randdf.loc[i*nsamp:end_loc]

        hdr=True
        idx=True
        if fmt=='mtxt': # strip index and header
            hdr=False
            idx=False

        csamp.to_csv(csampf, header=hdr, index=idx)

    return None
# dp.write_sample(cdf,basenm='colors',nsamp=30000)
# dp.write_sample(cdf, nfiles=3, nsamp=1000000, fmt='mtxt', basenm='colors')
# dp.write_sample(cdf, nfiles=2, nsamp=3000000, fmt='mtxt', basenm='colors')
