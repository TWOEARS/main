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
                handles.onsets{1} = [handles.onsets{1} (onsetOffset(1) * handles.fs)];
                handles.offsets{1} = [handles.offsets{1} (onsetOffset(2) * handles.fs)];
            end
            handles = changePhaseTo( 4, handles );
        case 'No'
            handles = changePhaseTo( 1, handles );
    end
    fclose( annotFid );
end

