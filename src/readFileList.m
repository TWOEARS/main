function [fileNames,nFiles] = readFileList(fileList)
% READFILELIST returns a cell array containing filenames
%
% Usage: [fileNames,nFiles] = readFileList(fileList)
%
% readFileList(fileList) returns a cell containing all the files stort in the
% file fileList. A filList can be created under Linux the following way. Assume
% we want to have all files in the subdir "training1" listed in the fileList
% "training1.flist", then run:
% $ ls training1/* > training1.flist

% TODO: expand this function to handle more than one given file list.

% AUTHOR: Hagen Wierstorf

% Checking of input parameters
narginchk(1,1);

% Reading the file list
import xml.*
fileList = fullfile(xml.dbPath, fileList);
[fileListPath,~,~] = fileparts(fileList);
fid = fopen(fileList);
tmp = textscan(fid, '%s');
fileNames = strcat(fileListPath,filesep,tmp{1});
nFiles = length(fileNames);

% Clean up
fclose(fid);
clear tmp;
