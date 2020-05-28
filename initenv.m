modules = {'utilities', 'cm_and_cb_utilities', 'minFunc_2012', 'adawhatever', 'HDR_Toolbox'};

for i=1:numel(modules)
    addpath(genpath(fullfile('~/Matlab/', sprintf('%s/', modules{i}))));
end
addpath(genpath('.'));

initglobals
% set(0,'DefaultFigureColormap',viridis)