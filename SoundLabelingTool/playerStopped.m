function playerStopped( hPlayer, event, hfig )

handles = guidata( hfig );
if handles.currentKey == handles.preLabelKey
    handles.overrun = true;
end
guidata( hfig, handles );
while( strcmp( hPlayer.running, 'on' ) )
    sleep( 0.01 );
end
play(hPlayer);