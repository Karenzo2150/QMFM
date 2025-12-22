function filterHistory

opts = mainSettings();

cln = onCleanup(@(x) cleanupFun(opts));

codes.writeMessage("filterHistory: loading model ...");

optsFH = opts.filterHistory;

% Load model
tmp = codes.loadResult(opts, "model");
m = tmp.m;

codes.writeMessage("filterHistory: loading data ...");

% Load observed data
tmp = codes.loadResult(opts, "data");
dbObs = tmp.dbObs;

codes.writeMessage("filterHistory: setting historical tunes ...");

% Predefine historical tune-s
ynames  = get(m, "ynames");
ind     = ~cellfun(@isempty,regexp(ynames, "^tune_"));
tnames  = ynames(ind);
for i = 1:length(tnames)
  dbObs.(tnames{i}) = tseries();
end

% Set historical tunes
cd(fullfile(opts.mainDir, "tunes"))
dbObs = Historical(dbObs);
cd(opts.mainDir)

% Run smoother
codes.writeMessage("filterHistory: running filtration ...");
[~, dbFilt] = filter(m, dbObs, optsFH.range, "relative", false);

% Run shock decomposition

codes.writeMessage("filterHistory: running shock decomposition ...");

for i = 1:prod(size(m)) %#ok<PSIZE> % IRIS will not do the decomposition with multiple parametrizations
  
    dbSim = simulate(m(i), dbcol(dbFilt.mean,i), optsFH.range, ...
      "Contributions", true, "Anticipate", false);

    %Create groups for shock decomposition
    g = grouping(m, 'Shocks');
    groupNames = fieldnames(optsFH.shockDecompGroups);
    for gn = groupNames(1:end-1)'
      g = addgroup(g, gn{:}, cellstr(optsFH.shockDecompGroups.(gn{:})));
    end
    dbContr(i) = eval(g, dbSim); %#ok<AGROW>
    
end    

codes.writeMessage("filterHistory: saving results ...");

% Save results
fileName = fullfile(opts.mainDir, "results", "filter.mat");
save(fileName, "dbObs", "dbFilt", "dbContr")

codes.writeMessage("filterHistory: done.");

end

function cleanupFun(opts)

cd(opts.mainDir)

end