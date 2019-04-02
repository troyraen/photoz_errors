cd /home/tjr63/Documents/photoz_errors/matlab/
columns = {'redshift','tu','tg','tr','ti','tz','ty', 'u10','uerr10','g10','gerr10','r10','rerr10','i10','ierr10','z10','zerr10','y10','yerr10'};
%%
% training data
load /home/tjr63/Documents/photoz_errors/data/CGsample.mtxt
cgs = CGsample(:,3:end); % strip df index and galaxy id
dat = cgs(:,2:end); % everything but redshift
specz = cgs(:,1); % true redshift
%%
% testing data
load /home/tjr63/Documents/photoz_errors/data/CGsample4.mtxt
test_cgs = CGsample4(1:10000,3:end); % strip df index and galaxy id. first 10000 rows
test_dat = test_cgs(:,2:end); % everything but redshift
test_specz = test_cgs(:,1); % true redshift
%% Random Forest
%%

%%
mdl = fitrensemble(dat,specz);
res = predict(mdl, dat);

% [NMAD, out10] = calc_zerrors(test_specz, test_res)
[NMAD, out10] = calc_zerrors(specz, res)
mse = resubLoss(mdl)
%%
nsamp=[1000, 2500, 5000, 10000, 15000, 20000];
nsamp=[10000];
ln = length(nsamp);
errs = zeros(3,ln); % row 1 = NMAD, 2 = out10, 3 = mse

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
    
    [mdl, res, mse, test_res] = do_fitrensemble(datn, zn, test_dat);
    
    [NMAD, out10] = calc_zerrors(test_specz, test_res)
    errs(1,i) = NMAD;
    errs(2,i) = out10;
    errs(3,i) = mse;
end

%%
semilogx(nsamp,errs(1,:))
semilogx(nsamp,errs(2,:))
semilogx(nsamp,errs(3,:))
%%

%% Neural Net
%%
ulayers = [1] % train with 1 hidden layer, 1 hidden units
[net, res, mse1] = do_fitnet(ulayers, dat, specz);
mse1
%%

ulayers = [5] % train with 1 hidden layer, 5 hidden units
[net, res, mse5] = do_fitnet(ulayers, dat, specz);
mse5
%%
ulayers = [10,10] % train with 2 hidden layers, 10 hidden units each
[net, res, mse10] = do_fitnet(ulayers, dat, specz);
mse10
%%
ulayers = [15,15,15]
[net, res, mse15] = do_fitnet(ulayers, dat, specz);
mse15
%%
ulayers = [10,10] % train with 2 hidden layers, 10 hidden units each

nsamp=[1000, 2500, 5000, 10000];%, 15000, 20000];
ln = length(nsamp);
errs = zeros(3,ln); % row 1 = NMAD, 2 = out10, 3 = mse

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
    
    [net, res, mse10, test_res] = do_fitnet(ulayers, datn, zn, test_dat);
    
    [NMAD, out10] = calc_zerrors(test_specz, test_res)
    errs(1,i) = NMAD;
    errs(2,i) = out10;
    errs(3,i) = mse10;
end


%%
semilogx(nsamp,errs(1,:))
semilogx(nsamp,errs(2,:))
%%



%%