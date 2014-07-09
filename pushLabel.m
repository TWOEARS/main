function handles = pushLabel( handles, l )

onoffsChanged = false;

if handles.l == 1  &&  l == 1
    onoffsChanged = true;
    handles.onsets{end} = [handles.onsets{end} handles.sStart];
    handles.offsets{end} = [handles.offsets{end} handles.sEnd];
    nTestLen = floor( handles.fs * handles.minBlockLen );
    
    offsetsD = handles.sStart - handles.offsets{end};
    offsetsD(offsetsD <= 0) = [];
    maxOffsetD = max( offsetsD );
    testOnset = max( [1, handles.sStart - maxOffsetD, handles.sStart - nTestLen] );
    d = handles.sStart - testOnset;
    handles.sStack = [handles.sStart - d, min( length( handles.s ), handles.sStart - d + nTestLen ), -1; handles.sStack];
    
    onsetsD = handles.onsets{end} - handles.sEnd;
    onsetsD(onsetsD <= 0) = [];
    minOnsetD = min( onsetsD );
    testOffset = min( [length( handles.s ), handles.sEnd + minOnsetD, handles.sEnd + nTestLen] );
    d = testOffset - handles.sEnd;
    handles.sStack = [max( 1, handles.sEnd + d - nTestLen ), handles.sEnd + d, -2; handles.sStack];
end
if handles.l < 0  &&  l < 0
    onoffsChanged = true;
    i = 1;
    while i <= length( handles.onsets{end} )
        if handles.onsets{end}(i) < handles.sStart  &&  handles.offsets{end}(i) > handles.sEnd
            handles.onsets{end} = [handles.onsets{end} handles.sEnd];
            handles.offsets{end} = [handles.offsets{end} handles.offsets{end}(i)];
            handles.offsets{end}(i) = handles.sStart;
        elseif handles.onsets{end}(i) < handles.sEnd  &&  handles.offsets{end}(i) > handles.sEnd
            handles.onsets{end}(i) = handles.sEnd;
        elseif handles.onsets{end}(i) < handles.sStart  &&  handles.offsets{end}(i) > handles.sStart
            handles.offsets{end}(i) = handles.sStart;
        elseif handles.onsets{end}(i) > handles.sStart  &&  handles.offsets{end}(i) < handles.sEnd
            handles.onsets{end}(i) = [];
            handles.offsets{end}(i) = [];
            i = i - 1;
        end
        i = i + 1;
    end
    d = handles.sEnd - handles.sStart;
    nShift = floor( handles.shiftLen * handles.fs );
    if handles.l == -1
        handles.sStack = [handles.sStart, handles.sStart + d + nShift, -1; handles.sStack];
    end
    if handles.l == -2
        handles.sStack = [handles.sEnd - d - nShift, handles.sEnd, -2; handles.sStack];
    end
end

if onoffsChanged
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
    
    onoffs = [];
    for j = 1:length( handles.onsets )
        for i = 1:length( handles.onsets{j} )
            onset = handles.onsets{j}(i);
            offset = handles.offsets{j}(i);
            if isnan(onset) || isnan(offset)
                continue;
            end
            onoffs = [onoffs; onset, +1, 1; offset, -1, 1];
        end
    end
    onoffs = sortrows( onoffs, 1 );
    i = 1;
    while i < size( onoffs, 1 )
        if sign( onoffs(i,2) ) == sign( onoffs(i+1,2) )
            if onoffs(i,3) == 1
                onoffs(i+1,2) = onoffs(i,2) + onoffs(i+1,2);
                onoffs(i+1,3) = max( 1, onoffs(i+1,1) - onoffs(i,1) );
                onoffs(i,:) = [];
            else
                onoffs(i+1,3) = max( 1, onoffs(i+1,1) - onoffs(i,1) );
                i = i + 1;
            end
        else
            i = i + 1;
        end
    end
    s = 0;
    levels = [];
    for i = 1:size( onoffs, 1 )
        if onoffs(i,2) > 0
            levels = [levels; onoffs(i,1) - onoffs(i,3), s];
            s = s + onoffs(i,2);
            levels = [levels; onoffs(i,1), s];
        else
            levels = [levels; onoffs(i,1) - onoffs(i,3), s];
            s = s + onoffs(i,2);
            levels = [levels; onoffs(i,1), s];
        end
    end
    levels = [0,0; levels; length( handles.s ) + 1,0];
    i = size( levels, 1 ) - 1;
    while i > 0
        if levels(i,1) == levels(i+1,1)
            levels(i,:) = [];
        else
            i = i - 1;
        end
    end
    levelsMax = max( levels(:,2) );
    levels(:,2) = levels(:,2) ./ levelsMax;
    levelsInterp = interp1( levels(:,1), levels(:,2), 1:length( handles.s ) );
    winSize = 0.2 * handles.fs;
    levelsInterp = filter( pdf( 'Normal', -floor(winSize/2):floor(winSize/2), 0, floor(winSize/8) ), 1, [levelsInterp zeros(1,ceil(winSize/2))] );
    levelsInterp = [levelsInterp(ceil(winSize/2):end) zeros(1,ceil(winSize))];
    lmin = 1 / 3; %(1 / levelsMax) + (1 - (1 / levelsMax) ) / 3;
    levelsInterp(levelsInterp < lmin) = 0;
    levelsInterp(levelsInterp >= lmin) = 1;
    levelsInterpDelta = [levelsInterp, 0] - [0, levelsInterp];
    handles.onsetsInterp = find( levelsInterpDelta == +1 );
    handles.offsetsInterp = find( levelsInterpDelta == -1 );
    
    tout = '';
    for i = 1:length(handles.onsets)
        tout = [tout, sprintf( '\nonsets{%d}: %s\n', i, mat2str( double(int64(100*(handles.onsets{i} ./ handles.fs)))/100 ) ),  sprintf( 'offsets{%d}: %s\n', i, mat2str( double(int64(100*(handles.offsets{i} ./ handles.fs)))/100 ) )];
    end
    tout = [tout, sprintf( '\ninterpolated onsets: %s\n', mat2str( double(int64(100*(handles.onsetsInterp ./ handles.fs)))/100 ) ),  sprintf( 'interpolated offsets: %s\n', mat2str( double(int64(100*(handles.offsetsInterp ./ handles.fs)))/100 ) )];
    set( handles.textfield, 'String', tout );
    
    guidata( handles.labelingGuiFig, handles );
    plotSound( handles.labelingGuiFig );
end

