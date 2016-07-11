function subfolderList = getSubfolders( folder )
% GETSUBFOLDERS Returns a cell-array, containing a list of all subfolders
%   within a directory.
%
% REQUIRED INPUTS:
%    folder - Absolute or relative path to the folder that should be
%       processed.
%
% OUTPUTS:
%    subfolderList - List of subfolders as a cell-array.
%
% AUTHOR:
%   Copyright (c) 2016      Christopher Schymura
%                           Cognitive Signal Processing Group
%                           Ruhr-Universitaet Bochum
%                           Universitaetsstr. 150
%                           44801 Bochum, Germany
%                           E-Mail: christopher.schymura@rub.de
%
% LICENSE INFORMATION:
%   This program is free software: you can redistribute it and/or
%   modify it under the terms of the GNU General Public License as
%   published by the Free Software Foundation, either version 3 of the
%   License, or (at your option) any later version.
%
%   This material is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with this program. If not, see <http://www.gnu.org/licenses/>

% Initialize input parser and process function arguments
p = inputParser();

p.addRequired('Folder', @isdir);

parse(p, folder);

% Check if folder exists
if ~isdir( p.Results.Folder )
    error( [p.Results.Folder, ' not found.'] );
end

% Get class folder names
subFolders = dir( p.Results.Folder );
folderIdx = [subFolders(:).isdir];
subfolderList = {subFolders(folderIdx).name};

% Remove unimportant entries
subfolderList( ismember(subfolderList, {'.', '..'}) ) = [];

end