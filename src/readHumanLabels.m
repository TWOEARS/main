function [humanLabels, stats] = readHumanLabels(labelFile)
% readHumanLabels returns a cell array containing filenames and human labels
%
% Usage: [fileNames,nFiles] = readHumanLabels(labelFile)
%
% readFileList(fileList) returns a cell containing all the files stored in the
% file fileList. A fileList can be created under Linux the following way. Assume
% we want to have all files in the subdir "sound_databases/database1/training1"
% listed in the fileList "training1.flist", then run:
% $ ls -d -1 sound_databases/database1/training1/**/* > training1.flist
% Note, that you always have to start with a path at the root of the Two!Ears
% data repository.
%
% Dependency: Two!Ears Binaural Simulator

% TODO: expand this function to handle more than one given file list.

% AUTHOR: Hagen Wierstorf

% Checking of input parameters
narginchk(1,1);

% Get labelFile
labelFile = xml.dbGetFile(labelFile);
% Use readtext to get entries fron file
[humanLabels, stats]= readtext(labelFile, ',', '#', '{}', '');

% vim: set sw=4 ts=4 expandtab textwidth=90 :
