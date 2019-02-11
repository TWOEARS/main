function mpath = getMFilePath()

ST = dbstack( 1, '-completenames' );
if isempty( ST )
    error( 'Function only works if called from an m-file.' );
end
mFileName = strtok( ST(1).name, '.' );
mFilePath = ST(1).file;
nIgnoreChars = length( mFileName ) + 3;
mpath = mFilePath(1:end-nIgnoreChars);