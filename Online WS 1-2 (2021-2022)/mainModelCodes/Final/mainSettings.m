function opts = mainSettings

%% General options

opts.roundId    = "2021Q2";
opts.modelFile  = "minecofin";

%% Name of the parameters

opts.parameterNames   = "setparam";
opts.parameterLegends = "Baseline";

%% Actions to run

% If 'true', the whole program runs

opts.readModel.run                    = true;

opts.readData.run                     = true;

opts.filterHistory.run                = true;

opts.reportModel.run                  = true;
opts.reportModel.steady.run           = true;
opts.reportModel.IRF.run              = true;
opts.reportModel.varDecomp.run        = false;
opts.reportModel.stdComp.run          = false;
opts.reportModel.equations.run        = false;

opts.reportHistory.run                = true;
opts.reportHistory.obs.run            = true;
opts.reportHistory.trends.run         = true;
opts.reportHistory.eqDecomps.run      = true;
opts.reportHistory.shockDecomps.run   = true;
opts.reportHistory.shocks.run         = true;

opts.calcHistForecast.run             = true;

opts.reportHistForecast.run           = true;

opts.calcForecast.run                 = true;

opts.reportForecast.run               = true;

%% Steady state report

opts.reportModel.steady.variables = [
  "l_cons_gap"
  "l_inv_gap"
  "l_gcons_gap"
  "l_exp_gap"
  "l_y_gap"
  "l_z_gap"
  "r_gap"
  "rmc"
  "def"
  "def_str"
  "def_discr"
  "l_rp_cpi_core_gap"
  "l_rp_cpi_food_gap"
  "l_rp_cpi_ener_gap"
  "prem_d_gap"
  "d4l_cpi_tar"
  "dl_cpi"
  "dl_cpi_core"
  "dl_cpi_food"
  "dl_cpi_ener"
  "i"
  "i_tnd"
  "r"
  "r_tnd"
  "dl_rp_cpi_core_tnd"
  "dl_rp_cpi_food_tnd"
  "dl_rp_cpi_ener_tnd"
  ];

%% IRF options

% Length of IRF
opts.reportModel.IRF.horizon    = 40;

% List of the shocks. If it is set to @all, all of them will be in the report
opts.reportModel.IRF.shocks     = [
  "shock_l_cons_gap"
  "shock_l_inv_gap"
  "shock_l_gcons_gap"
  "shock_l_exp_gap"
  "shock_dl_cpi_core"
  "shock_i"
  "shock_l_s"
  "shock_def_discr"
  "shock_istar"
  "shock_dl_cpistar"
  "shock_l_rp_foodstar_gap"
  "shock_l_rp_enerstar_gap"
  ];

% Size of the shock, percentage point
opts.reportModel.IRF.shockSize = 1;

% Variables in the report
opts.reportModel.IRF.variables  = [
  "l_cons_gap"
  "l_inv_gap"
  "l_gcons_gap"
  "l_exp_gap"
  "l_imp_gap"
  "l_y_gap"
  "dl_cpi_core"
  "dl_cpi_ener"
  "dl_cpi_food"
  "r4_gap"
  "l_z_gap"
  "rmc"
  "i"
  "l_s"
  "l_z"
  "def"
  "fisc_imp"
  "dl_s"
  ];

% Setting the subplot
opts.reportModel.IRF.subplot = [5 4];

%% VD options

% Length of vardecomp
opts.reportModel.varDecomp.horizon    = 20;

% Variables in the report
opts.reportModel.varDecomp.variables  = [...
  "dl_cons"
  "dl_inv"
  "dl_gcons"
  "dl_exp"
  "dl_imp"
  "dl_y"
  "dl_cpi"
  "dl_cpi_core"
  "dl_cpi_food"
  "dl_cpi_ener"
  "i"
  "l_s"
  "l_cons_gap"
  "l_inv_gap"
  "l_gcons_gap"
  "l_exp_gap"
  "l_imp_gap"
  "l_y_gap"
  "l_z_gap"
  "r_gap"
  "l_rp_cpi_core_gap"
  "l_rp_cpi_food_gap"
  "l_rp_cpi_ener_gap"
  "def"
  ];

% Number of the variables in the contribution
opts.reportModel.varDecomp.contribs   = 6;

% Historical range of vardecomp
opts.reportModel.varDecomp.histRange = qq(2006,1):qq(2019,4);

