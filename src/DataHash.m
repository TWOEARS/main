function H = DataHash(Data, maxRecursionLevel)
if ~exist( 'maxRecursionLevel', 'var' ), maxRecursionLevel = 10; end;
Engine = java.security.MessageDigest.getInstance('MD5');
H = CoreHash(Data, Engine, 0, maxRecursionLevel);
H = sprintf('%.2x', H);   % To hex string

function H = CoreHash(Data, Engine, recursionLevel, maxRecursionLevel )

% Consider the type of empty arrays:
S = [class(Data), sprintf('%d ', size(Data))];
Engine.update(typecast(uint16(S(:)), 'uint8'));
H = double(typecast(Engine.digest, 'uint8'));

if recursionLevel > maxRecursionLevel, return; end;

if isa(Data, 'struct')
   n = numel(Data);
   if n == 1  % Scalar struct:
      F = sort(fieldnames(Data));  % ignore order of fields
      for iField = 1:length(F)
         H = bitxor(H, CoreHash(Data.(F{iField}), Engine, recursionLevel + 1, maxRecursionLevel));
      end
   else  % Struct array:
      for iS = 1:n
         H = bitxor(H, CoreHash(Data(iS), Engine, recursionLevel + 1, maxRecursionLevel));
      end
   end
elseif isempty(Data)
   % No further actions needed
elseif isnumeric(Data)
   if ~isreal(Data)
       Data = [real(Data), imag(Data)];
   end
   Engine.update(typecast(Data(:), 'uint8'));
   H = bitxor(H, double(typecast(Engine.digest, 'uint8')));
elseif ischar(Data)  % Silly TYPECAST cannot handle CHAR
   Engine.update(typecast(uint16(Data(:)), 'uint8'));
   H = bitxor(H, double(typecast(Engine.digest, 'uint8')));
elseif iscell(Data)
   for iS = 1:numel(Data)
      H = bitxor(H, CoreHash(Data{iS}, Engine, recursionLevel + 1, maxRecursionLevel));
   end
elseif islogical(Data)
   Engine.update(typecast(uint8(Data(:)), 'uint8'));
   H = bitxor(H, double(typecast(Engine.digest, 'uint8')));
elseif isa(Data, 'function_handle')
   H = bitxor(H, CoreHash(functions(Data), Engine, recursionLevel + 1, maxRecursionLevel));
elseif isobject(Data)
   for p = properties(Data)'
      H = bitxor(H, CoreHash({Data.(p{1})}, Engine, recursionLevel + 1, maxRecursionLevel));
   end
else
   warning(['Type of variable not considered: ', class(Data)]);
end
