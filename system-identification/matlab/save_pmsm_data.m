
load pmsm_sysid_dta.mat
uident = uy.Data(:,1);
yident = uy.Data(:,2);
clear uy
load pmsm_sysid_valid_dta.mat
uval = uy.Data(:,1);
yval = uy.Data(:,2);
clear uy
load pmsm_step_dta.mat
ustep = uy.Data(:,1);
ystep = uy.Data(:,2);
save pmsm_data.mat ustep ystep uident yident uval yval