% Variables in the standard deviation comparison
opts.reportModel.stdComp.variables  = [
  "dl_cons"
  "d4l_cons"
  "dl_inv"
  "d4l_inv"
  "dl_gcons"
  "d4l_gcons"
  "dl_exp"
  "d4l_exp"
  "dl_imp"
  "d4l_imp"
  "dl_y"
  "d4l_y"
  "def"
  "dl_cpi"
  "d4l_cpi"
  "dl_cpi_core"
  "d4l_cpi_core"
  "dl_cpi_food"
  "d4l_cpi_food"
  "dl_cpi_ener"
  "d4l_cpi_ener"
  "i"
  "prem_d_gap"
  "dl_s"
  "d4l_s"
  %   "l_cons_gap"
  %   "l_inv_gap"
  %   "l_gcons_gap"
  %   "l_exp_gap"
  %   "l_imp_gap"
  %   "l_y_gap"
  %   "l_z_gap"
  %   "r_gap"
  %   "l_rp_cpi_core_gap"
  %   "l_rp_cpi_food_gap"
  %   "l_rp_cpi_ener_gap"
  %   "l_ystar_gap"
  %   "dl_cpistar"
  %   "istar"
  %   "rstar_tnd"
  %   "dl_foodstar"
  %   "l_rp_foodstar_gap"
  %   "dl_rp_foodstar_tnd"
  %   "dl_enerstar"
  %   "l_rp_enerstar_gap"
  %   "dl_rp_enerstar_tnd"
  ];

% Shock in the standard deviations comparison
opts.reportModel.stdComp.shocks = [
  "shock_l_cons_gap"
  "shock_l_inv_gap"
  "shock_l_gcons_gap"
  "shock_l_exp_gap"
  "shock_l_y_gap"
  "shock_dl_cpi_core"
  "shock_dl_cpi_food"
  "shock_dl_cpi_ener"
  "shock_i"
  "shock_prem_d_gap"
  "shock_l_s"
  "shock_def_discr"
  ];

% Range of comparison
opts.reportModel.stdComp.range = qq(2006,1) : qq(2019,4);

%% Historical filter options

% Filtered range
opts.filterHistory.range = qq(2006,1) : qq(2020,4);

% Variables whose trend/gap decomposition is plotted
opts.filterHistory.trendGapVars = [
  "l_cons"
  "l_inv"
  "l_gcons"
  "l_exp"
  "l_imp"
  "l_y"
  "l_z"
  "i"
  "l_rp_cpi_core"
  "l_rp_cpi_food"
  "l_rp_cpi_ener"
  ];

% Variables in the report
opts.filterHistory.shockDecompVars = [
  "dl_cons"
  "dl_inv"
  "dl_gcons"
  "dl_exp"
  "dl_imp"
  "dl_y"
  "dl_cpi_core"
  "dl_cpi_food"
  "dl_cpi_ener"
  "i"
  "dl_s"
  "l_cons_gap"
  "l_inv_gap"
  "l_gcons_gap"
  "l_exp_gap"
  "l_imp_gap"
  "l_y_gap"
  "r4_gap"
  "l_z_gap"
  "def"
  ];

opts.filterHistory.shockDecompGroups.Demand     = ["shock_l_cons_gap", "shock_l_inv_gap", "shock_l_exp_gap"];
opts.filterHistory.shockDecompGroups.Supply     = ["shock_dl_cpi_core", "shock_dl_cpi_food", "shock_dl_cpi_ener"];
opts.filterHistory.shockDecompGroups.Fiscal     = ["shock_def_discr", "shock_def_str", "shock_l_gcons_gap"];
opts.filterHistory.shockDecompGroups.MonPol     = ["shock_i", "shock_dl_s_tar", "shock_d4l_cpi_tar", "shock_prem_d_gap"];
opts.filterHistory.shockDecompGroups.UIP        = ["shock_prem", "shock_l_s"];
opts.filterHistory.shockDecompGroups.Commodity  = ["shock_l_rp_foodstar_gap", "shock_l_rp_enerstar_gap", "shock_dl_rp_foodstar_tnd", "shock_dl_rp_enerstar_tnd"];
opts.filterHistory.shockDecompGroups.External   = ["shock_l_ystar_gap", "shock_dl_cpistar", "shock_istar", "shock_rstar_tnd"];
opts.filterHistory.shockDecompGroups.Trends     = ["shock_dl_cons_tnd", "shock_dl_inv_tnd", "shock_dl_gcons_tnd", "shock_dl_exp_tnd", "shock_dl_imp_tnd", "shock_dl_z_tnd", "shock_dl_rp_cpi_food_tnd", "shock_dl_rp_cpi_ener_tnd"];
opts.filterHistory.shockDecompGroups.Discr      = ["shock_l_cpi", "shock_l_y_gap", "shock_l_imp_gap"];

