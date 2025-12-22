function p = setparam()

% Fiscal
p.d1  = 0.30; % Automatic stabilizer effect
p.d2  = 0.00; % Pers. of discr. component
p.d3  = 0.50; % Discr in fiscal impules, based on IMF WP/20/295
p.d4  = 0.95; % Persistence of structural component
p.d5  = 0.10; % Government consumption gap in def_discr
p.d6  = 0.10; % Government consumption trend in def_struct

% Consumption gap
p.a1_cons   = 0.65; % Lag, close to HU and AM models
p.a2_cons   = 0.00; % Expectation, less then in the above
p.a3_cons   = 0.1;  % RMCI, btw HU and AM
p.a4_cons   = 0.3;  % Output gap, in line with AM model
p.a5_cons   = 0.5;  % Fiscal impulse
p.a6_cons   = 1;    % RIR in rmci

% Investment gap
p.a1_inv   = 0.65;  % Lag
p.a2_inv   = 0.00;  % Expectation
p.a3_inv   = 0.1;   % RMCI
p.a4_inv   = 0.3;   % Output gap
p.a5_inv   = 0.3;   % Fiscal impulse
p.a6_inv   = 1;     % RIR in rmci

% Government consumption gap
p.a1_gcons   = 0.65;   % Lag

% Export gap
p.a1_exp  = 0.65; % Lag, wide range of AM = 0.125 and HU = 0.7
p.a2_exp  = 0.00; % Expectation
p.a3_exp  = 0.1;  % RMCI (i.e. RER): AM = 0.075, HU = 0.07
p.a5_exp  = 0.5;  % Foreign demand, in between HU and AM
p.a6_exp  = 0;    % RIR in rmci

% Import gap
p.w_imp_cons  = 0.30/1.3; % 30
p.w_imp_inv   = 0.40/1.3; % 40
p.w_imp_gcons  = 0.40/1.3; % 40
p.w_imp_exp   = 0.20/1.3; % 20

% Output gap
% p.a1  = 0.65; % Lag, in line with recent models for RWA, also GH and ZA
% p.a2  = 0.00; % Expectation, in line with the above (except ZA)
% p.a3  = 0.15; % RMCI, in line with recent models for RWA, also GH and ZA
% p.a4  = 0.2;  % Fiscal impulse, IMF WP/20/295 (correcting for the weights)
% p.a5  = 0.3;  % New RWA calibration from IMF WP/20/295
% p.a6  = 0.5;  % RIR in rmci
p.w_y_cons    = 0.78;
p.w_y_gcons   = 0.23;
p.w_y_exp     = 0.21;
p.w_y_imp     = 0.35;
p.w_y_inv     = 1 + p.w_y_imp - p.w_y_cons - p.w_y_gcons - p.w_y_exp; % 1.3  - 0.1 - 0.2 - 0.7 = 0.3

% p.w_y_cons + p.w_y_inv + p.w_y_gcons + p.w_y_exp - p.w_y_imp = 1 

% Core
p.b1  = 0.35; % Lag, based on IMF WP/20/295, but must be tested
p.b2  = 0.20; % RMC, based on IMF WP/20/295
p.b3  = 0.05; % Direct, close to SARB WP/17/01, but must be tested
p.b4  = 0.80; % Output gap in RMC, close to what we see in the references

% Food (add l_y_gap to rmcf, so that we can test the domestic cots effect)
p.bf1 = 0.5;0.60; % Lag, in line with average of references
p.bf2 = 0.1;0.03; % RMC, smaller the in most references
p.bf3 = 0.03; % Direct, somewhat larger than in SARB WP/17/01

% Energy (need to examine the exact content of the data; add l_y_gap to
% rmcf, so that we can test the domestic cots effect)
p.be1 = 0.5;0.80; % Lag, as in IMF WP/20/295
p.be2 = 0.01;0.1;0.03; % RMC, much larger in IMF WP/20/295
p.be3 = 0.01;0.03; % Direct, 0.08 in IMF WP/14/159

p.w_core = 7747/10000;
p.w_food = 1577/10000;
p.w_ener =  676/10000;

% Policy rule
p.c1 = 0.5; % Smoothing, smaller then in most references
p.c2 = 0.5; % dl_cpi_dev, lower end of the reference range, but larger then IMF WP/20/295 (do simulations with all "other" stabilization chanels turned off)
p.c3 = 0.5; % l_y_gap, most referecens have similar value, except IMF WP/20/295, which its lower (0.2)
p.c4 = 0.0; % FX target, does not appear in the any of the references
p.c5 = 0.9; % CPI target AR
p.c6 = 0.9; % Credit premium AR

