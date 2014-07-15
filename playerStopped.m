function playerStopped( hPlayer, event, hfig )

handles = guidata( hfig );
if handles.currentKey == handles.preLabelKey
    handles.overrun = true;
end
guidata( hfig, handles );
hPlayer.play();