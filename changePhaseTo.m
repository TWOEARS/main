function handles = changePhaseTo( phase, handles )

switch( phase )
    case 1
        handles.phase = 1;
        set( handles.statusText, 'String', 'live Labeling' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.phase1bHelpTxt]) );
        handles.onsets{end+1} = [];
        handles.offsets{end+1} = [];
        handles.overrun = false;
        handles.sStack = [1, length(handles.s), 1];
    case 2
        handles.phase = 2;
        set( handles.statusText, 'String', 'block Labeling / event finding' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.phase2HelpTxt]) );
        handles.shrinkrange = [inf -inf];
        if isempty( handles.onsetsPre{end} ) && ~handles.energyProceed
            handles.sStack = [handles.sStack; 1, length( handles.s ), 1];
        elseif isempty( handles.onsetsPre{end} ) && handles.energyProceed
            enEnv = handles.senv(1,:);
            enMin = 0.01;
            enEnv(enEnv < enMin) = 0;
            enEnv(enEnv >= enMin) = 1;
            enEnvDelta = [enEnv, 0] - [0, enEnv];
            envFsFactor = handles.fs / handles.fsenv;
            onsets = floor( find( enEnvDelta == +1 ) .* envFsFactor );
            offsets = ceil( find( enEnvDelta == -1 ) .* envFsFactor );
            for k = 1:length(onsets)
                handles.sStack = [handles.sStack; onsets(k), offsets(k), 1];
            end
        else
            onsets = [0, cellfun( @median, handles.onsetsPre ), length(handles.s)];
            onsets = floor( onsets );
            offsets = [0, cellfun( @median, handles.offsetsPre ), length(handles.s)];
            offsets = floor( offsets );
            onsetsStd = [0, cellfun( @(x)(std(x / handles.fs)), handles.onsetsPre ), 0];
            offsetsStd = [0, cellfun( @(x)(std(x / handles.fs)), handles.offsetsPre ), 0];
            for i = 2:length(onsets)-1
                if isnan( onsets(i) )  ||  isnan( offsets(i) ), continue, end
                roundsFactor = 1 / length( handles.onsetsPre{i-1} );
                sLen = length( handles.s ) / handles.fs;
                lenFactor = sLen^0.6 * 0.1 + 0.2;
                onStdFactor = onsetsStd(i);
                offStdFactor = offsetsStd(i);
                if roundsFactor == 1  % std is not informative
                    onImp = lenFactor;
                    offImp = onImp;
                else
                    onImp = (roundsFactor * onStdFactor)^0.4;
                    offImp = (roundsFactor * offStdFactor)^0.4;
                end
                onImp = floor( onImp * handles.fs );
                offImp = floor( offImp * handles.fs );
                if offsets(i) - onsets(i) >= onImp + offImp
                    handles.sStart = onsets(i) + onImp;
                    handles.sEnd = offsets(i) - offImp;
                    handles.l = 1;
                    handles = pushLabel( handles, 1 );
                    handles.sStack = [handles.sStack;
                        max( 1, onsets(i) - onImp ), min( length( handles.s ), onsets(i) + onImp ), 1;
                        max( 1, offsets(i) - offImp ), min( length( handles.s ), offsets(i) + offImp ), 1];
                else
                    handles.sStack = [handles.sStack;
                        max( 1, onsets(i) - onImp ), min( length( handles.s ), offsets(i) + offImp ), 1];
                end
            end
            sortedStack = sortrows( handles.sStack, [1 2] );
            handles.sStack = sortedStack(1,:);
            for k = 2:size(sortedStack,1)
                if sortedStack(k,2) <= handles.sStack(end,2)
                    continue;
                elseif sortedStack(k,1) <= handles.sStack(end,2)
                    handles.sStack(end,2) = sortedStack(k,2);
                else
                    handles.sStack = [handles.sStack; sortedStack(k,:)];
                end
            end
        end
    case 3
        handles.phase = 3;
        set( handles.statusText, 'String', 'onset/offset refining' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.phase3HelpTxt]) );
        shrinkLen = floor( handles.fs * 0.3 );
        nShift = floor( handles.shiftLen * handles.fs );
        for i = 1:length( handles.onsets{end} )
            onset = handles.onsets{end}(i);
            if onset < handles.shrinkrange(1) || onset > handles.shrinkrange(2)
                continue;
            end
            offsetsDistance = onset - handles.offsets{end};
            offsetsDistance(offsetsDistance <= 0) = [];
            shortestOffsetDistance = min( offsetsDistance );
            shrinkOnset = max( [1, onset - shortestOffsetDistance, onset - shrinkLen + nShift] );
            handles.sStack = [shrinkOnset, min( length( handles.s ), onset + nShift ), -1; handles.sStack];
        end
        for i = 1:length( handles.offsets{end} )
            offset = handles.offsets{end}(i);
            if offset < handles.shrinkrange(1) || offset > handles.shrinkrange(2)
                continue;
            end
            onsetsDistance = handles.onsets{end} - offset;
            onsetsDistance(onsetsDistance <= 0) = [];
            shortestOnsetDistance = min( onsetsDistance );
            shrinkOffset = min( [length( handles.s ), offset + shortestOnsetDistance, offset + shrinkLen - nShift] );
            handles.sStack = [max( 1, offset - nShift ), shrinkOffset, -2; handles.sStack];
        end
    case 4
        handles.phase = 4;
        handles.sStart = [];
        handles.sEnd = [];
        handles.l = 0;
        set( handles.statusText, 'String', '' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.gen2HelpTxt]) );
    case 5
        handles.phase = 5;
        set( handles.statusText, 'String', 'Phase5: block event adding/deleting' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.phase2HelpTxt]) );
        handles.shrinkrange = [inf -inf];
end

set(findobj(handles.labelingGuiFig, 'Type', 'uicontrol'), 'Enable', 'off');
drawnow;
set(findobj(handles.labelingGuiFig, 'Type', 'uicontrol'), 'Enable', 'on');


