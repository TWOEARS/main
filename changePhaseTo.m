function handles = changePhaseTo( phase, handles )

switch( phase )
    case 0
        handles.sStart = [];
        handles.sEnd = [];
        handles.l = 0;
        set( handles.statusText, 'String', 'Labeling round finished' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.gen2HelpTxt]) );
    case 1
        handles.phase = 1;
        set( handles.statusText, 'String', 'Phase1: live Labeling' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.phase1bHelpTxt]) );
        handles.onsetsPre = [];
        handles.offsetsPre = [];
        handles.onsetsPre{1} = [];
        handles.offsetsPre{1} = [];
        handles.overrun = false;
        handles.sStack = [1, length(handles.s), 1];
    case 2
        handles.phase = 2;
        set( handles.statusText, 'String', 'Phase2: block Labeling / event finding' );
        set( handles.helpText, 'String', sprintf([handles.genHelpTxt, '\n', handles.phase2HelpTxt]) );
        handles.onsets{end+1} = [];
        handles.offsets{end+1} = [];
        if isempty( handles.onsetsPre{end} ) && ~handles.energyProceed
            handles.sStack = [handles.sStack; 1, length( handles.s ), 1];
        elseif isempty( handles.onsetsPre{end} ) && handles.energyProceed
            enEnv = handles.senv;
            enMin = 0.01;
            enEnv(enEnv < enMin) = 0;
            enEnv(enEnv >= enMin) = 1;
            enEnvDelta = [enEnv; 0] - [0; enEnv];
            envFsFactor = handles.fs / handles.fsenv;
            onsets = find( enEnvDelta == +1 ) .* envFsFactor;
            offsets = find( enEnvDelta == -1 ) .* envFsFactor;
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
        end
    case 3
        handles.phase = 3;
        set( handles.statusText, 'String', 'Phase2: block Labeling / event shrinking' );
        nTestLen = floor( handles.fs * handles.minBlockLen );
        nShift = floor( handles.shiftLen * handles.fs );
        for i = 1:length( handles.onsets{end} )
            offsetsD = handles.onsets{end}(i) - handles.offsets{end};
            offsetsD(offsetsD <= 0) = [];
            maxOffsetD = max( offsetsD );
            testOnset = max( [1, handles.onsets{end}(i) - maxOffsetD, handles.onsets{end}(i) - nTestLen + nShift] );
            d = handles.onsets{end}(i) - testOnset;
            handles.sStack = [handles.onsets{end}(i) - d, min( length( handles.s ), handles.onsets{end}(i) + nShift ), -1; handles.sStack];
            onsetsD = handles.onsets{end} - handles.offsets{end}(i);
            onsetsD(onsetsD <= 0) = [];
            minOnsetD = min( onsetsD );
            testOffset = min( [length( handles.s ), handles.offsets{end}(i) + minOnsetD, handles.offsets{end}(i) + nTestLen - nShift] );
            d = testOffset - handles.offsets{end}(i);
            handles.sStack = [max( 1, handles.offsets{end}(i) - nShift ), handles.offsets{end}(i) + d, -2; handles.sStack];
        end
end

set(findobj(handles.labelingGuiFig, 'Type', 'uicontrol'), 'Enable', 'off');
drawnow;
set(findobj(handles.labelingGuiFig, 'Type', 'uicontrol'), 'Enable', 'on');
