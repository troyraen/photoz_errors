import os
import numpy as np
import pandas
from pandas import DataFrame
from scipy.stats import *
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import matplotlib.cm as colormap
from collections import OrderedDict
# from photoz_tools import stats_d1pz
import linecache
import scipy.signal
import random 

def plot_distributions(data):

    fig = plt.figure(figsize=(8,8))
    plt.rcParams.update({'font.size':20})
    plt.hist( data['redshift'].values, normed=True )
    plt.xlabel('True Catalog Redshift')
    plt.ylabel('Fraction of Galaxies')
    plt.savefig('plots/figure_true_redshift_histogram',bbox_inches='tight')

    for filt in ['u','g','r','i','z','y']:

        fig = plt.figure(figsize=(8,8))
        plt.rcParams.update({'font.size':20})
        plt.hist( data['t'+filt].values, normed=True )
        plt.xlabel('True '+filt+'-band Apparent Magnitude')
        plt.ylabel('Fraction of Galaxies')
        plt.savefig('plots/figure_true_'+filt+'mag_histogram',bbox_inches='tight')

        fig = plt.figure(figsize=(8,8))
        plt.rcParams.update({'font.size':20})
        plt.hist( data[filt+'10'].values, normed=True )
        plt.xlabel('Observed '+filt+'-band Apparent Magnitude [10 Year]')
        plt.ylabel('Fraction of Galaxies')
        plt.savefig('plots/figure_obs_'+filt+'mag_histogram',bbox_inches='tight')


def main():
    cat_fnm = 'Catalog_Graham+2018_10YearPhot.dat'
    cat_data = DataFrame( np.array( pandas.read_csv(cat_fnm,delim_whitespace=True,comment='#',nrows=11000,header=None) ) )
    cat_data.columns = ['id','redshift','tu','tg','tr','ti','tz','ty',\
    'u10','uerr10','g10','gerr10','r10','rerr10','i10','ierr10','z10','zerr10','y10','yerr10']

    # Just use a random sample of 10000 galaxies to make the plot
    plot_distributions( cat_data.loc[random.sample(list(cat_data.index),10000)] )




if __name__ == '__main__':
    main()






























