function handles = cleanOnOffsets( handles )

if ~isempty( handles.onsets )
    handles.onsets{end} = sort( handles.onsets{end} );
    handles.offsets{end} = sort( handles.offsets{end} );
    i = 2;
    while i <= length( handles.onsets{end} )
        if handles.onsets{end}(i) <= handles.offsets{end}(i-1) + 1
            handles.offsets{end}(i-1) = handles.offsets{end}(i);
            handles.onsets{end}(i) = [];
            handles.offsets{end}(i) = [];
        else
            i = i + 1;
        end
    end
    
    [levelsInterp, interpFsFactor] = onoffInterp( handles.onsets, handles.offsets, handles );
    lmin = 1 / 2;
    levelsInterp(levelsInterp < lmin) = 0;
    levelsInterp(levelsInterp >= lmin) = 1;
    levelsInterpDelta = [levelsInterp, 0] - [0, levelsInterp];
    handles.onsetsInterp = find( levelsInterpDelta == +1 ) .* interpFsFactor;
    handles.offsetsInterp = find( levelsInterpDelta == -1 ) .* interpFsFactor;
else
    handles.onsetsInterp = [];
    handles.offsetsInterp = [];
end
