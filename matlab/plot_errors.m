function [] = plot_errors(errs, algor, Nruns, save)
% errs = n (samples) x 4 matrix.
%       column 1 = sample size, 2 = NMAD, 3 = out10, 4 = mse
% algor = string indicating which algorithm is plotted
% Nruns = number of runs per sample size. =-1 for unknown (used to title plot)
% save = 1 will save plot to file
% Plots NMAD and out10 vs sample size

ss = errs(:,1);

figure(111)
clf('reset')
sgtitle(strcat('Algorithm: ',algor, '. Runs/sample size: ',num2str(Nruns)))

% ax1 = subplot(1,3,1);
ax1 = subplot(1,2,1);
semilogx(ax1,ss,errs(:,2))
xlabel(ax1,'Training Sample Size');
ylabel(ax1,'NMAD');


% ax2 = subplot(1,3,2);
ax2 = subplot(1,2,2);
semilogx(ax2,ss,errs(:,3))
xlabel(ax2,'Training Sample Size');
ylabel(ax2,'10% Outlier Fraction');


% figure(113)
% ax3 = subplot(1,3,3);
% semilogx(ax3,ss,errs(:,4))
% xlabel(ax3,'Training Sample Size');
% ylabel(ax3,'Mean Squred Error');

if save==1
    fout = strcat('plots/errs',algor,'.png');
    % py.helper_fncs.file_ow(fout); % rename existing file
    saveas(111,fout)
end
