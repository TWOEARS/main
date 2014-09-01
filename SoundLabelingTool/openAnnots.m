function handles = openAnnots( handles )

contents = cellstr( get( handles.soundsList, 'String' ) );
selectedSound = regexprep( contents{get( handles.soundsList, 'Value' ) }, '<html><b>', '' );
selectedSound = regexprep( selectedSound, '</b></html>', '' );
labelFileName = [handles.soundsDir '\' selectedSound '.txt'];

annotFid = fopen( labelFileName );
if annotFid ~= -1
    openOrNot = questdlg( 'Use label times from available annotation file?', ...
        'Available Annotation File', ...
        'Yes', 'No', 'Yes' );
    switch openOrNot
        case 'Yes'
            if isempty( handles.onsets )
                handles.onsets{1} = [];
                handles.offsets{1} = [];
            end
            while 1
                annotLine = fgetl( annotFid );
                if ~ischar( annotLine ), break, end
                onsetOffset = sscanf( annotLine, '%f' );
                handles.onsets{1} = [handles.onsets{1} floor(onsetOffset(1) * handles.fs)];
                handles.offsets{1} = [handles.offsets{1} floor(onsetOffset(2) * handles.fs)];
            end
            handles = cleanOnOffsets( handles );
            handles.savedOnsets = handles.onsetsInterp;
            handles.savedOffsets = handles.offsetsInterp;
    end
    fclose( annotFid );
end

