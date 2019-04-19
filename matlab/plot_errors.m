function [] = plot_errors(errs, algor, Nruns, fout)
% errs = n (samples) x 4 matrix.
%       column 1 = sample size, 2 = NMAD, 3 = out10, 4 = mse
% algor = string indicating which algorithm is plotted
% Nruns = number of runs per sample size. =-1 for unknown (used to title plot)
% fout = string will save plot to file with this path
% Plots NMAD and out10 vs sample size

ss = errs(:,1);

figure(111)
clf('reset')

ax1 = subplot(1,2,1);
ydat = errs(:,2);
% Plot data
semilogx(ax1,ss,ydat, 'ob')
hold on;
% Find and plot polynomial fit
x = linspace(min(ss), max(ss), 100);
fun = @(c,x) c(1) + c(2).*x.^c(3);
c0 = [0.02, 0.5, -0.5];
% coef = lsqcurvefit(fun,c0,ss,ydat)
coef = nlinfit(ss,ydat,fun,c0)
a = coef(1); b = coef(2); c = coef(3);
semilogx(ax1,x,a+b.*x.^c,'-g')
fit = strcat(num2str(round(a,4)),'+',num2str(round(b,1)),'N\^(',num2str(round(c,1)),')')
% Decorate plot
legend(ax1, {'data', fit}, 'fontsize',18)
xlabel(ax1,'Training Sample Size');
ylabel(ax1,'NMAD');



ax2 = subplot(1,2,2);
% set(gca,'fontsize', 24);
ydat = errs(:,3);
% Plot data
semilogx(ax2,ss,ydat, 'ob')
hold on;
% Find and plot polynomial fit
coef = nlinfit(ss,ydat,fun,c0)
a = coef(1); b = coef(2); c = coef(3);
semilogx(ax2,x,a+b.*x.^c,'-g')
fit = strcat(num2str(round(a,4)),'+',num2str(round(b,1)),'N\^(',num2str(round(c,1)),')')
% Decorate plot
legend(ax2, {'data', fit}, 'fontsize',18)
xlabel(ax2,'Training Sample Size');
ylabel(ax2,'10% Outlier Fraction');


% figure(113)
% ax3 = subplot(1,3,3);
% semilogx(ax3,ss,errs(:,4))
% xlabel(ax3,'Training Sample Size');
% ylabel(ax3,'Mean Squred Error');

sgtitle(strcat('Algorithm: ',algor, '. Runs/sample size: ',num2str(Nruns)))
if isa(fout,'char')
    % fout = strcat('plots/errs',algor,'.png');
    % py.helper_fncs.file_ow(fout); % rename existing file
    saveas(111,fout)
end


end
