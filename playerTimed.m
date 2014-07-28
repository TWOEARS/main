function playerTimed( hPlayer, event, hfig )

handles = guidata( hfig );
playt_s = (hPlayer.TotalSamples - hPlayer.CurrentSample) / handles.fs;
if playt_s < 1.0
    ttxt = [num2str( ceil( playt_s * 1000 ) ) 'ms'];
else
    ttxt = [num2str( ceil( playt_s ) ) 's'];
end
set( handles.timeText, 'String', ttxt );
if playt_s < 1.0
    drawnow;
end
