function [NMAD, out10] = calc_zerrors(abs_dev)
% zspec is true redshift
% zphot is predicted redshift
% both should be column vectors
% Returns normalized median absolute deviation (NMAD)
%           and fraction of 10% outliers, where NAD > 0.1 (out10)

NMAD = 1.48* median(abs_dev);
out10 = sum(abs_dev > 0.1)/length(abs_dev);
