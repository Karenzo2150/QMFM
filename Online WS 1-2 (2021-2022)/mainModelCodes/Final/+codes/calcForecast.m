function calcForecast(scenarios)

opts  = mainSettings();
optsF = opts.forecast;

cln = onCleanup(@(x) cleanupFun(opts));

if nargin < 2
  scenarios = optsF.scenarioNames;
end

scenNum = length(scenarios);

codes.writeMessage("calcForecast: loading model and data");

% Load model
tmp = codes.loadResult(opts, "model");
M   = tmp.m(1);

% Load filtered data
tmp     = codes.loadResult(opts, "filter");
dbFilt  = dbcol(tmp.dbFilt.mean,1);

% Load auxiliary data
tmp     = codes.loadResult(opts, "data");
dbAux   = tmp.dbAux;


% %Create groups for shock decomposition
% g = grouping(m, 'Shocks');
% for i = 1:length(opts.shock_decomp_shocks)
%   g = addgroup(g, opts.shock_decomp_groups{i}, opts.shock_decomp_shocks{i});
% end

% Calculate forecast for all scenarios

for i = 1 : scenNum
  
  codes.writeMessage(...
    "calcForecast: scenario " + scenarios(i) + ": setting tunes ..." ...
    );
  
  % Set tunes and simulation plan
  cd(fullfile(opts.mainDir, "tunes"))
  tuneFuncName  = scenarios(i);
  [dbTunesi, plni, mi]  = feval(tuneFuncName, opts, M);
  dbInit = dboverlay(dbFilt, dbTunesi);
  cd(opts.mainDir)
  
  % Solve the (possibly modified) forecast model
  mi = sstate(mi, "Display", false);
  chksstate(mi);
  mi = solve(mi);
  
  codes.writeMessage(...
    "calcForecast: scenario " + scenarios(i) + ": calculating forecast ..." ...
    );
  
  % Run the forecast, overlay historical data
  dbFcasti = simulate(mi, dbInit, optsF.range, 'Plan', plni);
  dbFcasti = dboverlay(dbInit, dbFcasti);
  
  % Evaluate the auxiliary model (in reporting equations)
  dbFcasti    = dbmerge(dbFcasti, dbAux);
  dbAuxFcast  = reporting(mi, dbFcasti, optsF.range);
  dbFcasti    = dboverlay(dbFcasti, dbAuxFcast);
  
  %   msg = write_message([...
  %     'calcForecast: scenario ', ...
  %     scenarios{i}, ...
  %     ': calculating shock decomposition ...' ...
  %     ], msg);
  %
  %   % Shock decomposition step 1: flip all transition shocks
  %   enames = get(m,'elist')'; % Shock names
  %   ind0 = cellfun(@isempty,regexp(enames,'0$')); % Indices of those shock names that do not end with a 0, i.e. are not measurement shocks
  %   enames = enames(ind0); % Remove measurement shocks
  %   xenames = strrep(enames,'EPS_',''); % Names of corresponding transition variables (by removing EPS_ from the beginning)
  %   decomp_range = opts.history_range(1):opts.forecast_range(end); % Need to run decomposition on while range due to different models
  %   pln_dec = plan(m,decomp_range);
  %   for j = 1:length(xenames)
  %     pln_dec = endogenize(pln_dec,decomp_range, enames{j});
  %     pln_dec =  exogenize(pln_dec,decomp_range,xenames{j});
  %   end
  %
  %   % Shock decomposition step 2: run two simulations on the full range to
  %   % find surprise/anticipated shocks that reproduce the history/forecast
  %   hist_shocks_db  = simulate(m_hist,fcast_db.mean,decomp_range,'plan',pln_dec,'anticipate',false);
  %   fcast_shocks_db = simulate(m,     fcast_db.mean,decomp_range,'plan',pln_dec,'anticipate',opts.anticipation);
  %
  %   % Shock decomposition step 3: run the same simuations without the plan to
  %   % decompose
  %   hist_decomp_db  = simulate(m_hist,hist_shocks_db, decomp_range,'contributions',true,'anticipate',false);
  %   fcast_decomp_db = simulate(m,     fcast_shocks_db,decomp_range,'contributions',true,'anticipate',opts.anticipation);
  %
  %   % Shock decomposition step 4: combine to decompositions of
  %   % history/forecast
  %   shock_decomp_db = dboverlay(dbclip(hist_decomp_db,opts.history_range), dbclip(fcast_decomp_db,opts.forecast_range));
  %
  %   % Group shocks
  %   shock_contrib_db = eval(g,shock_decomp_db);
  
  codes.writeMessage(...
    "calcForecast: scenario " + scenarios(i) + ": saving results ..." ...
    );
  
  % Write results to csv
  fileName = fullfile(opts.mainDir, "results", "forecast" + scenarios(i) + ".csv");
  if codes.checkFile(fileName)
    databank.toCSV(dbFcasti, fileName, 'Class', false, 'NaN', '', 'Format', '%.16f');
  end
  
  %   fileName = [opts.main_dir,'\results\shock_decomp_',scenarios{i},'.csv'];
  %   if check_file(fileName)
  %     dbsave(shock_contrib_db,fileName,'class',false,'nan','','format','%.16f');
  %   end
  
  if i == 1
    
    m       = mi;
    dbFcast = dbFcasti;
    dbTunes = {dbTunesi};
    pln     = {plni};
    
  else
    
    m       = [m, mi];
    dbFcast = dbFcast & dbFcasti;
    dbTunes = [dbTunes, {dbTunesi}];
    pln     = [pln, {plni}];
    
  end
  
end

% Save results to mat file
fileName = fullfile(opts.mainDir, "results", "forecast.mat");
save(fileName, "m", "pln", "dbTunes", "dbFcast")

codes.writeMessage("calcForecast: done.");

end

function cleanupFun(opts)

cd(opts.mainDir)

end