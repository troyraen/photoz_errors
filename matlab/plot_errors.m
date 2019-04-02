function [] = plot_errors(errs)
% errs = n (samples) x 4 matrix.
%       column 1 = sample size, 2 = NMAD, 3 = out10, 4 = mse
% Plots NMAD and out10 vs sample size

ss = errs(:,1);

figure(111)
semilogx(ss,errs(:,2))
xlabel('Training Sample Size');
ylabel('NMAD');


figure(112)
semilogx(ss,errs(:,3))
xlabel('Training Sample Size');
ylabel('# Outliers');


figure(113)
semilogx(ss,errs(:,4))
xlabel('Training Sample Size');
ylabel('Mean Squred Error');
