function readModel(paramFiles)

opts = mainSettings();

cln = onCleanup(@(x) cleanupFun(opts));

if nargin < 1
  paramFiles = opts.parameterNames;
end

codes.writeMessage("readModel: reading model file ...");

paramNum = numel(paramFiles);

m = Model(opts.modelFile, ...
  "Linear", false, ...
  "Growth", true ...
  );
m = alter(m, paramNum); 

modelDir = fullfile(opts.mainDir, "model");

cd(modelDir)
for i = 1:length(paramFiles)
  
  [filePath, fileName] = fileparts(paramFiles(i));
  if filePath ~= ""
    cd(filePath)
  end
  
  eval("p = " + fileName + ";")
  m(i) = assign(m(i), p);
  m(i) = refresh(m(i));
  
  if filePath ~= ""
    cd(modelDir)
  end
  
end
cd(opts.mainDir)

codes.writeMessage("readModel: solving the model ...");

m = sstate(m, "Display", false);
chksstate(m);
m = solve(m);

codes.writeMessage("readModel: saving results ...");

fileName = fullfile(opts.mainDir, "results", "model.mat");
save(fileName, "m")

codes.writeMessage("readModel: done.");

end

function cleanupFun(opts)

cd(opts.mainDir)

end