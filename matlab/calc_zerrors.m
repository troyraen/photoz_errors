function [NMAD, out10] = calc_zerrors(zdev)
% zdev = (photz - specz)./(1+specz) (as returned by calc_zdev.m)
% Returns normalized median absolute deviation (NMAD)
%           and fraction of 10% outliers, where NAD > 0.1 (out10)

abs_dev = abs(zdev);
NMAD = 1.48* median(abs_dev);
out10 = sum(abs_dev > 0.1)/length(abs_dev);
