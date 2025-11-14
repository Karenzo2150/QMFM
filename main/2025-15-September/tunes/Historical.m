function dbObs = Historical(dbObs)  % 

%% --------Set tune values for normal filter (hist data) or extended filter (prel./nowcast)-----
% do not create Series here! Only assign values to existing series, created in loop above

% the outgap is set low to allow GDP level move close to trend to
% incoporate the assumption that COVID-19 outbreak has had a potential
% effect in GDP potential growth
rngTune = qq(2022, 4);
dbObs.tune_l_y_gap(rngTune) = -2;

% to assume a somewhat significant effect of fiscal policies (gdem gap) on output gap in COVID, 
% we allow the govt demand trend/structual bend down during 2019-2023, 
% assume gdem_y trend at 24.5% (26.5) meaning slightly lower 2% points of GDP lower than historical trend: 
% to bend down structural govt demand 2017-20
% set structural level (trend) of govt demand
rngTune = qq(2017, 1): qq(2024, 2);
dbObs.tune_gdem_y_str(rngTune) = 24.5;

%% GDP extended filter for Nowcast Q 2025Q2-3, alternatively tune most recent Q with prel. NA
% filtration range set to a few Q beyond data (here: 2025Q2-3 with hist tunes for y-on-y GDP growth from Nowcast(no s.a. needed)
% filter distributes shocks among other demands, so movement in GDP not only attributed to cons shock (cf Baseline tune)
rngTune = qq(2025, 3) : qq(2025, 3);
dbObs.tune_d4l_y (rngTune) = 100 * log(1 + 7.7/100); % Nowcast Sept'25

%% CPI option to soft/hard-tune CPIs Near-Term based on NBR-forecast/judgement, expected shocks
% CPI tuning can also be information on developments of obs Mo CPI
% populated in Rwametric database 
% here we opt to tune headline CPI and 2 components or alternatively tune 3
% componets to derive the headline
 
% CPI_core hard-tune 2025Q4 based on NBR forecast/judgment (NB these are s.a. see readData)
% rngTune = qq(2025, 3);
% dbObs.tune_dl_cpi_core(rngTune) = [10.923]; % or 100 * log(1+0/100);

% % CPI_food hard-tune with 2025Q4 NBR forecast or judgment
% rngTune = qq(2025, 3): qq(2025, 3);
% dbObs.tune_dl_cpi_food(rngTune) = [-13.823];
 
% CPI_ener could soft-tune 2025Q4 for pump price effect of any excise tax change--not used now
% (NB 0.2 is share fuels in energy) 
% rngTune = qq(2025, 4) : qq(2025, 4);
% dbObs.tune_shock_dl_cpi_ener(rngTune) = 0;

% CPI_energy hard-tune with 2025Q4 NBR forecast or judgment
% rngTune= qq(2025, 3): qq(2025, 3);
% dbObs.tune_dl_cpi_ener(rngTune) = [13.411];
 
% CPI headline could be hard-tuned with 2025Q4 forecast or judgment
% we can only tune 3 of 4 CPIs (NB these are s.a.,see readData)
% rngTune = qq(2025, 4);
% dbObs.tune_l_cpi(rngTune) = [....];

%% ER hard-tuned for extended filter 2025Q4 if tuned in BL,eg % annualized = PCIeop target
% with realization ER thru 2025Q3 at x% (Q-on-Q), the annualized remainder is x%
% note 2025Q3 is already data, so entered as dbObs.obs.l_s in readData
% rngTune = qq(2025, 4); %for Historical, one wouldn't tune to set equal to data!
% dbObs.tune_l_s(rngTune) = dbObs.obs_l_s; % tune dl_s, added in model tune_ declaration

% rngTune = qq(2025, 3) : qq(2025, 3); % tune to guessed number
% dbObs.tune_l_s(rngTune) = [727.57];

% interest IB rate hard-tune for extended filter thru 2025Q3-4 if also tuned in BL
% (e.g. no change CBR, so IB 0.3% above CBR=6.75% 2025Aug)
% rngTune = qq(2025, 3) : qq(2025, 3);
% dbObs.obs_i(rngTune) = [6.0026];

%% fiscal (PCI deficit, govt revenue) hardtuned for extended filter thru 2025Q3 using May'25 PCI 

% govt revenue (discretionary revenue), alternative NOT used
rngTune = qq(2025,3) : qq(2025,3);
dbObs.tune_oexp_y(rngTune) = [6.2];

%% govt revenue tuned for 2025Q3: 2025/26 18.8% GDP, semI 18.6%, semII 19.0% 
rngTune = qq(2025, 3) : qq(2025, 3);
dbObs.tune_grev_y(rngTune) = [17.0];

%% deficit GFS1986 tuned for 2025Q3: 10.0% for 2025/26, semI 14.1%, semII 5.9%
rngTune = qq(2025, 3) : qq(2025, 3);
dbObs.tune_def_y(rngTune) = [8.5];

%% % soft-tune private investment shock, to reflect Bugesera (gov netLending,oexp) sum 5.2% GDP 2025/26-2027/28
% Additonal to Qatar equity investiment 
% effect spread over 12Q, markup 1/(investment/GDP)=1/0.15=6,take about half
% to tune the inv_gap shock for extended filter , need to shock_l_inv_gap
% in model section of shocks for expert judgement
rngTune = qq(2025, 3);
dbObs.tune_shock_l_inv_gap(rngTune) = [4.5];

end
