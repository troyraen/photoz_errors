function [NMAD, out10] = calc_zerrors(specz, photz)
% zspec is true redshift
% zphot is predicted redshift
% both should be column vectors
% Returns normalized median absolute deviation (NMAD)
%           and fraction of 10% outliers, where NAD > 0.1 (out10)

N = length(specz);

NAD = abs(photz - specz)./(1+specz);
NMAD = 1.48* median(NAD);
out10 = sum(NAD > 0.1)/N;
