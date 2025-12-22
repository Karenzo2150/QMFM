function dbObs = Historical(dbObs)  % 

rngTune = qq(2024, 1): qq(2024, 2);
dbObs.tune_l_exp_gap(rngTune) = [-10, -10]; %-10;

% --------Set tune values for normal filter (hist data) or extended filter (prel./nowcast)-----
% do not create Series here! Only assign values to existing series, created in loop above

% avoid that trend bends down before Covid, so we set outputgap low
rngTune = qq(2019, 4);
dbObs.tune_l_y_gap(rngTune) = 1;

% to allow somewhat significant effect of fiscal policies (gdem gap) on output gap in COVID, we allow the govt demand trend/structual bend  down during 2019-2023, 
% so we set gdem_y trend slightly lower y 2% points of GDP: bend down structural govt demand 2017-2023
% load results\mat\filter.mat
% dbObs.tune_gdem_y_str = dbFilt.mean.gdem_y_str;
%rngTune = qq(2017, 1): qq(2023,3);
%dbObs.tune_gdem_y_str(rngTune) = dbObs.tune_gdem_y_str-2;

%% easier: set structural level of govt demand
rngTune = qq(2017, 1): qq(2024, 2);
dbObs.tune_gdem_y_str(rngTune) = 24.5;

%% GDP extended filter for 4 Nowcast Q thru 2024Q4, possibly tune most recent Q with prel. NA
% filtration range set to a few Q beyond data (here: 2024Q2-2024Q3) with hist tunes for y-on-y GDP growth from Nowcast(no s.a. needed)
% filter distributes shocks among other FD, so movement in GDP not only attributed to cons shock (cf Baseline tune)
rngTune = qq(2024, 3) : qq(2024, 4);
dbObs.tune_d4l_y (rngTune) = 100 * log(1 + [7.9, 5.1]/100); % Nowcast Aug'24

%% CPI option to hard- or soft-tune CPIs based on NBR estimate or judgement and expected shocks
% 1a. CORE hard-tune 2024Q2 data (note: these are s.a., see readData)
%rngTune = qq(2024, 3) : qq(2024, 3);
%dbObs.tune_l_cpi_core(rngTune) = dbObs.obs_l_cpi_core(rngTune);

% Tuning CPI as data; for Q3 as average 3 Mos ( sept as aver of Obs July and Aug)
%rngTune =qq(2024, 3) : qq(2024, 3);
%dbObs.tune.l_cpi(rngExog) = dbObs.obs_l_cpi(rngTune);

% 1b. CPI_food hard-tune with 2024Q2 data
%rngTune = qq(2024, 3) : qq(2024, 3);
%dbObs.tune_l_cpi_food(rngTune) = dbObs.obs_l_cpi_food(rngTune);

% 1c. CPI_ener hard-tune with 2024Q2 data 
%rngTune = qq(2024, 3);
%dbObs.tune_l_cpi_ener(rngTune) = dbObs.obs_l_cpi_ener(rngTune);

%% exchange rate 2024Q3 for extended filter if tuned in BL forecast, eg with 11.8% annualized =PCI eop "target"
%% or extrapolate ER path so far in 2024, ie 8% annualized lower than PCI target
rngTune = qq(2024, 3);
dbObs.tune_l_s(rngTune) = dbObs.obs_l_s(rngTune);
%dbObs.tune_dl_s(rngTune) = 100 * log(1 + 0.08); % tune dl_s, add in model tune_ declaration

%tuned eop ER as data as eop Aug ER fr BNR web factoring in the % ann.depr in 2024Q3 assumed 8%
rngTune = qq(2024, 4);
dbObs.tune_dl_s(rngTune) = 100*(log(1 + 0.09));

%% interest IB rate hard-tune 2024Q3 for extended filter as also tuned in BL forecast
%% (no change CBR, so IB 0.7% above av. CBR=6.8% 2024Q3)
rngTune = qq(2024, 3);
dbObs.obs_i(rngTune) = 100 * log(1 + 7.5/100);

%% fiscal (deficit and govt revenue) hardtuned for extendedfilter thru 2024Q3
% hard-tune deficit next years from PCI program 3d review May'24 (in addition, we could hard-tune gdem)
rngTune = qq(2024, 3) : qq(2024, 4);
dbObs.tune_def_y(rngTune) = [8.5, 8.5];

% govt revenue from PCI program in 2024/25 18.4% GDP assuming backloading for Q distr,FISCAL team to provide sem 
rngTune = qq(2024, 3) : qq(2024, 4);
dbObs.tune_grev_y(rngTune) = [18.2, 18.4];

% deficit GFS1986 tuned for 2024Q3-2024Q3 using PCI target 8.9% for 2024/25, but lower Q3 (not yet by sem,FISCAL team to provide..)
%rngTune = qq(2024, 2) : qq(2024, 3);
%dbObs.tune_def_y(rngTune) = [11.9, 8.5];

end
