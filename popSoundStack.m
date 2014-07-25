function handles = popSoundStack( handles )

if isfield( handles, 'player' ) && isplaying( handles.player )
    stopPlayer( handles.player );
end
if ~isempty( handles.sStack )
    handles.sStart = handles.sStack(1,1);
    handles.sEnd = handles.sStack(1,2);
    handles.l = handles.sStack(1,3);
    handles.sStack(1,:) = [];
    if isfield( handles, 'player' ), delete( handles.player ), end
    handles.player = [];
    handles.player = audioplayer( handles.s(handles.sStart:handles.sEnd), handles.fs );
    handles.player.StopFcn = {@playerStopped, handles.labelingGuiFig};
    play( handles.player );
elseif isempty( handles.sStack )  &&  handles.phase == 2
    handles = changePhaseTo( 3, handles );
    handles = popSoundStack( handles );
elseif isempty( handles.sStack ) && handles.phase == 3
    handles = changePhaseTo( 0, handles );
end
