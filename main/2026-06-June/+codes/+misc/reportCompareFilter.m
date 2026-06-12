function reportCompareFilter
% codes.reportCompareData() compares the current and previous filtered/estimated data.
%
% run: codes.misc.reportCompareFilter()
%
% codes.reportCompareFilter loads the current and comparison filter data,
% and creates a PDF report showing the series side-by-side in charts. The

% Relevant options are:
% - opts.compRound:   path to the comparison round folder (within the main
%                     QMFM folder)
%
% The PDF report is saved as opts.resultsDirPdf/FilterCompareReport.pdf

optsCurr = mainSettings();
optsComp = optsCurr.compOpts;

tmp_curr = codes.utils.loadResult(optsCurr, "filter");
% tmp_comp = codes.utils.loadResult(optsComp, "filter");
tmp_comp = codes.utils.loadResult(optsCurr, "filterComp");

tmp = codes.utils.loadResult(optsCurr, "model");
m = tmp.m;

legends = [optsComp.roundId, optsCurr.roundId];

descr = get(m, "descript");

% ------------- Create the report -------------

reportTitle = "Filter comparison report: 'Trend and Gaps, level'";
rprt = report.new(char(reportTitle));

% -------- Compare filter data --------

%rprt.section('Trend and Gaps, level');
% rprt.pagebreak;

db_curr = tmp_curr.dbFilt.mean;
db_comp = tmp_comp.dbFilt.mean;

fields = {'l_cons_tnd', 'l_cons_gap', 'l_inv_tnd','l_inv_gap','l_gdem_tnd','l_gdem_gap',...
    'l_exp_gap', 'l_exp_tnd', 'l_imp_gap', 'l_imp_tnd','l_y_gap', 'l_y_tnd', 'l_y_agr_tnd',...
    'l_y_agr_gap', 'l_z_tnd', 'l_z_gap', 'l_rp_cpi_core_tnd', 'l_rp_cpi_core_gap',... 
    'l_rp_cpi_food_tnd', 'l_rp_cpi_food_gap', 'l_rp_cpi_ener_tnd', 'l_rp_cpi_ener_gap', 'i_tnd',...
    'def_y_str', 'gdem_y_str', 'oexp_y_str', 'grev_y_str'};

db_curr_set = rmfield(db_curr, setdiff(fieldnames(db_curr), fields));
db_comp_set = rmfield(db_comp, setdiff(fieldnames(db_comp), fields));

names_curr = fieldnames(db_curr_set);
names_comp = fieldnames(db_comp_set);

% ----- Removed / added variables -----
% rprt.array('Added observation variables', ...
%   setdiff(names_curr, names_comp) ...
%   );
% 
% rprt.array('Removed observation variables', ...
%   setdiff(names_comp, names_curr) ...
%   );

% ----- Plot common variables -----

dbCompFilt = databank.merge("horzcat", db_comp_set, db_curr_set);

varNames = string(intersect(names_curr, names_comp, "stable"));

rprt = addVariableCharts(rprt, dbCompFilt, varNames, legends, descr, optsCurr);

% ------------- Publish report -------------

codes.utils.writeMessage(mfilename + ": Compiling filter comparison report ...");
codes.utils.saveReport(optsCurr, "FilterComparisonReport", rprt);

% ------------- Save the merged databases -------------

codes.utils.writeMessage(mfilename + ": saving results ...");
codes.utils.saveResult(optsCurr, "filtComp", "dbCompFilt");
codes.utils.writeMessage(mfilename + ": done.");

end

function rprt = addVariableCharts(rprt, db, varNames, legends, descr, opts)

style = opts.style;
style.legend.orientation  = "vertical";
style.legend.location     = "best";

cntr = 0;
while ~isempty(varNames)

  nVars = min(6, numel(varNames));
  varNamesCurrPage = varNames(1 : nVars);

  cntr = cntr + 1;
  figureTitle = "Observed variables (page " + cntr + ")";

  opts.style.line.marker = '*';
  opts.style.line.markerSize = 4;

  rprt.figure(char(figureTitle), 'range', opts.filterHistory.range, ...
    'style', style, 'zeroline', true, 'subplot', [2, 3]);

  c = 0;
  for v = varNamesCurrPage(:)'

    if ~isempty(descr)
      varDescr  = descr.(v);
    else
      varDescr = "";
    end

    c = c + 1;
    if c == 1
      rprt.graph(char(varDescr + " [" + v + "]"), 'legend', true);
    else
      rprt.graph(char(varDescr + " [" + v + "]"), 'legend', false);
    end

    rprt.series('', db.(v), 'LegendEntry', cellstr(legends));

  end

  varNames(1 : nVars) = [];

end

end