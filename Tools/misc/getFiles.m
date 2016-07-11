function fileList = getFiles( folder, extension )
% GETFILES Returns a cell-array, containing a list of files with a
%   specified extension.
%
% REQUIRED INPUTS:
%    folder - Absolute or relative path to the folder that should be
%       processed.
%    extension - Required file extension specified as a string, e.g. 'wav'.
%
% OUTPUTS:
%    fileList - List of files as a cell-array.
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

p.addRequired( 'Folder', @isdir );
p.addRequired( 'Extension', @ischar );

parse( p, folder, extension );

% Get all files in folder
fileList = dir( fullfile(p.Results.Folder, ['*.', p.Results.Extension]) );

% Return cell-array of filenames
fileList = {fileList(:).name};

% Check if files were found
if isempty( fileList )
    warning( [p.Results.Folder, ' does not contain any files with ', ...
        'extension ', extension, '.'] );
end

end