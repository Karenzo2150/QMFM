function dbObs = Historical(dbObs)  % 

% Sept 10'24: tuned INV gap (NISR INV data ignored 2023Q3-2024Q2) as shock huge (+60%)
% rngTune = qq(2024, 1);
% dbObs.tune_l_inv_gap(rngTune) = 25;
%% Evariste alt. scenario (INV, E-M suppressed for last 2Q and 4Q resp., requires tuning E
% rngTune = qq(2024, 1): qq(2024, 1);
% dbObs.tune_l_exp_gap(rngTune) = [-10];

%% --------Set tune values for normal filter (hist data) or extended filter (prel./nowcast)-----
% do not create Series here! Only assign values to existing series, created in loop above

% avoid that trend bends down before Covid, so we set up outputgap low
% rngTune = qq(2019, 4);
% dbObs.tune_l_y_gap(rngTune) = 1;

% the outgap is set low to allow GDP level move close to trend to
% incoporate the assumption that COVID-19 outbreak has had a potential
% effect in GDP growth
% rngTune = qq(2022, 4);
% dbObs.tune_l_y_gap(rngTune) = -2;

% to allow somewhat significant effect of fiscal policies (gdem gap) on output gap in COVID, we allow the govt demand trend/structual bend  down during 2019-2023, 
% so we set gdem_y trend slightly lower y 2% points of GDP: bend down structural govt demand 2017-2023
% load results\mat\filter.mat
% dbObs.tune_gdem_y_str = dbFilt.mean.gdem_y_str;
%rngTune = qq(2017, 1): qq(2023,3);
%dbObs.tune_gdem_y_str(rngTune) = dbObs.tune_gdem_y_str-2;

%% easier: set structural level of govt demand
% rngTune = qq(2017, 1): qq(2024, 2);
% dbObs.tune_gdem_y_str(rngTune) = 24.5;

%% GDP extended filter for Nowcast Q 2026Q2, alternatively tune most recent Q with prel. NA
% filtration range set to a few Q beyond data (here: 2025Q2-3 with hist tunes for y-on-y GDP growth from Nowcast(no s.a. needed)
% filter distributes shocks among other demands, so movement in GDP not only attributed to cons shock (cf Baseline tune)
% rngTune = qq(2026, 2) : qq(2026, 2);
% dbObs.tune_d4l_y (rngTune) = 100 * log(1 + [8.0]/100); % Nowcast June'26
% % rngTune = qq(2026, 3) : qq(2026, 3);
% dbObs.tune_d4l_y (rngTune) = 100 * log(1 + [..]/100); % Nowcast June'25

%% CPI option to soft/hard-tune CPIs Near-Term based on NBR-forecast/judgement, expected shocks
% CPI_core can be soft-tuned to match any NBR or prel. CPI forecast for later Q--not used now
% rngTune = qq(2026, 2) : qq(2026, 2);
% dbObs.tune_shock_dl_cpi_core(rngTune) = 0;
% 
% CPI can be hard-tuned 2026Q2 with prel. data, but not if filter run thru 2026Q2
% rngTune = qq(2026, 2): qq(2026, 2);
% dbObs.tune_dl_cpi(rngTune) = dbObsTrans.obs_dl_cpi(rngExog);

% CPI_food hard-tune with 2026Q2 prel.data, but not if filter run thru 2026Q
% rngTune = qq(2026, 2): qq(2026, 2);
% dbObs.tune_dl_cpi_food(rngTune) = dbObsTrans.obs_dl_cpi_food(rngExog);

% CPI_ener could soft-tune 2026Q2 for pump price effect of any excise tax change--not used now
% (NB 0.2 is share fuels in energy) 
% rngTune = qq(2026, 2) : qq(2026, 2);
% dbObs.tune_shock_dl_cpi_ener(rngTune) = 0;

% CPI_energy hard-tune with 2026Q2 prel. data but not if filter run thru 2026Qa
% rngTune= qq(2026, 2): qq(2026, 2);
% dbObs.tune_dl_cpi_ener(rngTune) = dbObsTrans.obs_dl_cpi_ener(rngExog);
 
% CPI headline could be hard-tuned with 2026Q2 forecast or judgment
% we can only tune 3 of 4 CPIs (NB these are s.a.,see readData)
% rngTune = qq(2026, 2);
% dbObs.tune_l_cpi(rngTune) = [....];

%% ER hard-tuned for extended filter 2025Q4 if tuned in BL,eg % annualized =PCIeop target
% with realization ER thru 2026Q2 at x% (Q-on-Q), the annualized remainder is x%
% note 2026Q1 is already data, so entered as dbObs.obs.l_s in readData
% rngTune = qq(2026, 1); %for Historical, one wouldn't tune to set equal to data!
% dbObs.tune_l_s(rngTune) = dbObs.obs_l_s; % tune dl_s, added in model tune_ declaration

% rngTune = qq(2026, 2) : qq(2026, 2); % can tune to guess for end-June '26, but we put guess in data
% dbObs.tune_l_s(rngTune) = 100* log(1466);

% interest IB rate hard-tune for extended filter thru 2026Q2 if also tuned in BL
% (e.g. no change CBR, so IB 0.3% above CBR=7.9 av.in Q2, 8.25 May'26)
% rngTune = qq(2026, 2) : qq(2026, 2);
% dbObs.obs_i(rngTune) = 100 * log(1 + 8.2/100);

%% fiscal (ECF deficit, govt revenue) hardtuned for extended filter thru 2026Q2 
% govt revenue (discretionary revenue), alternative NOT used
% rngTune = qq(2025,3) : qq(2025,3);
% dbObs.tune_grev_y_discr(rngTune) = [0];

% govt revenue tuned for 2026Q2: 18.2% of GDP, 2026Q3: 17.3% 
% rngTune = qq(2026, 1) : qq(2026, 2);
% dbObs.tune_grev_y(rngTune) = 18.2;

% deficit GFS1986 tuned for 2026Q2: 8.4% of GDP, 2026Q3: 6.5% 
% rngTune = qq(2026, 2) : qq(2026, 2);
% dbObs.tune_def_y(rngTune) = 8.4;
%% % soft-tune private investment shock, to reflect Bugesera (gov netLending=oexp & Qatar equity) in 2025/26-2027/28
% effect spread over 12Q, markup 1/(investment/GDP)=1/0.15=6,take about half to tune 
%  inv_gap shock for extended filter; must declare  tune_shock_l_inv_gap in model
% rngTune = qq(2026, 2);
% dbObs.tune_shock_l_inv_gap(rngTune) = 14.0;
end
