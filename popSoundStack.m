function handles = popSoundStack( handles )

if handles.player.isplaying
    stopPlayer( handles.player );
end
if ~isempty( handles.sStack )
    handles.sStart = handles.sStack(1,1);
    handles.sEnd = handles.sStack(1,2);
    handles.l = handles.sStack(1,3);
    handles.sStack(1,:) = [];
    handles.player = [];
    handles.player = audioplayer( handles.s(handles.sStart:handles.sEnd), handles.fs );
    handles.player.StopFcn = {@playerStopped, handles.labelingGuiFig};
    handles.player.play( );
elseif handles.phase == 2
    handles.phase = 3;
    set( handles.statusText, 'String', 'Phase2: block Labeling / event shrinking' );
    nTestLen = floor( handles.fs * handles.minBlockLen );
    nShift = floor( handles.shiftLen * handles.fs );
    for i = 1:length( handles.onsets{end} )
        offsetsD = handles.onsets{end}(i) - handles.offsets{end};
        offsetsD(offsetsD <= 0) = [];
        maxOffsetD = max( offsetsD );
        testOnset = max( [1, handles.onsets{end}(i) - maxOffsetD, handles.onsets{end}(i) - nTestLen + nShift] );
        d = handles.onsets{end}(i) - testOnset;
        if d > handles.fs * 0.075
            handles.sStack = [handles.onsets{end}(i) - d, min( length( handles.s ), handles.onsets{end}(i) + nShift ), -1; handles.sStack];
        end
        
        onsetsD = handles.onsets{end} - handles.offsets{end}(i);
        onsetsD(onsetsD <= 0) = [];
        minOnsetD = min( onsetsD );
        testOffset = min( [length( handles.s ), handles.offsets{end}(i) + minOnsetD, handles.offsets{end}(i) + nTestLen - nShift] );
        d = testOffset - handles.offsets{end}(i);
        if d > handles.fs * 0.075
            handles.sStack = [max( 1, handles.offsets{end}(i) - nShift ), handles.offsets{end}(i) + d, -2; handles.sStack];
        end
    end
    handles = popSoundStack( handles );
else
    handles.sStart = [];
    handles.sEnd = [];
    handles.l = 0;
    set( handles.statusText, 'String', 'Labeling round finished' );
end
