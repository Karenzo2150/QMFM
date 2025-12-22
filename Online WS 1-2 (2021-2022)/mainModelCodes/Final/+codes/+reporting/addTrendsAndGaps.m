function rprt = addTrendsAndGaps(opts, rprt, m, db, dbObs, range, legends)

xnamesAll = string(get(m, "xnames"));
xdescrAll = string(get(m, "xdescript"));

rprt.section('Trends and gaps');
rprt.pagebreak;

legend_t = legends + " tnd";
legend_g = legends + " gap";

legendState = length(legends) > 1;

for i = 1:length(opts.filterHistory.trendGapVars)
  
  name  = opts.filterHistory.trendGapVars{i};
  
  gname = name + "_gap";
  tname = name + "_tnd";
  
  figureTitle = xdescrAll(strcmp(name,xnamesAll)) + " [" + name + "]";
  rprt.figure(char(figureTitle), 'style', opts.style, 'subplot', [2 2]);
  
  if isfield(db, tname)
    
    rprt.graph('Level', 'legend', legendState, 'range', range);
    rprt.series('', db.(tname), 'legendentry', cellstr(legend_t));
    rprt.series('Observed', dbObs.("obs_" + name));
    
  end
  
  if isfield(db, gname)
    
    rprt.graph('Gap', 'legend', legendState, 'range', range);
    rprt.series('Gap', db.(gname), 'legendentry', cellstr(legend_g));
    
  end
  
  if isfield(db, "d" + name)
    
    rprt.graph('Quarterly change (annualized)', 'legend', legendState, 'range', range);
    rprt.series('', db.("d" + tname), 'legendentry', cellstr(legend_t));
    rprt.series('Observed', dbObs.("obs_" + "d" + name));
    
  end
  
  if isfield(db, "d4" + name)
    
    rprt.graph('Yearly change', 'legend', legendState, 'range', range);
    rprt.series('', db.("d4" + tname), 'legendentry', cellstr(legend_t));
    rprt.series('Observed', dbObs.("obs_" + "d4" + name));
    
  end
  
end

% Trend of inflation is "_tar"

name  = "l_cpi";
tname = "l_cpi_tar";

figureTitle = xdescrAll(strcmp(name,xnamesAll)) + " [" + name + "]";
rprt.figure(char(figureTitle), 'style', opts.style, 'subplot', [2 2]);

rprt.graph('Yearly change', 'legend', legendState, 'range', range);
rprt.series('', db.("d4" + tname), 'legendentry', cellstr(legend_t));
rprt.series('Observed', dbObs.("obs_" + "d4" + name));

end