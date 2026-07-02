function reportForecast
% codes.reportForecast() creates a report of the forecasts for all scenarios.
%
% Usage: codes.reportForecast()
%
% codes.reportForecasts loads the forecast results, and creates a PDF
% report with tables and charts of selected variables, together with the
% extended versions of the trend/gap charts, equations decompositions, and
% shock charts which are shown in the history report. The charts/tables
% show the forecasts for al scenarios.
%
% Relevant options are:
% - opts.forecast.plotRange:        range of the charts
% - opts.forecast.tableRange:       range of the tables
% - opts.forecast.highlightRange:   range of highlighted (by a backround
%                                   shadow) data points
%
% The PDF report is saved as opts.resultsDirPdf/forecastReport.pdf
% 
% See also: codes.calcForecast, codes.reportFilter,
% codes.reportCompareForecast, codes.reportForecastChangeDecomp


opts    = mainSettings();
optsFR  = opts.forecastReport;

% Load the forecast
tmp = codes.utils.loadResult(opts, "forecast");
m   = tmp.m;
db  = tmp.dbFcast;
dbEqDecomp  = tmp.dbEqDecomp;
dbShockDecomp  = tmp.dbShockDecomp;

% Rescale debt variables
Qshare = db.ny/(db.ny+db.ny{-1}+db.ny{-2}+db.ny{-3}); %more accurate than 1/4
db.debt_y     = db.debt_y * Qshare; 
db.debt_fcy_y = db.debt_fcy_y * Qshare;
db.debt_lcy_y = db.debt_lcy_y * Qshare;

% % redefine q-on-q change of flows without annual.(*4)
% db.pct_y    = db.pct_y/4;
% db.pct_cons = db.pct_cons/4;
% db.pct_inv  = db.pct_inv/4;
% db.pct_gdem = db.pct_gdem/4;
% db.pct_exp  = db.pct_exp/4;
% db.pct_imp  = db.pct_imp/4;

legends = codes.reporting.createScenarioLegend(opts);
%select
% Create the report
reportTitle = "Forecast report";
rprt = report.new(char(reportTitle));

%%%%%%%%%%%%% Tables %%%%%%%%%%%%%

rprt.section('Forecast tables');
rprt.pagebreak;

tableRange  = optsFR.tableRange;
vLine       = opts.forecast.range(1);

% Main indicators table with percent changes

varNames   = [
  "pct4_cpi", "CPI (headline), YoY %"
  "pct4_y",   "GDP, YoY %"
  "pct_i",    "Interbank rate, %"; 
  "pct4_s",   "Exchange rate, YoY %"
  "def_y",    "Deficit (excl. grants), % of GDP"
  "grev_y",    "Govt revenue, % of GDP"
  "gdem_y",   "Govt demand G&S, % of GDP"
  "oexp_y"    "Other spending, % of GDP"
  ];

tableTitle = "Main indicators";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

% GDP table with yoy percent changes

varNames   = [
  "pct4_y",     "GDP"
  "pct4_cons",  "Private consumption"
  "pct4_inv",   "Private investment"
  "pct4_gdem",  "Gov. demand of G&S."
  "pct4_exp",   "Export of G&S"
  "pct4_imp",   "Import of G&S"
  ];

tableTitle = "GDP final demand, YoY % change";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

% GDP table with q-o-q percent changes, annualized

varNames   = [
   "pct_y",     "GDP"
  "pct_cons",  "Private consumption"
  "pct_inv",   "Private investment"
  "pct_gdem",  "Gov. dem.demand of G&S"
  "pct_exp",   "Export of G&S"
  "pct_imp",   "Import of G&S"
  ];

tableTitle = "GDP final demand, QoQ % change. annualized";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

% Inflation table with y-o-y percent changes

varNames   = [
  "pct4_cpi",       "Headline"
  "pct4_cpi_core",  "Core"
  "pct4_cpi_food",  "Food"
  "pct4_cpi_ener",  "Energy"
  ];

tableTitle = "Inflation (CPI), YoY % change";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

% Inflation table with qoq percent changes

varNames   = [
  "pct_cpi",       "Headline"
  "pct_cpi_core",  "Core"
  "pct_cpi_food",  "Food"
  "pct_cpi_ener",  "Energy"
  ];

tableTitle = "Inflation (CPI), QoQ % change annualized";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

% Fiscal indicators

varNames   = [
  "def_y",        "Deficit (excl. grants)"
  "def_y_str",    "Structural"
  "def_y_cyc",    "Cyclical"
  "def_y_discr",  "Discretional"
  "fisc_imp",     "Fiscal impulse"
  ];

tableTitle = "Fiscal/bugdet, % of GDP";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

% Auxiliary model results

