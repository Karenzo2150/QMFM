function reportHistory

%% Setup

opts = mainSettings();

codes.writeMessage("reportHistory: loading model and data ...");

% Load model
tmp   = codes.loadResult(opts, "model");
m     = tmp.m;

% Load observed data
tmp     = codes.loadResult(opts, "data");
dbObs   = tmp.dbObsTrans;

% Load filtered data
tmp     = codes.loadResult(opts, "filter");
db      = tmp.dbFilt.mean;
dbContr = tmp.dbContr;

paramNum = length(opts.parameterNames);

optsFH  = opts.filterHistory;
optsRH  = opts.reportHistory;

legends = codes.reporting.createParamLegend(opts);

% Create report
rprt = report.new('Observed and filtered data');

%% Comparison of parameters

if 1 < paramNum
  
  rprt.section('Comparing parameters');
  
  rprt = codes.reporting.addParameterComparison(opts, rprt, m);
  
end

%% Observed data

if optsRH.obs.run
  
  codes.writeMessage("reportHistory: adding observed data to the history report ...");
  
  rprt = codes.reporting.addObservedData(opts, rprt, m, dbObs, optsFH.range);
  
end

%% Trends & gaps

if optsRH.trends.run
  
  codes.writeMessage("reportHistory: adding trends and gaps to the history report ...");
  
  rprt = codes.reporting.addTrendsAndGaps(opts, rprt, m, db, dbObs, optsFH.range, legends);
  
end

%% Decompositions of equations

if optsRH.eqDecomps.run
  
  codes.writeMessage("reportHistory: adding equation decompositions to the history report ...");
  
  rprt = codes.reporting.addDecompositions(opts, rprt, m, db, optsFH.range, legends);
    
end

%% Shock decompositions

if optsRH.shockDecomps.run
  
  codes.writeMessage("reportHistory: adding shock decompositions to the history report ...");
  
  rprt = codes.reporting.addShockDecompositions(opts, rprt, m, db, dbContr, optsFH.range, legends);
  
end

%% Shocks

if optsRH.shocks.run
  
  codes.writeMessage("reportHistory: adding shocks to the history report ...");
  
  rprt = codes.reporting.addShocks(opts, rprt, m, db, optsFH.range, legends);
  
end

%% Publish report

codes.writeMessage("reportHistory: compiling the history report ...");

fileName = fullfile(opts.mainDir, "reports", "reportHistory.pdf");
if codes.checkFile(fileName)
  rprt.publish(fileName, opts.publishOptions{:});
end

% Close invisible figure windows
codes.closeFigures();

codes.writeMessage("reportHistory: done");

end
