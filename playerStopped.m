function playerStopped( hPlayer, event, hfig )

handles = guidata( hfig );
if handles.currentKey == 'l'
    handles.overrun = true;
    handles.overrunCounter = handles.eventCounter;
end
handles.eventCounter = 1;
guidata( hfig, handles );
pause(1);
% handles.ticksPlayer.playblocking( );
hPlayer.play();