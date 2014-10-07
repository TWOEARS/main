
% This script initialises the path variables that are needed for running
% the Tools code.

basepath = fileparts(mfilename('fullpath'));

% Add all relevant folders to the matlab search path
addpath(fullfile(basepath, 'src'));
addpath(fullfile(basepath, 'src', filesep, 'args'));

clear basepath;
