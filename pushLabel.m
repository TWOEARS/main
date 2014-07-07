function handles = pushLabel( handles, l )

if handles.l == 1  &&  l == 1
    handles.onsets = [handles.onsets handles.sStart];
    handles.offsets = [handles.offsets handles.sEnd];
    nTestLen = handles.fs * 0.2;

    offsetsD = handles.sStart - handles.offsets;
    offsetsD(offsetsD <= 0) = [];
    maxOffsetD = max( offsetsD );
    testOnset = max( [1, handles.sStart - maxOffsetD, handles.sStart - nTestLen] );
    d = handles.sStart - testOnset;
    handles.sStack = [handles.sStart - d, min( length( handles.s ), handles.sStart - d + nTestLen ), -1; handles.sStack];

    onsetsD = handles.onsets - handles.sEnd;
    onsetsD(onsetsD <= 0) = [];
    minOnsetD = min( onsetsD );
    testOffset = min( [length( handles.s ), handles.sEnd + minOnsetD, handles.sEnd + nTestLen] );
    d = testOffset - handles.sEnd;
    handles.sStack = [max( 1, handles.sEnd + d - nTestLen ), handles.sEnd + d, -2; handles.sStack];
end
if handles.l < 0  &&  l < 0
    i = 1;
    while i <= length( handles.onsets )
        if handles.onsets(i) < handles.sStart  &&  handles.offsets(i) > handles.sEnd
            handles.onsets = [handles.onsets handles.sEnd];
            handles.offsets = [handles.offsets handles.offsets(i)];
            handles.offsets(i) = handles.sStart;
        elseif handles.onsets(i) < handles.sEnd  &&  handles.offsets(i) > handles.sEnd
            handles.onsets(i) = handles.sEnd;
        elseif handles.onsets(i) < handles.sStart  &&  handles.offsets(i) > handles.sStart
            handles.offsets(i) = handles.sStart;
        elseif handles.onsets(i) > handles.sStart  &&  handles.offsets(i) < handles.sEnd
            handles.onsets(i) = [];
            handles.offsets(i) = [];
            i = i - 1;
        end
        i = i + 1;
    end
    d = handles.sEnd - handles.sStart;
    nShift = 0.05 * handles.fs;
    if handles.l == -1
        handles.sStack = [handles.sStart, handles.sStart + d + nShift, -1; handles.sStack];
    end
    if handles.l == -2
        handles.sStack = [handles.sEnd - d - nShift, handles.sEnd, -2; handles.sStack];
    end
end
handles.onsets = sort( handles.onsets );
handles.offsets = sort( handles.offsets );
i = 2;
while i <= length( handles.onsets )
    if handles.onsets(i) <= handles.offsets(i-1) + 1
        handles.offsets(i-1) = handles.offsets(i);
        handles.onsets(i) = [];
        handles.offsets(i) = [];
    else
        i = i + 1;
    end
end

guidata( handles.labelingGuiFig, handles );
plotSound( handles.labelingGuiFig );
tout = [sprintf( 'onsets: %s\n', mat2str( double(int64(100*(handles.onsets ./ handles.fs)))/100 ) ),  sprintf( 'offsets: %s\n', mat2str( double(int64(100*(handles.offsets ./ handles.fs)))/100 ) )];
set( handles.textfield, 'String', tout );
