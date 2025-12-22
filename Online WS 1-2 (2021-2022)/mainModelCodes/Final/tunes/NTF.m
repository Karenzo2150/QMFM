function [tunes, pln, m] = NTF(opts, m)

% Load observed data
tmp = codes.loadResult(opts, "data");
dbObs = tmp.dbObs;

rngFcast = opts.forecast.range;

tunes = struct;
pln   = Plan(m, rngFcast);

% External variables

pln = exogenize(pln,  rngFcast, 'dl_cpistar');
pln = endogenize(pln, rngFcast, 'shock_dl_cpistar');

pln = exogenize(pln,  rngFcast, 'l_ystar_gap');
pln = endogenize(pln, rngFcast, 'shock_l_ystar_gap');

pln = exogenize(pln,  rngFcast, 'istar');
pln = endogenize(pln, rngFcast, 'shock_istar');

pln = exogenize(pln,  rngFcast, 'rstar_tnd');
pln = endogenize(pln, rngFcast, 'shock_rstar_tnd');

pln = exogenize(pln,  rngFcast, 'l_rp_foodstar_gap');
pln = endogenize(pln, rngFcast, 'shock_l_rp_foodstar_gap');

pln = exogenize(pln,  rngFcast, 'l_foodstar');
pln = endogenize(pln, rngFcast, 'shock_dl_rp_foodstar_tnd');

pln = exogenize(pln,  rngFcast, 'l_rp_enerstar_gap');
pln = endogenize(pln, rngFcast, 'shock_l_rp_enerstar_gap');

pln = exogenize(pln,  rngFcast, 'l_enerstar');
pln = endogenize(pln, rngFcast, 'shock_dl_rp_enerstar_tnd');

tunes.dl_cpistar        = 4*diff(dbObs.obs_l_cpistar);
tunes.l_ystar_gap       = dbObs.obs_l_ystar_gap;
tunes.istar             = dbObs.obs_istar;
tunes.rstar_tnd         = dbObs.obs_rstar_tnd;
tunes.l_rp_foodstar_gap = dbObs.obs_l_rp_foodstar_gap;
tunes.l_foodstar        = dbObs.obs_l_foodstar;
tunes.l_rp_enerstar_gap = dbObs.obs_l_rp_enerstar_gap;
tunes.l_enerstar        = dbObs.obs_l_enerstar;

% NTF

rngExog = qq(2021, 1);
pln = exogenize(pln,  rngExog, 'dl_cpi_core');
pln = endogenize(pln, rngExog, 'shock_dl_cpi_core');
tunes.dl_cpi_core = Series(rngExog, 0.77);

end