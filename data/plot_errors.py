import numpy as np
import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

# set plot defaults
mpl.rcParams['figure.figsize'] = [14.0, 8.0]
mpl.rcParams['font.size'] = 14
mpl.rcParams['legend.fontsize'] = 'small'
mpl.rcParams['figure.titlesize'] = 'medium'

errcols = ['Nsamples', 'NMAD', 'out10', 'mse']



def plot_errors(base_path='', flist=[], lgnd=[], styl=[], title='', fout=None):

    f, axs = plt.subplots(sharex=True, nrows=1,ncols=2)

    # Do plot for each file separately
    for i, fin in enumerate(flist):
        ci = styl[i]

        # Get df from file
        errdf = get_errdf(base_path+fin)
        Nsamps = errdf.Nsamples

        # For each subplot
        stats = ['NMAD','out10']
        for j, stat in enumerate(stats):
            axj = axs[j]

            # Scatter plot data
            ls = ci+'o'
            yerr = errdf[stat]
            axj.semilogx(Nsamps, yerr, ls, label='')

            # Do and plot the fit
            ls = ci+'-'
            [a,b,c] = get_fit(errdf, stat)
            lbl = '{i}: {a}+{b}N^({c})'.format(i=lgnd[i], a=np.round(a,2), b=np.round(b,2), c=np.round(c,1))
            NNN = np.logspace(np.log10(np.min(Nsamps)), np.log10(np.max(Nsamps)), 1000)
            yfit = fit_fnc(NNN, a, b, c)
            axj.semilogx(NNN, yfit, ls, label=lbl)

    # Labels, legends
    for j, stat in enumerate(stats):
        axj = axs[j]
        axj.set_ylabel(stat if stat!='out10' else '10% Outlier Fraction')
        axj.set_xlabel('Training Sample Size (N)')
        axj.legend()
    f.suptitle(title)

    if fout is not None:
        plt.savefig(fout)
    plt.show(block=False)

    return None


def get_errdf(fin):
    global errcols
    return pd.read_csv(fin, header=None, names=errcols, sep='\s+')

def fit_fnc(N, a, b, c):
    return a+ b* (N**(c))

def get_fit(df, stat):
    c0 = (0.02, 0.75, -0.4)
    fit = curve_fit(fit_fnc, df['Nsamples'], df[stat], p0=c0)
    return fit[0]
