function d = compressAndScale( d, compressor, scalor, dim )
%compressAndScale   This function will compress and scale matrix d.
%                   First the compression takes place as 
%                       d = sign(d) .* abs(d).^compressor,
%                   Then scaling is applied individually to slices across 
%                   dimension dim, determining the scale with the function
%                   scalor.
%
%   USAGE
%       d = compressAndScale( d, compressor, scalor, dim )
%
%   INPUT PARAMETERS
%                   d   -   a numerical matrix
%         [compressor]  -   positive value (default = 1)
%             [scalor]  -   a function handle of a function that gets as input 
%                           a numerical vector and returns the value that shall
%                           be scaled to 0.5 (default = @(x)(0.5))
%                [dim]  -   index of dimension across which the matrix d is
%                           sliced. Put 0 to apply to matrix d as a whole.
%                           (default = 0)
%
%   OUTPUT PARAMETERS
%                   d   -   compressed and scaled matrix d
%
% author: Ivo Trowitzch, TU Berlin

if nargin < 2
    compressor = 1;
end
if nargin < 3
    scalor = @(x)(0.5);
end
if nargin < 4
    dim = 0;
end
d = sign(d) .* abs(d).^compressor;
dparts = {};
if dim == 0
    dparts{end+1} = d;
else
    for ii = 1 : size( d, dim )
        inds = repmat( {':'}, 1, ndims(d) );
        inds{dim} = ii;
        dparts{end+1} = d(inds{:});
    end
end
for ii = 1 : numel( dparts )
    dScalor = scalor( dparts{ii}(:) );
    if isnan( dScalor ), scale = 1;
    else scale = 0.5 / dScalor; end;
    dparts{ii} = dparts{ii} .* repmat( scale, size( dparts{ii} ) );
end
if dim == 0
    d = dparts{1};
else
    d = cat( dim, dparts{:} );
end

end
