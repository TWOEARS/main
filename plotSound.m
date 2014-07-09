function plotSound( hfig )

handles = guidata( hfig );

hold( handles.soundAxes, 'off' );
if size(handles.s,2) == 2
    plot( handles.soundAxes, (1:length(handles.s)) / handles.fs, handles.s(:,1), (1:length(handles.s)) / handles.fs, handles.s(:,2) );
else
    plot( handles.soundAxes, (1:length(handles.s)) / handles.fs, handles.s );
end
hold( handles.soundAxes, 'on' );

for j = 1:length( handles.onsets )
    for i = 1:length( handles.onsets{j} )
        onset = handles.onsets{j}(i) / handles.fs;
        offset = handles.offsets{j}(i) / handles.fs;
        if isnan(onset) || isnan(offset)
            continue;
        end
        harea = area( [onset offset], [0 0], -0.5, 'LineStyle', 'none');
        set(harea, 'FaceColor', 'm')
        alpha(0.2)
    end
end

for i = 1:length( handles.onsetsInterp )
    onset = handles.onsetsInterp(i) / handles.fs;
    offset = handles.offsetsInterp(i) / handles.fs;
    if isnan(onset) || isnan(offset)
        continue;
    end
    harea = area( [onset offset], [0.75 0.75], 0, 'LineStyle', 'none');
    set(harea, 'FaceColor', 'r')
    alpha(0.2)
end
