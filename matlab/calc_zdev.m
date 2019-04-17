function [zdev] = calc_zdev(specz, photz)
% Returns the absolute deviation.
% Send this to calc_zerrors()

zdev = (photz - specz)./(1+specz);
