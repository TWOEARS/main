function handles = popSoundStack( handles )

if isfield( handles, 'player' ) && isa( handles.player, 'audioplayer' ) && isplaying( handles.player )
    handles = stopPlayer( handles );
end
if ~isempty( handles.sStack )
    handles.sStart = handles.sStack(1,1);
    handles.sEnd = handles.sStack(1,2);
    handles.l = handles.sStack(1,3);
    handles.sStack(1,:) = [];
    if isfield( handles, 'player' ), delete( handles.player ), end
    handles.player = [];
    if handles.sEnd - handles.sStart > 0
        handles.player = audioplayer( handles.s(handles.sStart:handles.sEnd), handles.fs );
        handles.player.StopFcn = {@playerStopped, handles.labelingGuiFig};
        handles.player.TimerPeriod = 0.2;
        handles.player.TimerFcn = {@playerTimed, handles.labelingGuiFig};
        play( handles.player );
    else
        handles = popSoundStack( handles );
    end
elseif isempty( handles.sStack )  && ( handles.phase == 2 || handles.phase == 5 )
    handles = changePhaseTo( 3, handles );
    handles = popSoundStack( handles );
elseif isempty( handles.sStack ) && handles.phase >= 3
    handles = changePhaseTo( 4, handles );
end
