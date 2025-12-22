function readData

opts = mainSettings();

codes.writeMessage("readData: reading data files ...");

% Read foreign real interest rate trend fro mthe GPM database

tmp = load("data/gpm202102.mat");
GPM = tmp.db;

dbObs.obs_rstar_tnd   = Series(GPM.RR_BAR_US);

% Read the Excel database

t = readtable("data/Rwametric.xlsm", ...
  "Sheet",    "Quarterly data", ...
  "TextType", "string");

% WEO data

% External demand
ind                   = t{:,1} == "ystar";
values                = t{ind, 3:end}';
ystar                 = Series(qq(1995, 1), values);
dl_ystar              = log(1 + ystar);
l_ystar               = cumsum(dl_ystar/4);
l_ystar_gap           = hpf2(l_ystar);
dbObs.obs_l_ystar_gap = 100*l_ystar_gap;

% Foreign prices CPI
ind                 = t{:,1} == "cpistar";
dl_cpistar          = Series(qq(1995,1), log(1 + t{ind, 3:end})');
dbObs.obs_l_cpistar = 100*cumsum(dl_cpistar/4);

% Foreign oil prices
ind                   = t{:,1} == "enerstar";
dl_enerstar           = Series(qq(1995,1), log(1 + t{ind, 3:end})');
dbObs.obs_l_enerstar  = 100*cumsum(dl_enerstar/4);

% Foreign relative oil price gap
dbObs.obs_l_rp_enerstar_gap = hpf2(dbObs.obs_l_enerstar - dbObs.obs_l_cpistar);

% Foreign food prices
ind                   = t{:,1} == "foodstar";
dbObs.obs_l_foodstar  = Series(qq(1995,1), 100*log(t{ind, 3:end})');

% Foreign relative food price gap
dbObs.obs_l_rp_foodstar_gap = hpf2(dbObs.obs_l_foodstar - dbObs.obs_l_cpistar);

% Foreign nominal interest rate
ind = t{:,1} == "istar";
dbObs.obs_istar = Series(qq(1995, 1), 100*log(1 + t{ind, 3:end}/100)');

% Export price
ind                 = t{:,1} == "pexpstar";
dbAux.dl_pexpstar   = Series(qq(1995,1), 100*log(1 + t{ind, 3:end})');

% Import price
ind                 = t{:,1} == "pimpstar";
dbAux.dl_pimpstar   = Series(qq(1995,1), 100*log(1 + t{ind, 3:end})');

% Domestic data

% Exchange rate
ind = t{:,1} == "s";
s = Series(qq(1995, 1), t{ind, 3:end}');
dbObs.obs_l_s = 100*log(s);

% GDP, real

ind = t{:,1} == "y";
y   = Series(qq(1995, 1), t{ind, 3:end}');

ind   = t{:,1} == "cons";
cons  = Series(qq(1995, 1), t{ind, 3:end}');

ind   = t{:,1} == "inv";
inv   = Series(qq(1995, 1), t{ind, 3:end}');

ind     = t{:,1} == "gcons";
gcons   = Series(qq(1995, 1), t{ind, 3:end}');

ind   = t{:,1} == "exp";
exp   = Series(qq(1995, 1), t{ind, 3:end}');

ind   = t{:,1} == "imp";
imp   = Series(qq(1995, 1), t{ind, 3:end}');

% GDP, nominal

ind     = t{:,1} == "ny";
ny      = Series(qq(1995, 1), t{ind, 3:end}');

ind     = t{:,1} == "ncons";
ncons   = Series(qq(1995, 1), t{ind, 3:end}');

ind     = t{:,1} == "ninv";
ninv    = Series(qq(1995, 1), t{ind, 3:end}');

ind     = t{:,1} == "ngcons";
ngcons  = Series(qq(1995, 1), t{ind, 3:end}');

ind     = t{:,1} == "nexp";
nexp    = Series(qq(1995, 1), t{ind, 3:end}');

ind     = t{:,1} == "nimp";
nimp    = Series(qq(1995, 1), t{ind, 3:end}');

% Government investment, adjust inv so that it is only private

ind   = t{:,1} == "ginv";
nginv  = Series(qq(1995, 1), t{ind, 3:end}');
nginv  = 0.8 * nginv;

pinv  = ninv / inv;   % Calculate overall investment deflator from NA
ninv  = ninv - nginv; % Adjust nominal investment (remove government investment)
inv   = ninv / pinv;  % Calculate real private investment using the overall investment deflator
ginv  = nginv / pinv;

% ngexp = ngcons + nginv;
% pgcons = ngcons / gcons;

dbObs.obs_l_y       = x12(100*log(y));
dbObs.obs_l_cons    = x12(100*log(cons));
dbObs.obs_l_inv     = x12(100*log(inv));
dbObs.obs_l_gcons   = x12(100*log(gcons + ginv));
dbObs.obs_l_exp     = x12(100*log(exp));
dbObs.obs_l_imp     = x12(100*log(imp));

dbAux.nexp    = nexp;
dbAux.nimp    = nimp;
dbAux.ny      = ny;
dbAux.tb_rat  = 100*(nexp - nimp) / ny;

% CPI
ind   = t{:,1} == "cpi";
l_cpi = x12(Series(qq(1995,2), 100*log(t{ind, 4:end})'));

% CPI food
ind                   = t{:,1} == "cpi_food";
dbObs.obs_l_cpi_food  = x12(Series(qq(1995,2), 100*log(t{ind, 4:end})'));

% CPI energy
ind                   = t{:,1} == "cpi_ener";
dbObs.obs_l_cpi_ener  = x12(Series(qq(1995,2), 100*log(t{ind, 4:end})'));

% % CPI core
% ind                   = t{:,1} == "cpi_core";
% l_cpi_core  = x12(Series(qq(1995,2), 100*log(t{ind, 4:end})'));

w_core = 7747/10000;
w_food = 1577/10000;
w_ener =  676/10000;

dbObs.obs_l_cpi_core  = (l_cpi - w_food * dbObs.obs_l_cpi_food - w_ener * dbObs.obs_l_cpi_ener) / w_core;

% Nominal interest rate
ind         = t{:,1} == "i";
dbObs.obs_i = Series(qq(1995, 1), 100*log(1 + t{ind, 3:end}/100)');

% Deficit ratio
ind   = t{:,1} == "grev";
grev  = Series(qq(1995, 1), t{ind, 3:end}');
ind   = t{:,1} == "gexp";
gexp  = Series(qq(1995, 1), t{ind, 3:end}');

dbObs.obs_def = x12(100*(gexp - grev)/ny);

% Money stock
ind = t{:,1} == "md";
dbObs.obs_l_md = x12(Series(qq(1995, 1), 100*log(t{ind, 3:end})'));

% Interets rate premium
ind = t{:,1} == "i_lend";
i_lend = Series(qq(1995, 1), 100*log(1 + t{ind, 3:end}/100)');
dbObs.obs_prem_d = i_lend - dbObs.obs_i;

% Government debt

ind = t{:,1} == "ndebt_fcy";
ndebt_fcy = Series(qq(1995, 1), t{ind, 3:end}');
ndebt_fcy = ndebt_fcy * s / 1000;

ind = t{:,1} == "ndebt_lcy";
ndebt_lcy = Series(qq(1995, 1), t{ind, 3:end}');

ind = t{:,1} == "nintp_fcy";
nintp_fcy = Series(qq(1995, 1), t{ind, 3:end}');

nintp_fcy_smooth = convert(convert(nintp_fcy,'a','method', @mean), 'q');

ind = t{:,1} == "nintp_lcy";
nintp_lcy = Series(qq(1995, 1), t{ind, 3:end}');

dbAux.intp_fcy = 100 * nintp_fcy_smooth / ny;
dbAux.intp_lcy = 100 * nintp_lcy / ny;

dbAux.debt_fcy = 100 * ndebt_fcy / ny;
dbAux.debt_lcy = 100 * ndebt_lcy / ny;

dbAux.i_debt_fcy = 400 * nintp_fcy / ndebt_fcy{-1};
dbAux.i_debt_lcy = 400 * nintp_lcy / ndebt_lcy{-1};

% BOP and monetary stocks/flows

% Private flows

ind = t{:,1} == "dBP1";
dBP1 = Series(qq(1995, 1), t{ind, 3:end}');

ind = t{:,1} == "dBP2";
dBP2 = Series(qq(1995, 1), t{ind, 3:end}');

dbAux.dBP = dBP1 + dBP2;

% Domestic non-bank financing

ind = t{:,1} == "dBD";
dbAux.dBD = Series(qq(1995, 1), t{ind, 3:end}');

% Foreign governemnt financing

dbAux.dBF = diff(ndebt_fcy / s);

% Grants

ind = t{:,1} == "nfg";
dbAux.NFG = Series(qq(1995, 1), t{ind, 3:end}') / s;

% Transform all variables

dbObsTrans = dbObs;

dbObsTrans.obs_l_z    = dbObsTrans.obs_l_s + dbObsTrans.obs_l_cpistar - dbObsTrans.obs_l_cpi_core;

dbObsTrans.obs_l_cpi  = ...
  + w_core * dbObsTrans.obs_l_cpi_core ...
  + w_food * dbObsTrans.obs_l_cpi_food ...
  + w_ener * dbObsTrans.obs_l_cpi_ener;

dbObsTrans.obs_l_rmd  = dbObsTrans.obs_l_md - dbObsTrans.obs_l_cpi;

varNames = [
  "cpi_core"
  "cpi_food"
  "cpi_ener"
  ];

for v = varNames(:)'
  dbObsTrans.("obs_l_rp_" + v)  = dbObsTrans.("obs_l_" + v) - dbObsTrans.obs_l_cpi;
end

varNames = [
  "foodstar"
  "enerstar"
  ];

for v = varNames(:)'
  dbObsTrans.("obs_l_rp_" + v)  = dbObsTrans.("obs_l_" + v) - dbObsTrans.obs_l_cpistar;
end

varNames = [
  "cpistar"
  "foodstar"
  "enerstar"
  "rp_foodstar"
  "rp_enerstar"
  "s"
  "z"
  "y"
  "cons"
  "inv"
  "gcons"
  "exp"
  "imp"
  "cpi"
  "cpi_core"
  "cpi_food"
  "cpi_ener"
  "rp_cpi_core"
  "rp_cpi_food"
  "rp_cpi_ener"
  "md"
  "rmd"
  ];

for v = varNames(:)'
  dbObsTrans.("obs_dl_" + v)  = 4*diff(dbObsTrans.("obs_l_" + v));
  dbObsTrans.("obs_d4l_" + v) = diff(dbObsTrans.("obs_l_" + v), -4);
end

codes.writeMessage("readData: saving results ...");

fileName = fullfile(opts.mainDir, "results", "data.mat");
save(fileName, "dbObs", "dbObsTrans", "dbAux");

codes.writeMessage("readData: done");

end