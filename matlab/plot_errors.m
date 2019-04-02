function [] = plot_errors(errs, algor)
% errs = n (samples) x 4 matrix.
%       column 1 = sample size, 2 = NMAD, 3 = out10, 4 = mse
% algor = string indicating which algorithm is plotted
% Plots NMAD and out10 vs sample size

ss = errs(:,1);

figure(111)
title(strcat('Algorithm: ',algor))

% ax1 = subplot(1,3,1);
ax1 = subplot(1,2,1);
semilogx(ax1,ss,errs(:,2))
xlabel(ax1,'Training Sample Size');
ylabel(ax1,'NMAD');


% ax2 = subplot(1,3,2);
ax2 = subplot(1,2,2);
semilogx(ax2,ss,errs(:,3))
xlabel(ax2,'Training Sample Size');
ylabel(ax2,'Fraction of 10% Outliers');


% figure(113)
% ax3 = subplot(1,3,3);
% semilogx(ax3,ss,errs(:,4))
% xlabel(ax3,'Training Sample Size');
% ylabel(ax3,'Mean Squred Error');

saveas(111,strcat('plots/errs',algor,'.png'))
