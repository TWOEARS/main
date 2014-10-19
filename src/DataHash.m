function hash = DataHash( data, maxRecursionLevel )

if ~exist( 'maxRecursionLevel', 'var' ), maxRecursionLevel = 10; end;
Engine = java.security.MessageDigest.getInstance( 'MD5' );
hash = CoreHash( data, Engine, 0, maxRecursionLevel );
hash = sprintf( '%.2x', hash );   % To hex string

end

function hash = CoreHash( data, Engine, recursionLevel, maxRecursionLevel )

% Consider the type of empty arrays:
S = [class(data), sprintf('%d ', size(data))];
Engine.update(typecast(uint16(S(:)), 'uint8'));
hash = double(typecast(Engine.digest, 'uint8'));

if recursionLevel > maxRecursionLevel, return; end;

if isa( data, 'struct' )
    n = numel(data);
    if n == 1  % Scalar struct:
        F = sort(fieldnames(data));  % ignore order of fields
        for iField = 1:length(F)
            hash = bitxor(hash, CoreHash(data.(F{iField}), Engine, recursionLevel + 1, maxRecursionLevel));
        end
    else  % Struct array:
        for iS = 1:n
            hash = bitxor(hash, CoreHash(data(iS), Engine, recursionLevel + 1, maxRecursionLevel));
        end
    end
elseif isempty( data )
    % No further actions needed
elseif isnumeric( data )
    if ~isreal( data )
        data = [real(data), imag(data)];
    end
    Engine.update(typecast(data(:), 'uint8'));
    hash = bitxor(hash, double(typecast(Engine.digest, 'uint8')));
elseif ischar( data )  % Silly TYPECAST cannot handle CHAR
    Engine.update(typecast(uint16(data(:)), 'uint8'));
    hash = bitxor(hash, double(typecast(Engine.digest, 'uint8')));
elseif iscell( data )
    for iS = 1:numel(data)
        hash = bitxor(hash, CoreHash(data{iS}, Engine, recursionLevel + 1, maxRecursionLevel));
    end
elseif islogical( data )
    Engine.update(typecast(uint8(data(:)), 'uint8'));
    hash = bitxor(hash, double(typecast(Engine.digest, 'uint8')));
elseif isa( data, 'function_handle' )
    hash = bitxor(hash, CoreHash(functions(data), Engine, recursionLevel + 1, maxRecursionLevel));
elseif isa( data, 'Hashable' )
    for ii = 1:numel( data )
        hash = bitxor( hash, CoreHash( data(ii).getHashObjects(), Engine, recursionLevel + 1, maxRecursionLevel ) );
    end
elseif isobject( data )
    for ii = 1:numel( data )
        mcdata = metaclass( data(ii) );
        propsData = mcdata.PropertyList;
        warning off MATLAB:structOnObject
        propsStruct = struct( data(ii) );
        warning on MATLAB:structOnObject
        pNames = sort( {propsData.Name} );
        for pname = pNames
            p = propsData(strcmp( {propsData.Name}, pname{1} ));
            if p.Transient, continue; end
            if ~isfield( propsStruct, p.Name ), continue; end
            hash = bitxor(hash, CoreHash(propsStruct.(p.Name), Engine, recursionLevel + 1, maxRecursionLevel));
        end
    end
else
    warning( ['Type of variable not considered: ', class(data)] );
end

end