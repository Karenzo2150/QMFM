function [tunes, pln, m] = Baseline(opts, m)

% -------- Load data --------

tmp = codes.utils.loadResult(opts, "data");

dbObs       = tmp.dbObs;
dbObsTrans  = tmp.dbObsTrans;
dbOrig      = tmp.db;

% -------- Reset model parameters --------

% % Model parameters tunes for the forecast (tuned for future to keep the
% % historical trend intact)
% % interest policy rule response to output gap

%% Fiscal assumptions in long-term  (beyond IMF program, should be recalibrated after a new program negociation

m.ss_grev_y_str =  24; % put MTRS target of 23% (before 21%, hist ss was 17-18%)
m.ss_oexp_y_str =  6-0.5; % 1 pps down from historical s-state
m.ss_gdem_y_str =  26; % 0.5 pps down from historical s-state
m.ss_bor_str    =  6-1; % 1 pps down from historical level of borrowing 
m.ss_grants_y   =  5-2.5; % 2.5 pps down form historical level of grants
m.v4            =  0.97; % 0.02 pps down from historical persistence was 0.99

%% -------- Predefine tunes and the simulation plan --------

tunes = struct;

tuneNames = [
  "l_cpistar"
  "l_ystar_gap"
  "istar"
  "rstar_tnd"
  "l_foodstar"
  "l_enerstar"
  "l_rp_foodstar_gap"
  "l_rp_enerstar_gap"
  "dl_cpi"
  "d4l_cpi"
  "dl_cpi_core"
  "d4l_cpi_core"
  "dl_cpi_food"
  "d4l_cpi_food"
  "dl_cpi_ener"
  "d4l_cpi_ener"
  "i"
  "d4l_y"
  "shock_l_inv_gap"
  "shock_l_exp_gap"
  "shock_l_imp_gap"
  "l_s"
  "dl_s"
  "l_md"
  "d4l_gdem"
  "gdem_y"
  "grev_y"
  "def_y"
  "grev_y_discr"
  "oexp_y"
  "shock_oexp_y_discr"
  ];

for n = tuneNames(:)'
  tunes.(n) = Series();
end

rngFcast = opts.forecast.range;

%pln = Plan.forModel(m, rngFcast, "anticipate",true);
pln = Plan.forModel(m, rngFcast);

% -------- Set tune values and the simulation plan --------

% Do not create Series here! Only assign values to existing series, created in loop above.

%% ----- External variables -----

pln = exogenize(pln,  rngFcast, 'l_cpistar');
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

tunes.l_cpistar(rngFcast)         = dbObs.obs_l_cpistar(rngFcast);
tunes.l_ystar_gap(rngFcast)       = dbObs.obs_l_ystar_gap(rngFcast);
tunes.istar(rngFcast)             = dbObs.obs_istar(rngFcast);
tunes.rstar_tnd(rngFcast)         = dbObs.obs_rstar_tnd(rngFcast);
tunes.l_rp_foodstar_gap(rngFcast) = dbObs.obs_l_rp_foodstar_gap(rngFcast);
tunes.l_foodstar(rngFcast)        = dbObs.obs_l_foodstar(rngFcast);
tunes.l_rp_enerstar_gap(rngFcast) = dbObs.obs_l_rp_enerstar_gap(rngFcast);
tunes.l_enerstar(rngFcast)        = dbObs.obs_l_enerstar(rngFcast);

% ----- NTFs ------
%% CPI core, food, energy q-o-q (dl) annualized growth hard-tuned using 2026Q2 prel. data

%1a. CORE hard-tune 2026Q2 prel.data (note: these are s.a., see readData)
rngExog = qq(2026, 2);
pln = exogenize(pln,  rngExog, 'dl_cpi');
pln = endogenize(pln, rngExog, 'shock_dl_cpi_core');
tunes.dl_cpi(rngExog) = dbObsTrans.obs_dl_cpi(rngExog);

% 1b. CPI_food hard-tune with 2026Q2 prel.data
rngExog = qq(2026, 2);
pln = exogenize(pln,  rngExog, 'dl_cpi_food');
pln = endogenize(pln, rngExog, 'shock_dl_cpi_food');
tunes.dl_cpi_food(rngExog) = dbObsTrans.obs_dl_cpi_food(rngExog);

%1c. CPI_ener hard-tune with 2026Q2 prel. data 
rngExog = qq(2026, 2);
pln = exogenize(pln,  rngExog, 'dl_cpi_ener');
pln = endogenize(pln, rngExog, 'shock_dl_cpi_ener');
tunes.dl_cpi_ener(rngExog) = dbObsTrans.obs_dl_cpi_ener(rngExog);

% IB rate hard-tuned with full/partial data (average last 2-3 mos thru 2026Q2), judgment for Q3?
% margin of IB rate (CBR's intermediate target) over CBR was 0.5-0.7%, dropped recently to 0.3%
% IB rate for 2026Q1 hard-tuned with data; next Q judgement: assumed CBR unchanged fr May 2026:8.25+IB margin 
% rngExog = qq(2026, 1);
% pln = exogenize(pln,  rngExog, 'i');
% pln = endogenize(pln, rngExog, 'shock_i');
% tunes.i(rngExog) = dbObs.obs_i(rngExog);

rngExog = qq(2026, 2);
pln = exogenize(pln,  rngExog, 'i');
pln = endogenize(pln, rngExog, 'shock_i');
tunes.i(rngExog) = 100 * log(1 + (7.9+0.3)/100); % we have data for CBR, but not IB rate

%% GDP & demand: recall we run ext.filter 1-2 Q beyond data (2026Q1) with hist tunes y-on-y GDP growth fr Nowcast
% we 'read' demand shocks for those 1-2Q, then set back filter-range to end datarange; soft-tune demand shocks 1-2Q ahead
rngExog = qq(2026, 2) : qq(2026, 2);
pln = exogenize(pln,  rngExog, 'd4l_y');
pln = endogenize(pln, rngExog, 'shock_l_cons_gap');
tunes.d4l_y(rngExog) = 100 * log(1 + 8.0/100); % tune with nowcast in June 2026 for Q2

% soft-tune other-than-cons FD shocks, 'read' from filter results w.historical tuning of GDP (Nowcast)
% filter distributes shocks among other FD, so that movement in GDP not only attributed to cons shock
% rngExog = qq(2026, 2) : qq(2026, 2);
% tunes.shock_l_inv_gap(rngExog) = [ 0.0]; % need to be read from extended filter results
% tunes.shock_l_exp_gap(rngExog) = [ 0.0]; % 
% tunes.shock_l_imp_gap(rngExog) = [ 0.0]; % 

% soft-tune private investment shock, to reflect Bugesera (only gov netLending-oexp) sum 5% GDP 2025/26-2027/28
% but effect spread over 12Q, markup 1/(investment/GDP)=1/(0.15)=6,take about half
rngExog = qq(2026, 2) : qq(2028, 2);
tunes.shock_l_inv_gap(rngExog) = [14.0, 14.0, 12.4, 9.2, 7.0, 7.6, 7.6, 7.6, 7.6];
%tunes.shock_l_inv_gap(rngExog) = [7.0, 7.0, 6.2, 4.6, 3.5, 3.8, 3.8, 3.8, 3.8];
%% Exchange rate: hard-tune with data for 2026Q1 (if forecast would start Q1)
% rngExog = qq(2026, 1);
% pln = exogenize(pln,  rngExog, 'l_s');
% pln = endogenize(pln, rngExog, 'shock_l_s');
% tunes.l_s(rngExog) = dbObs.obs_l_s(rngExog); %dbObs.obs_l_s(rngExog);

% hard-tune ER (l_s) or 2026Q2 using ER estimate for end-June as of today
rngExog = qq(2026, 2);
pln = exogenize(pln,  rngExog, 'l_s');
pln = endogenize(pln, rngExog, 'shock_l_s');
tunes.l_s(rngExog) = 100*log(1466); % if level is tuned, with guess where ER will be at end-Q2

% hard-tune ER (l_s) or QoQ growth (dl_s) for 2026Q3-4 using NBR=IMF program ER (April'26): 5% end'26/end'25
% extrapolate path realized 2026Q1-2 which was 1% depr, so 4% remaining for Q3-4
rngExog = qq(2026, 3): qq(2026, 4);
pln = exogenize(pln,  rngExog, 'dl_s');
pln = endogenize(pln, rngExog, 'shock_l_s');
tunes.dl_s(rngExog) = 100 * log(1 + 0.04); % tune dl_s (annualized!) nb we had to add tune_dl_s to minecofin.model

%% Fiscal variables (follows FY), esp. deficit (GFS1986), govt demand G&S, revenue (so: other expend implicit)
% forecast: fr Treasury plan but NOT YET; for now: using fiscal targets PCI-program 2025/26 a.f.(May25 review)
% in July-Oct 2023 rounds, we didnot yet tune deficit forward assuming renegotiation of PCI

%% hard-tune deficit from PCI program April 2026 (NB in addition, we could hard-tune gdem)
% deficits: 2025/26: 8.3%; 2026/27: 6.7%; 2027/28: 6.0%, 2028/29: 4.7% of GDP plus semester breakdown FISCAL
rngExog = qq(2026, 2) : qq(2028, 4);
pln = exogenize(pln,  rngExog, 'def_y');
pln = endogenize(pln, rngExog, 'shock_gdem_y_discr');
tunes.def_y(rngExog) = [8.4, 6.5, 6.3, 7.1, 6.8, 6.2, 6.0, 5.9, 5.8, 4.4, 4.3];

%% hard tune govt other exp from FISCAL 2025/26-2028/29,for Q w. airport netLending, equal distr over Q
rngExog = qq(2026, 2) : qq(2028, 4);
pln = exogenize(pln,  rngExog, 'oexp_y');
pln = endogenize(pln, rngExog, 'shock_oexp_y_discr');
tunes.oexp_y(rngExog) = [7.8, 5.8, 5.8, 5.7, 5.7, 5.4, 5.4, 4.4, 4.4, 3.4, 3.4];
%% we could hard-tune discretionary rev/GDP reflecting below-trend non-tax revenue, lag revenue base to inflation, exemptions (for 2023)
% rngExog = qq(2026, 2) : qq(2028, 4);
% pln = exogenize(pln,  rngExog, 'grev_y_discr');
% pln = endogenize(pln, rngExog, 'shock_grev_y_discr');
% tunes.grev_y_discr(rngExog) = [-1.0,-1.0,-0.9,-0.9,-0.8,-0.7,-0.6,-0.5]; % grev below trend both years NOT USED

%% hard tune govt revenue (tax+nontax) from PCI program each Q 2025/26-2028/29, smoothen increase over all Q
% PCI revenue: 2025/26: 17.1%; 2026/27: 17.6%; 2027/28: 17.9%, 2028/29: 18.2% of GDP
rngExog = qq(2026, 2) : qq(2028, 4);
pln = exogenize(pln,  rngExog, 'grev_y');
pln = endogenize(pln, rngExog, 'shock_grev_y_discr');
tunes.grev_y(rngExog) = [18.2, 17.3, 17.3, 17.7, 18.1, 17.7, 17.8, 17.9, 18.1, 17.9, 18.1];
%
% Optional: tune Govt demand (gdem/gdp) using PCI program with discr govt demand shock endogenous
% rngExog = qq(2026, 2): qq(2028, 4);
% pln = exogenize(pln,  rngExog, 'gdem_y');
% pln = endogenize(pln, rngExog, 'shock_gdem_y_discr');
% tunes.gdem_y(rngExog) = [19.6,17.9, 17.9,19.0,19.0, 18.5, 18.5, 19.5, 19.5, 18.9, 18.9]);%calc resiudally from def, rev, oexp

end



