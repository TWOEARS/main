function plotSound( hfig )

handles = guidata( hfig );

hold( handles.soundAxes, 'off' );
if size(handles.s,2) == 2
    plot( handles.soundAxes, (1:length(handles.s)) / handles.fs, handles.s(:,1), (1:length(handles.s)) / handles.fs, handles.s(:,2) );
else
    plot( handles.soundAxes, (1:length(handles.s)) / handles.fs, handles.s );
end
hold( handles.soundAxes, 'on' );

for i = 1:length(handles.onsetsPre)
    onset = median( handles.onsetsPre{i} ) / handles.fs;
    offset = median( handles.offsetsPre{i} ) / handles.fs;
    if isnan(onset) || isnan(offset)
        continue;
    end
    harea = area( [onset offset], [0 0], -0.3, 'LineStyle', 'none');
    set(harea, 'FaceColor', 'y')
    alpha(0.6)
end

for j = 1:length( handles.onsets )
    for i = 1:length( handles.onsets{j} )
        onset = handles.onsets{j}(i) / handles.fs;
        offset = handles.offsets{j}(i) / handles.fs;
        if isnan(onset) || isnan(offset)
            continue;
        end
        harea = area( [onset offset], [-0.3 -0.3], -0.6, 'LineStyle', 'none');
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
    harea = area( [onset offset], [0.8 0.8], 0, 'LineStyle', 'none');
    set(harea, 'FaceColor', 'r')
    alpha(0.2)
end
