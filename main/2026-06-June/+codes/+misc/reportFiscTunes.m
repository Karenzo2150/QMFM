function reportFiscTunes
opts = mainSettings();
% FISCAL  "TOFE" GFS 2014 PRESENTATION - detailed TOFE
mainDataFullFile  = fullfile(opts.QMFMDir, "data", "Misc", 'FiscInyearExtract_QmfmTunes_27June2026');
%addDataFullFile   = fullfile(opts.QMFMDir, "data", opts.addDataFile);
codes.utils.writeMessage(mfilename ...
  + ": reading data from " + opts.mainDataFile + "...");

db = readtable(mainDataFullFile, ...
  "Sheet",    "FiscQmfm", ...
  "TextType", "string");

varNames= [
"ny"
"grev_y"
"gdem_y"
"oexp_y"
"oexp_NL_y"
"oexp_NKIA_y"
"gexp_y"
"def_y"
];

varDescr= [
"GDP (current prices)"
"Govt revenue (% GDP)"
"Govt demand (% GDP)"
"Other expenditure (% GDP)"
"Net Lending"
"Bugesera"
"Govt spending (% GDP)"
"Deficit (excl. grants, % GDP)"
];

for v = varNames(:)'
  ind     = db{:,1} == v;
  values = double(db{ind, 3:end}');
  %fiscTunes.(v)  = Series(yy(2019), values);
  fiscTunes.(v)  = Series(qq(2024, 3), values);
end
codes.utils.writeMessage(mfilename + ": saving results ...");
codes.utils.saveResult(opts, "fiscQmfmTunes", "fiscTunes");

%% QMFM Tuning Adj.

mainDataFullFile  = fullfile(opts.QMFMDir, "data", "Misc", 'FiscInyearExtract_QmfmTunes_27June2026');
%addDataFullFile   = fullfile(opts.QMFMDir, "data", opts.addDataFile);
codes.utils.writeMessage(mfilename ...
  + ": reading data from " + opts.mainDataFile + "...");

db = readtable(mainDataFullFile, ...
  "Sheet",    "FiscQmfm", ...
  "TextType", "string");

varNames= [
"def_yq"
"grev_yq"
"gdem_yq"
"oexp_yq"
"inv_yq"
];

varDescr = [
    "Deficit (excl. grants, % GDP)"
    "Govt revenue (% GDP)"
    "Govt demand (% GDP)"
     "Other expenditure (% GDP)"
    "Private inv shock (NKIA Govt, %GDP)"
];

for v = varNames(:)'
  ind     = db{:,1} == v;
  values = double(db{ind, 3:end}');
  fiscTunes.(v)  = Series(qq(2024, 3), values);
end
codes.utils.writeMessage(mfilename + ": saving results ...");
codes.utils.saveResult(opts, "fiscQmfmTunes", "fiscTunes");
codes.utils.writeMessage(mfilename + ": done");

%% Comparison charts reporting
% QMFM Tuning Adj.

varNames= [
 "def_yq"
"grev_yq"
"gdem_yq"
"oexp_yq"
"inv_yq"
];

varDescr = [
    "Deficit (excl. grants, % GDP)"
    "Govt revenue (% GDP)"
    "Govt demand (% GDP)"
     "Other expenditure (% GDP)"
    "Private inv shock (NKIA Govt, %GDP)"
];

rngTable = qq(2025, 3) : qq(2030, 2);

reportTitle = " Fisc Tunes Comparison Report ";
rprt = report.new(char(reportTitle));
rprt.section('QMFM Tuning Adj.');
rprt.pagebreak; 

rprt = addVariableCharts(rprt, fiscTunes, varNames, varDescr, opts);

tableTitle = 'QMFM Tuning Adj.';
rprt.table(char(tableTitle), 'range', rngTable, 'typeface', '\small', 'long', true, ...
  'vline', rngTable(1) -1);

for i = 1:size(varNames,1)
    rprt.series(char(varDescr(i)), fiscTunes.(varNames(i)));
end

%% FISCAL  "TOFE" GFS 2014 PRESENTATION - detailed TOFE
varNames= [
"ny"
"grev_y"
"gdem_y"
"oexp_y"
"oexp_NL_y"
"oexp_NKIA_y"
"gexp_y"
"def_y"
];

varDescr= [
"GDP (current prices)"
"Govt revenue (% GDP)"
"Govt demand (% GDP)"
"Other expenditure (% GDP)"
"Net Lending"
"Bugesera"
"Govt spending (% GDP)"
"Deficit (excl. grants, % GDP)"
];

reportTitle = " Fisc Tunes Comparison Report ";
rprt = report.new(char(reportTitle));
rprt.section('Fisc ratios orig.');
rprt.pagebreak; 
rprt = addVariableCharts(rprt, fiscTunes, varNames, varDescr, opts);

rngTable = qq(2025, 3) : qq(2030, 2);
tableTitle = 'Fisc ratios orig.';
rprt.table(char(tableTitle), 'range', rngTable, 'typeface', '\small', 'long', true, ...
  'vline', rngTable(1) -1);

for i = 1:size(varNames,1)
    rprt.series(char(varDescr(i)), fiscTunes.(varNames(i)));
end
codes.utils.writeMessage(mfilename + ": fisc tunes comparison report ...");
codes.utils.saveReport(opts, "fiscTuningComparison", rprt);
codes.utils.writeMessage(mfilename + ": fiscTuneComparisonReport" + ": done");
end
function rprt = addVariableCharts(rprt, fiscTunes, varNames, varDescr, opts)

rngPlot = qq(2024, 3) : qq(2030, 2);

style = opts.style;
style.legend.orientation  = "vertical";
style.legend.location     = "best";

cntr = 0;
while ~isempty(varNames)

  nVars = min(6, numel(varNames));
  varNamesCurrPage = varNames(1 : nVars);

  cntr = cntr+1;
  figureTitle = "Observed variables (page " + cntr + ")";

  opts.style.line.marker = '*';
  opts.style.line.markerSize = 4;

  rprt.figure(char(figureTitle), 'range', rngPlot,...
   'style', style, 'zeroline', true, 'subplot', [2, 3]);

  
  c = 0;
  for v = varNamesCurrPage(:)'

      w = find(varNames == v);

      if ~isempty(w)
          varDescrCurr = varDescr(w);
      else
          varDescrCurr = "";
      end

    c = c + 1;
    if c == 0
            rprt.graph(char(varDescrCurr + " [" + v + "]"), 'legend', true);
    else
            rprt.graph(char(varDescrCurr + " [" + v + "]"), 'legend', false);
    end
    rprt.series('', fiscTunes.(v));

  end

  varNames(1 : nVars) = [];
  varDescr(1 : nVars) = [];

end

end