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
else
    handles.sStart = [];
    handles.sEnd = [];
    handles.l = 0;
end
