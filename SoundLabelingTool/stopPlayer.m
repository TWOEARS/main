function handles = stopPlayer( handles )

handles.player.TimerFcn = [];
handles.player.StopFcn = [];
stop( handles.player );
set( handles.timeText, 'String', '[]' );
set(findobj(handles.labelingGuiFig, 'Type', 'uicontrol'), 'Enable', 'off');
drawnow;
set(findobj(handles.labelingGuiFig, 'Type', 'uicontrol'), 'Enable', 'on');

