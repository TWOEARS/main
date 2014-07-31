function handles = pushLabel( handles, l )

tmpStatusTxt = get( handles.statusText, 'String' );
set( handles.statusText, 'String', '...calculating...' );
drawnow;

onoffsChanged = false;

if handles.l >= 0  &&  l > 0
    onoffsChanged = true;
    handles.onsets{end} = [handles.onsets{end} handles.sStart];
    handles.offsets{end} = [handles.offsets{end} handles.sEnd];
    handles.shrinkrange = [min(handles.shrinkrange(1),handles.sStart-1) max(handles.shrinkrange(2),handles.sEnd+1)];
end
if handles.l <= 0  &&  l < 0
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
    handles.shrinkrange = [min(handles.shrinkrange(1),handles.sStart-1) max(handles.shrinkrange(2),handles.sEnd+1)];
    shrinkLen = handles.sEnd - handles.sStart;
    nShift = floor( handles.shiftLen * handles.fs );
    if handles.l == -1
        handles.sStack = [handles.sStart, handles.sStart + shrinkLen + nShift, -1; handles.sStack];
    end
    if handles.l == -2
        handles.sStack = [handles.sEnd - shrinkLen - nShift, handles.sEnd, -2; handles.sStack];
    end
end

if onoffsChanged
    handles = cleanOnOffsets( handles );
    printOnOffsets( handles );
    guidata( handles.labelingGuiFig, handles );
    plotSound( handles.labelingGuiFig );
end

set( handles.statusText, 'String', tmpStatusTxt );