varNames    =  [
"def_y",      "Deficit (excl. grants), % of GDP"
"grants_y",   "Grants, % of GDP"
"def_fcy_y",  "Deficit in foreign currency, % of GDP"
"def_lcy_y",  "Deficit in local currency, % of GDP"
"debt_fcy_y", "Debt in foreign currency, % of GDP"
"debt_lcy_y", "Debt in local currency, % of GDP"
"tb_rat",     "Resource balance ratio % of GDP";
"dBP_usd",    "Net private capital flows, Mln USD"
"dl_md",      "Money demand, % QoQ ann."
"dl_py",      "GDP deflator, % QoQ ann."
];
tableTitle = "Other reporting indicators";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

%%%%%%%%%%%%% Charts %%%%%%%%%%%%%

rprt.pagebreak;
rprt.section('Forecast charts');
rprt.pagebreak;

plotRange = optsFR.plotRange;
highlightRange = opts.forecast.range;

% Main indicators

varNames   = [
  "d4l_cpi"
  "d4l_y"
  "i"
  "r" ; 
  "d4l_s"
  "d4l_z" ;
  "def_y"
  ];

figureTitle = "Main indicators";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% GDP, yy

varNames   = [
  "d4l_y"
  "d4l_cons"
  "d4l_inv"
  "d4l_gdem"
  "d4l_exp"
  "d4l_imp"
  ];

figureTitle = "GDP final demand, YoY % change";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% GDP, qq

varNames   = [
  "dl_y"
  "dl_cons"
  "dl_inv"
  "dl_gdem"
  "dl_exp"
  "dl_imp"
  ];

figureTitle = "GDP final demand, QoQ % change";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% Inflation, yy

varNames   = [
  "d4l_cpi"
  "d4l_cpi_core"
  "d4l_cpi_food"
  "d4l_cpi_ener"
  ];

figureTitle = "GDP final demand, QoQ % change";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% Inflation, qq

varNames   = [
  "dl_cpi"
  "dl_cpi_core"
  "dl_cpi_food"
  "dl_cpi_ener"
  ];

figureTitle = "Inflation (CPI), YoY %change";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% Deficit

varNames   = [
  "def_y"
  "def_y_str"
  "def_y_cyc"
  "def_y_discr"
  "fisc_imp"
  ];

figureTitle = "Fiscal/bugdet, % of GDP";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% Main cyclical indicators

varNames   = [
  "l_y_gap"
  "l_z_gap"
  "r4_gap"
  ];

figureTitle = "Main cyclical position (gap) indicators";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% Cyclical indicators, GDP

varNames   = [
  "l_cons_gap"
  "l_inv_gap"
  "l_gdem_gap"
  "l_exp_gap"
  "l_imp_gap"
  ];

figureTitle = "GDP cyclical position (gap)";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

% External variables

varNames   = [
  "l_ystar_gap"
  "istar"
  "rstar_tnd"
  "d4l_cpistar" ; % ak add dec 29
  "d4l_foodstar"
  "l_rp_foodstar_gap"
  "d4l_enerstar"
  "l_rp_enerstar_gap"
  ];

figureTitle = "External/foreign, exogenous";

rprt = codes.reporting.addChartPage(opts, rprt, m, db, plotRange, varNames, figureTitle, legends, highlightRange);

%%%%%%%%%%%%% Trends and gaps %%%%%%%%%%%%%
    
rprt = codes.reporting.addTrendsAndGaps(opts, rprt, m, db, db, optsFR.plotRange, legends, ...
  "forecast");
   
%%%%%%%%%%%%% Decompositions of equations %%%%%%%%%%%%%

rprt = codes.reporting.addDecompCharts(opts, rprt, m, dbEqDecomp, optsFR.plotRange, legends, "forecast");
  
rprt = codes.reporting.addDecompTables(opts, rprt, m, dbEqDecomp, optsFR.tableRange, legends);

rprt = codes.reporting.addShockDecompositions(opts, rprt, m, db, dbShockDecomp, optsFR.plotRange, legends, "forecast");

%%%%%%%%%%%%% Shocks %%%%%%%%%%%%%

rprt = codes.reporting.addShocks(opts, rprt, m, db, optsFR.plotRange, legends, "forecast");

shockNames = string(get(m, "eList"))'; 
varNames = [shockNames, shockNames];

tableTitle = "Shocks";

rprt = codes.reporting.addTablePage(opts, rprt, m, db, tableRange, varNames, tableTitle, legends, vLine);

% Publish report

codes.utils.writeMessage(mfilename + ": compiling the forecast report ...");
codes.utils.saveReport(opts, "forecastReport", rprt);
codes.utils.writeMessage(mfilename + ": done.");

end