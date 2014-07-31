function handles = saveOnoffs( handles )

if isequal( handles.savedOnsets, handles.onsetsInterp ) || isequal( handles.savedOffsets, handles.offsetsInterp )
    return;
end

selectedSound = handles.soundfile;
labelFileName = [handles.soundsDir '\' selectedSound '.txt'];

annotFid = fopen( labelFileName, 'w' );
if annotFid ~= -1
    for i = 1:length( handles.onsetsInterp )
        onset = handles.onsetsInterp(i) / handles.fs;
        offset = handles.offsetsInterp(i) / handles.fs;
        fprintf( annotFid, '%f\t%f\n', onset, offset );
    end
    fclose( annotFid );
    handles.savedOnsets = handles.onsetsInterp;
    handles.savedOffsets = handles.offsetsInterp;
end

updateSoundsList( handles );