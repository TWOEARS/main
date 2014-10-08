% This script initialises the path variables that are needed for running
% the Tools code.

basepath = fileparts(mfilename('fullpath'));
basepath = [basepath filesep];

% Add all relevant folders to the matlab search path
addpath(fullfile(basepath, 'args'));

clear basepath;