% FX
p.e1 = 0.5;   % Pure target:     0
p.e2 = 0.2;   % Forward looking: 1
p.e3 = 0.9;   % Premium AR
p.e4 = 0.00;  % Target deprc. AR
p.e5 = 0.30;  % Target deprc. infl. dev.
p.e6 = 0.85;  % Target deprc. REER gap

% Money
p.m1 = 0.7; % Lag
p.m2 = 0.5; % Interest rate
p.m3 = 0.9; % Persistence of velicity

% Trend persistences
p.r_cons      = 0.95;
p.r_inv       = 0.95;
p.r_gcons     = 0.99;
p.r_exp       = 0.95;
p.r_imp       = 0.95;
p.r_z         = 0.95;
p.r_rp_food   = 0.90;
p.r_rp_ener   = 0.90;

% Steady states

p.ss_def_str              =  4.9223;7;
p.ss_debt_fcy_rat         =  55/65;
p.ss_dl_y_tnd             =  100*log(1 + 5.0/100);
p.ss_d4l_cpi_tar          =  100*log(1 + 5.0/100);
p.ss_dl_rp_cpi_food_tnd   =  100*log(1 + 2.0/100);
p.ss_dl_rp_cpi_ener_tnd   =  0.0;
p.ss_dl_z_tnd             =  0.0; 
p.ss_prem                 =  3;
p.ss_prem_d               =  8.5;
p.ss_prem_debt_fcy        = -0.5;
p.ss_prem_debt_lcy        =  2.8;
p.ss_dl_v                 =  100*log(1 - 2/100);

% Standard errors

p.std_shock_def_discr     = 3.0;
p.std_shock_l_cons_gap    = 2.5;
p.std_shock_l_inv_gap     = 6;
p.std_shock_l_gcons_gap    = 6;
p.std_shock_l_exp_gap     = 6;
p.std_shock_l_imp_gap     = 0.5;
p.std_shock_dl_cpi_core   = 2;0.95;
p.std_shock_dl_cpi_food   = 9;6;
p.std_shock_dl_cpi_ener   = 3.5;
p.std_shock_i             = 1;1.7;
p.std_shock_prem_d_gap    = 0.80;
p.std_shock_l_s           = 0.35;
p.std_shock_dl_rmd        = 1;
p.std_shock_dl_v          = 0.1;

% Discrepancy shocks
p.std_shock_l_y_gap       = 1e-4;
p.std_shock_l_cpi         = 1e-4;

p.std_shock_def_str             = 0.30;
p.std_shock_dl_cons_tnd         = 0.25;
p.std_shock_dl_inv_tnd          = 0.50;
p.std_shock_dl_gcons_tnd         = 0.50;
p.std_shock_dl_exp_tnd          = 0.75;
p.std_shock_dl_imp_tnd          = 0.25;
p.std_shock_dl_z_tnd            = 0.10;
p.std_shock_d4l_cpi_tar         = 0.10;
p.std_shock_dl_rp_cpi_food_tnd  = 0.50;
p.std_shock_dl_rp_cpi_ener_tnd  = 0.15;
p.std_shock_dl_s_tar            = 0.30;
p.std_shock_prem                = 0.10;

% External

p.ss_dl_cpistar           = 100*log(1 + 2/100);
p.ss_dl_rp_foodstar_tnd   = 0;
p.ss_dl_rp_enerstar_tnd   = 0;
p.ss_istar                = 3;
p.ss_rstar_tnd            = 0;

p.r_ystar             = 0.94;
p.r_cpistar           = 0.80;
p.r_istar             = 0.80;
p.r_rstar_tnd         = 0.90;
p.r_rp_foodstar_gap   = 0.62;
p.r_rp_enestar_gap    = 0.73;
p.r_rp_foodstar_tnd   = 0.90;
p.r_rp_enerstar_tnd   = 0.90;

p.std_shock_l_ystar_gap         = 0.25;
p.std_shock_dl_cpistar          = 3.8;
p.std_shock_istar               = 0.45;
p.std_shock_rstar_tnd           = 0.5;
p.std_shock_l_rp_foodstar_gap   = 5.3;
p.std_shock_l_rp_enerstar_gap   = 13.9;
p.std_shock_dl_rp_foodstar_tnd  = 0.5;3.7;
p.std_shock_dl_rp_enerstar_tnd  = 2.5;6;

% Reporting equation parameters

p.mu_pexp = 0.3;
p.mu_pimp = 0.3;

p.r_debt_fcy_rat = 55/65;

p.gamma_r = 1.0;
p.gamma_k = 0.5;
p.k_bar   = 100*log(95);

end