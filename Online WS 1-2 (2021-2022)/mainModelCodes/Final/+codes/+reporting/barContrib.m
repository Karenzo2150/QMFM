function rprt = barContrib(rprt, range, decompSeries, decompContribs, figureName, legendEntries, colorMap)

difi = max(abs(sum(decompContribs{range}, 2) - decompSeries{range}));
if difi > 1e-4
  warning("Contributions don't add up to total for %s; max. abs. discr: %0.2e", ...
    figureName, difi)
end

rprt.graph(char(figureName), 'range', range, 'xlabel', ' ', 'legend', true, 'ColorMap', colorMap);
rprt.series('', decompContribs, 'plotFunc', @barcon, 'legendEntry', cellstr(legendEntries));
rprt.series('', decompSeries, 'legendEntry', NaN); % Background (white)
rprt.series('', decompSeries, 'legendEntry', NaN); % Foreground

end