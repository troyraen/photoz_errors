function [NMAD, out10] = calc_zerrors(specz, photz)
% zspec is true redshift
% zphot is predicted redshift
% both should be column vectors
% Returns normalized median absolute deviation (NMAD)
%           and fraction of 10% outliers, where NAD > 0.1 (out10)

NAD = abs(photz - specz)./(1+specz);
NMAD = median(NAD);

N = length(specz);
out10_bool = NAD > 0.1;
out10 = sum(out10_bool)/N;

