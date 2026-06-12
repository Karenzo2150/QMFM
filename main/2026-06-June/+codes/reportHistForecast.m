function reportHistForecast()
% codes.reportHistForecast() evaluates the historical forecast performance for all model parametrizations.
%
% Usage: codes.reportHistForecast()
% 
% codes.reportHistForecast creates a PDF report showing the historical
% forecasts in charts ("hairy charts"), and the main forecast error
% statistics in table (for all model parametrizations).
% 
% Relevant options are (in otps.histForecast):
% - variables:  the lsit of variables to be included in the report.
% - horizon:    the forecast horizon up to which the series are plotted and
%               forecast error statisticvs are reported in the tables.
% 
% The PDF report is saved as opts.resultsDirPdf/histForecastReport.pdf
% 
% See also: codes.calcHistForecast, codes.filterHistory, codes.calcForecast

% -------- Setup --------

opts = mainSettings();
optsHF = opts.histForecast;

codes.utils.writeMessage(mfilename + ": loading model and data ...");

% Load historical forecasts
tmp     = codes.utils.loadResult(opts, "histForecast");
dbHistFcast = tmp.dbHistFcast;

% Adjust histForecast range
tmp = databank.range(dbHistFcast(1));
optsHF.range = tmp(2:end);

% Load smoothed data
tmp = codes.utils.loadResult(opts, "filter");
dbFilt = tmp.dbFilt;

% Load model
tmp = codes.utils.loadResult(opts, "model");
m = tmp.m;

% Get variable names and comments

xNamesAll = string(get(m, "xnames"));
xDescrAll = string(get(m, "xdescript"));

paramNum = length(opts.parameterNames);

% Legend
legends = codes.reporting.createParamLegend(opts);

xNames = optsHF.variables;
xDescr = codes.utils.selectFromList(xNames, xNamesAll, xDescrAll);

enamesAll = string(get(m, "enames"));
edescrAll = string(get(m, "edescript"));

pnamesAll = string(get(m, "pnames"));
pdescrAll = string(get(m, "pdescript"));

pnamesAll = [pnamesAll, "std_" + enamesAll];
pdescrAll = [pdescrAll, edescrAll];

% Create report
rprt = report.new('Historical model-based forecasts');

% Comparison of parameters

if 1 < paramNum
  
  rprt.section('Comparing parameters');
  
  p   = get(m, "Parameters");
  p   = structfun(@transpose, p, "Uniformoutput", false);
  p   = table2array(struct2table(p))';
  
  ind = any(abs(p(:,2:end) - repmat(p(:,1), 1, paramNum-1)) > 1e-12, 2);
  ind = ind | any(isnan(p),2);
  p   = p(ind,:);
  
  rn = pdescrAll(ind)' + " [" + pnamesAll(ind)' + "]";
  
  rprt.matrix('Differing parameters', p, ...
    'rownames',       cellstr(rn), ...
    'colnames',       cellstr(opts.parameterLegends), ...
    'rotatecolnames', false);
  rprt.pagebreak;
  
end

% Calculate forecast error statistics

codes.utils.writeMessage(mfilename + ": calculating forecast error statistics ...");

for n = 1 : paramNum
  
  for i = 1:length(optsHF.variables)
    
    varName = optsHF.variables(i);
    
    fc    = [dbHistFcast(:, n).(varName)];
    act   = dbFilt.mean.(varName){:, n};
    
    fcErr       = fc - act;
    fcErrNum    = fcErr(:);
    fcErrRange  = fcErr.Range;
    
    fcErrHor.(varName)   = Series([], []);
    fcErrRWHor.(varName) = Series([], []);
    
    for h = 1 : optsHF.horizon
      
      fcErrRangeH = fcErrRange(h+1 : end);
      
      fcErrHor.(varName) = [ ...
        fcErrHor.(varName), ...
        Series(fcErrRangeH, diag(fcErrNum, -h))
        ];
      
      actH = act{fcErrRangeH};
      
      fcErrRWHor.(varName) = [ ...
        fcErrRWHor.(varName), ...
        actH{-h} - actH
        ];
      
    end
        
  end
  
  meanErr(n) = databank.batch(fcErrHor, '$0', ...
    ['Series(1:', num2str(optsHF.horizon), ',nanmean($0))'], ...
    'AddToDatabank', struct()); %#ok<AGROW>
  
  meanAbsErr(n) = databank.batch(fcErrHor, '$0', ...
    ['Series(1:', num2str(optsHF.horizon), ',nanmean(abs($0)))'], ...
    'AddToDatabank', struct()); %#ok<AGROW>
  
  rmse(n) = databank.batch(fcErrHor, '$0', ...
    ['Series(1:', num2str(optsHF.horizon), ',sqrt(nanmean($0^2)))'], ...
    'AddToDatabank', struct()); %#ok<AGROW>
  
  rmseRW(n) = databank.batch(fcErrRWHor, '$0', ...
    ['Series(1:', num2str(optsHF.horizon), ',sqrt(nanmean($0^2)))'], ...
    'AddToDatabank', struct()); %#ok<AGROW>
  
