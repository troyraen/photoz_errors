function [abs_dev] = calc_absdev(specz, photz)
% Returns the absolute deviation.
% Send this to calc_zerrors()

abs_dev = abs(photz - specz)./(1+specz);
