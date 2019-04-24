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
    # styl is really just colors

    f, axs = plt.subplots(sharex=True, nrows=1,ncols=2)

    # Do plot for each file separately
    for i, fin in enumerate(flist):
        ci = styl[i]

        # Get df from file
        try:
            errdf = get_errdf(base_path+fin)
        except:
            print('Errors data file not found. \n{}'.format(base_path+fin))
            continue
        Nsamps = errdf.Nsamples

        # For each subplot
        stats = ['NMAD','out10']
        for j, stat in enumerate(stats):
            axj = axs[j]

            # Scatter plot data
            # ls = ci+'o'
            yerr = errdf[stat]
            axj.semilogx(Nsamps, yerr, 'o', c=ci, label='')

            # Do and plot the fit
            # ls = ci+'-'
            try:
                [a,b,c] = get_fit(errdf, stat)
            except:
                [a,b,c] = [0.0, 1.0, -0.5]
                # print the legend
                axj.semilogx(Nsamps, yerr, 'o', c=ci, label='{i}: (fit not found)'.format(i=lgnd[i]))
                print('Problem fitting:\nstat {}\nfile {}'.format(stat,fin))
            else:
                lbl = '{i}: {a}+{b}N^({c})'.format(i=lgnd[i], a=np.round(a,2), b=np.round(b,2), c=np.round(c,1))
                NNN = np.logspace(np.log10(np.min(Nsamps)), np.log10(np.max(Nsamps)), 1000)
                yfit = fit_fnc(NNN, a, b, c)
                axj.semilogx(NNN, yfit, '-', c=ci, label=lbl)

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
    c0 = (0.0, 1.0, -0.5)
    fit = curve_fit(fit_fnc, df['Nsamples'], df[stat], p0=c0)
    return fit[0]
