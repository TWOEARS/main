function saveOnoffs( handles )

contents = cellstr( get( handles.soundsList, 'String' ) );
selectedSound = regexprep( contents{get( handles.soundsList, 'Value' ) }, '<html><b>', '' );
selectedSound = regexprep( selectedSound, '</b></html>', '' );
labelFileName = [handles.soundsDir '\' selectedSound '.txt'];

annotFid = fopen( labelFileName, 'w' );
if annotFid ~= -1
    for i = 1:length( handles.onsetsInterp )
        onset = handles.onsetsInterp(i) / handles.fs;
        offset = handles.offsetsInterp(i) / handles.fs;
        fprintf( annotFid, '%f\t%f\n', onset, offset );
    end
    fclose( annotFid );
end

updateSoundsList( handles );