end

% Historical forecast charts

for i = 1:length(optsHF.variables)
  
  varName = optsHF.variables(i);
  
  figureTitle = xDescr(i) + " [" + xNames(i) + "]";
  rprt.figure(char(figureTitle));
  
  for n = 1:paramNum
    
    if paramNum > 1
      rprt.graph(char(legends(n)), 'axesOptions', {'box','off','fontsize',9});
    else
      rprt.graph('', 'axesOptions', {'box','off','fontsize',9});
    end
    
    % "Actual"
    rprt.series('', dbFilt.mean.(varName){:, n}, 'plotOptions', opts.style_hist_actual);
    
    % Forecasts
    rprt.series('', [dbHistFcast(:, n).(varName)], 'plotOptions', opts.style_hist_forecast);
    
    % Markers
    markers = Series();
    
    for t = 1:length(optsHF.range)
      tmp = dbHistFcast(t, n).(varName);
      markers(optsHF.range(t) - 1) = tmp(optsHF.range(t) - 1);
    end
    rprt.series('', markers, 'plotOptions', opts.style_hist_mark);
    
  end
  
end

% Forecast error evaluation tables
for n = 1:paramNum
  
  rowNames = xDescr + " [" + xNames + "]";
  colNames = num2str((1:8)') + "q";
  
  matrixTitle = "Root-mean-square error, " + legends(n);
  dataRMSE        = databank.toSeries(rmse(n));
  rprt.matrix(char(matrixTitle), dataRMSE(:)', ...
    'rownames', cellstr(rowNames), ...
    'colnames', cellstr(colNames), ...
    'format',   '%.3f');
  
  matrixTitle = "Mean absolute error, " + legends(n);
  dataMAE        = databank.toSeries(meanAbsErr(n));
  rprt.matrix(char(matrixTitle), dataMAE(:)', ...
    'rownames', cellstr(rowNames), ...
    'colnames', cellstr(colNames), ...
    'format',   '%.3f');
  
  matrixTitle = "Mean error, " + legends(n);
  dataME        = databank.toSeries(meanErr(n));
  rprt.matrix(char(matrixTitle), dataME(:)',...
    'rownames', cellstr(rowNames), ...
    'colnames', cellstr(colNames), ...
    'format',   '%.3f');
  
  matrixTitle = "Root-mean-square error compared to random walk, " + legends(n);
  dataRMSERW        = databank.toSeries(rmse(n)) / databank.toSeries(rmseRW(n));
  rprt.matrix(char(matrixTitle), dataRMSERW(:)',...
    'rownames', cellstr(rowNames), ...
    'colnames', cellstr(colNames), ...
    'format',   '%.3f');
  
end

codes.utils.writeMessage(mfilename + ": compiling the report ...");
codes.utils.saveReport(opts, "histForecastReport", rprt);
codes.utils.writeMessage(mfilename + ": done.");


% Save tables to CSV
% RMSE compared to RW 

nRows = numel(rowNames);
nCols = numel(colNames);
dataRMSERW = round(dataRMSERW(:)', 3);
dataMat = reshape(dataRMSERW(:), nRows, nCols);

T = array2table( ...
    dataMat, ...
    'RowNames', cellstr(rowNames), ...
    'VariableNames', matlab.lang.makeValidName(cellstr(colNames)) ...
);

codes.utils.writeMessage(mfilename + ": compiling the report ...");
codes.utils.writeTable(opts, "RMSE_RW", T);
codes.utils.writeMessage(mfilename + ": done.");

% RMSE table
nRows = numel(rowNames);
nCols = numel(colNames);
dataRMSE = round(dataRMSE(:)', 3);
dataMat = reshape(dataRMSE(:), nRows, nCols);

T = array2table( ...
    dataMat, ...
    'RowNames', cellstr(rowNames), ...
    'VariableNames', matlab.lang.makeValidName(cellstr(colNames)) ...
);

codes.utils.writeMessage(mfilename + ": compiling the report ...");
codes.utils.writeTable(opts, "RMSE", T);
codes.utils.writeMessage(mfilename + ": done.");

% Means absolute error

nRows = numel(rowNames);
nCols = numel(colNames);
dataMAE = round(dataMAE(:)', 3);
dataMat = reshape(dataMAE(:), nRows, nCols);

T = array2table( ...
    dataMat, ...
    'RowNames', cellstr(rowNames), ...
    'VariableNames', matlab.lang.makeValidName(cellstr(colNames)) ...
);

codes.utils.writeMessage(mfilename + ": compiling the report ...");
codes.utils.writeTable(opts, "MeanAbsError", T);
codes.utils.writeMessage(mfilename + ": done.");