opts.filterHistory.shockDecompGroups.Rest       = "Other/det.";

%% Historical forecast options

% Range of historical forecast
opts.histForecast.range = qq(2010,1) : qq(2019,4);

% Horizon of historical forecast
opts.histForecast.horizon = 8;

% Variables in the report
opts.histForecast.variables = [
  "dl_cons"
  "dl_inv"
  "dl_gcons"
  "dl_exp"
  "dl_imp"
  "dl_y"
  "dl_cpi_core"
  "dl_cpi_food"
  "dl_cpi_ener"
  "i"
  "l_s"
  "dl_s"
  "def"
  "dl_rmd"
  "l_cons_gap"
  "l_inv_gap"
  "l_gcons_gap"
  "l_exp_gap"
  "l_imp_gap"
  "l_y_gap"
  "l_z_gap"
  "r4_gap"
  "fisc_imp"
  "i_tnd"
  "r_tnd"
  "d4l_cpi_tar"
  "prem"
  "e_dl_z_tnd"
  "prem_d_gap"
  ];

% Observed exogenous variables

% opts.histForecast.exogvars = [
%   "l_ystar_gap",        "obs_l_ystar_gap",        "shock_l_ystar_gap"; ...
%   "l_cpistar",          "obs_l_cpistar",          "shock_dl_cpistar"; ...
%   "istar",              "obs_istar",              "shock_istar"; ...
%   "rstar_tnd",          "obs_rstar_tnd",          "shock_rstar_tnd"; ...
%   "l_rp_foodstar_gap",  "obs_l_rp_foodstar_gap",  "shock_l_rp_foodstar_gap"; ...
%   "l_rp_enerstar_gap",  "obs_l_rp_enerstar_gap",  "shock_l_rp_enerstar_gap"; ...
%   "l_foodstar",         "obs_l_foodstar",         "shock_dl_rp_foodstar_tnd"; ...
%   "l_enerstar",         "obs_l_enerstar",         "shock_dl_rp_enerstar_tnd"; ...
%   ];

opts.histForecast.exogvars = [
  "l_ystar_gap",        "obs_l_ystar_gap",        "shock_l_ystar_gap"; ...
  "l_cpistar",          "obs_l_cpistar",          "shock_dl_cpistar"; ...
  "istar",              "obs_istar",              "shock_istar"; ...
  "rstar_tnd",          "obs_rstar_tnd",          "shock_rstar_tnd"; ...
  "l_rp_foodstar_gap",  "obs_l_rp_foodstar_gap",  "shock_l_rp_foodstar_gap"; ...
  "l_rp_enerstar_gap",  "obs_l_rp_enerstar_gap",  "shock_l_rp_enerstar_gap"; ...
  "l_foodstar",         "obs_l_foodstar",         "shock_dl_rp_foodstar_tnd"; ...
  "l_enerstar",         "obs_l_enerstar",         "shock_dl_rp_enerstar_tnd"; ...
  "l_cons_tnd",         "obs_l_cons_tnd",         "shock_dl_cons_tnd"; ...
  "l_inv_tnd",          "obs_l_inv_tnd",          "shock_dl_inv_tnd"; ...
  "l_gcons_tnd",        "obs_l_gcons_tnd",        "shock_dl_gcons_tnd"; ...
  "l_exp_tnd",          "obs_l_exp_tnd",          "shock_dl_exp_tnd"; ...
  "l_imp_tnd",          "obs_l_imp_tnd",          "shock_dl_imp_tnd"; ...
  "d4l_cpi_tar",        "obs_d4l_cpi_tar",        "shock_d4l_cpi_tar"; ...
  "l_rp_cpi_food_tnd",  "obs_l_rp_cpi_food_tnd",  "shock_dl_rp_cpi_food_tnd"; ...
  "l_rp_cpi_ener_tnd",  "obs_l_rp_cpi_ener_tnd",  "shock_dl_rp_cpi_ener_tnd"; ...
  "l_z_tnd",            "obs_l_z_tnd",            "shock_dl_z_tnd"; ...
  "prem",               "obs_prem",               "shock_prem"; ...
  "dl_s_tar",           "obs_dl_s_tar",           "shock_dl_s_tar"; ...
  "def_str",            "obs_def_str",            "shock_def_str"; ...
  ];

