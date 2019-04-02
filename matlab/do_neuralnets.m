function [errs] = do_neuralnets(dat, specz, test_dat, test_specz, numruns)
% dat and test_dat = matrix n (examples) x d (features)
% specz and test_specz = n x 1 (true redshifts)
% numruns = number of training runs to do (each with different sample size)

l = length(specz);
nsamp = uint16(logspace(log10(1000),log10(l),numruns));
% nsamp=[1000, 2500, 5000, 10000, 15000, 20000];
ln = length(nsamp);

errs = zeros(ln,4); % column 1 = sample size, 2 = NMAD, 3 = out10, 4 = mse
errs(:,1) = nsamp'

ulayers = [10,10] % train with 2 hidden layers, 10 hidden units each

n = 1;
for i=1:ln
    nm1 = n;
    n = nsamp(i)
    if n>10000
        nm1=1;
    end
    datn = dat(nm1:nm1+n-1,:);
    length(datn)
    zn = specz(nm1:nm1+n-1);

    [net, res, mse, test_res] = do_fitnet(ulayers, datn, zn, test_dat);

    [NMAD, out10] = calc_zerrors(test_specz, test_res)
    errs(i,2) = NMAD;
    errs(i,3) = out10;
    errs(i,4) = mse;
end
