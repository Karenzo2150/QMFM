function reportForecast(scenarios)

opts    = mainSettings();
optsF   = opts.forecast;
optsFR  = opts.forecastReport;

if nargin < 2
  scenarios = optsF.scenarioNames;
end

% Load data
tmp     = codes.loadResult(opts, "data");
dbObs   = tmp.dbObsTrans;

% Load forecast
tmp = codes.loadResult(opts, "forecast");
m   = tmp.m;
db  = tmp.dbFcast;

legends = codes.reporting.createScenarioLegend(opts);

% Create the report
reportTitle = "Forecast report";
rprt = report.new(char(reportTitle));

% Main indicators

varNames   = [
  "d4l_cpi"
  "d4l_y"
  "i"
  "d4l_s"
  "def"
  ];

figureTitle = "Main indicators";

rprt = codes.reporting.addPage(opts, rprt, m, db, varNames, figureTitle, legends);

% Inflation

varNames   = [
  "d4l_cpi"
  "d4l_cpi_core"
  "d4l_cpi_food"
  "d4l_cpi_ener"
  ];

figureTitle = "Inflation";

rprt = codes.reporting.addPage(opts, rprt, m, db, varNames, figureTitle, legends);

% Cyclical indicators

varNames   = [
  "l_y_gap"
  "l_z_gap"
  "r4_gap"
  ];

figureTitle = "Cyclical indicators";

rprt = codes.reporting.addPage(opts, rprt, m, db, varNames, figureTitle, legends);

% External variables

varNames   = [
  "l_ystar_gap"
  "istar"
  "rstar_tnd"
  "d4l_foodstar"
  "l_rp_foodstar_gap"
  "d4l_enerstar"
  "l_rp_enerstar_gap"
  ];

figureTitle = "External variables";

rprt = codes.reporting.addPage(opts, rprt, m, db, varNames, figureTitle, legends);

% Trends & gaps
    
rprt = codes.reporting.addTrendsAndGaps(opts, rprt, m, db, dbObs, optsFR.plotRange, legends);
   
% Decompositions of equations

rprt = codes.reporting.addDecompositions(opts, rprt, m, db, optsFR.plotRange, legends);

% Shocks

rprt = codes.reporting.addShocks(opts, rprt, m, db, optsFR.plotRange, legends);

% Publish report

codes.writeMessage("reportForecast: compiling the forecast report ...");

fileName = fullfile(opts.mainDir, "reports", "forecastReport.pdf");
if codes.checkFile(fileName)
  rprt.publish(fileName, opts.publishOptions{:}, 'textscale', [0.95 0.8]);
end

% Close invisible figure windows
codes.closeFigures();

codes.writeMessage("reportForecast: done.");

end