% opts.histForecast.exogvars = [
%   "l_ystar_gap",        "obs_l_ystar_gap",        "shock_l_ystar_gap"; ...
%   "l_cpistar",          "obs_l_cpistar",          "shock_dl_cpistar"; ...
%   "istar",              "obs_istar",              "shock_istar"; ...
%   "rstar_tnd",          "obs_rstar_tnd",          "shock_rstar_tnd"; ...
%   "l_rp_foodstar_gap",  "obs_l_rp_foodstar_gap",  "shock_l_rp_foodstar_gap"; ...
%   "l_rp_enerstar_gap",  "obs_l_rp_enerstar_gap",  "shock_l_rp_enerstar_gap"; ...
%   "l_foodstar",         "obs_l_foodstar",         "shock_dl_rp_foodstar_tnd"; ...
%   "l_enerstar",         "obs_l_enerstar",         "shock_dl_rp_enerstar_tnd"; ...
%   "l_cons_tnd",         "obs_l_cons_tnd",         ""; ...
%   "l_inv_tnd",          "obs_l_inv_tnd",          ""; ...
%   "l_gcons_tnd",        "obs_l_gcons_tnd",        ""; ...
%   "l_exp_tnd",          "obs_l_exp_tnd",          ""; ...
%   "l_imp_tnd",          "obs_l_imp_tnd",          ""; ...
%   "d4l_cpi_tar",        "obs_d4l_cpi_tar",        ""; ...
%   "l_rp_cpi_food_tnd",  "obs_l_rp_cpi_food_tnd",  ""; ...
%   "l_rp_cpi_ener_tnd",  "obs_l_rp_cpi_ener_tnd",  ""; ...
%   "l_z_tnd",            "obs_l_z_tnd",            ""; ...
%   "prem",               "obs_prem",               ""; ...
%   "dl_s_tar",           "obs_dl_s_tar",           ""; ...
%   "def_str",            "obs_def_str",            ""; ...
%   ];

% opts.histForecast.exogvars = [
%   "l_ystar_gap",        "obs_l_ystar_gap",        "shock_l_ystar_gap"; ...
%   "l_cpistar",          "obs_l_cpistar",          "shock_dl_cpistar"; ...
%   "istar",              "obs_istar",              "shock_istar"; ...
%   "rstar_tnd",          "obs_rstar_tnd",          "shock_rstar_tnd"; ...
%   "l_rp_foodstar_gap",  "obs_l_rp_foodstar_gap",  "shock_l_rp_foodstar_gap"; ...
%   "l_rp_enerstar_gap",  "obs_l_rp_enerstar_gap",  "shock_l_rp_enerstar_gap"; ...
%   "l_foodstar",         "obs_l_foodstar",         "shock_dl_rp_foodstar_tnd"; ...
%   "l_enerstar",         "obs_l_enerstar",         "shock_dl_rp_enerstar_tnd"; ...
%   "l_y_tnd",            "obs_l_y_tnd",            "shock_dl_y_tnd"; ...
%   "d4l_cpi_tar",        "obs_d4l_cpi_tar",        "shock_d4l_cpi_tar"; ...
%   "l_rp_cpi_food_tnd",  "obs_l_rp_cpi_food_tnd",  "shock_dl_rp_cpi_food_tnd"; ...
%   "l_rp_cpi_ener_tnd",  "obs_l_rp_cpi_ener_tnd",  "shock_dl_rp_cpi_ener_tnd"; ...
%   "l_z_tnd",            "obs_l_z_tnd",            "shock_dl_z_tnd"; ...
%   "prem",               "obs_prem",               "shock_prem"; ...
%   "dl_s_tar",           "obs_dl_s_tar",           "shock_dl_s_tar"; ...
%   "def_str",            "obs_def_str",            "shock_def_str"; ...
%   "def",                "obs_def",                "shock_def_discr"; ...
%   ];

%% Forecast options

% Horizon of forecast
opts.forecast.range = qq(2021,1):qq(2026,2);

% Name of the forecast(s)
opts.forecast.scenarioNames = [
  "Baseline"
  "NTF"
  ];

opts.forecast.scenarioLegends = [
  "Baseline forecast"
  "NTF forecast"
  ];

%% Report forecast options

% Range of the graphs in the forecast report
opts.forecastReport.plotRange      = qq(2015,1):qq(2026,4);

% Range of the highlighted area
opts.forecastReport.highlightRange = qq(2015,1):qq(2020,4);


%% Process options

opts.mainDir = fileparts(mfilename("fullpath"));
addpath(opts.mainDir);
opts = codes.processOptions(opts);

end