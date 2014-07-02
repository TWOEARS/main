function plotSound( hfig )

handles = guidata( hfig );

hold( handles.soundAxes, 'off' );
if size(handles.s,2) == 2
    plot( handles.soundAxes, (1:length(handles.s)) / handles.fs, handles.s(:,1), (1:length(handles.s)) / handles.fs, handles.s(:,2) );
else
    plot( handles.soundAxes, (1:length(handles.s)) / handles.fs, handles.s );
end
hold( handles.soundAxes, 'on' );

for i = 1:length(handles.onsets)
    onset = median( handles.onsets{i} ) / handles.fs;
    offset = median( handles.offsets{i} ) / handles.fs;
    if isnan(onset) || isnan(offset)
        continue;
    end
    harea = area( [onset offset], [1 1], -1, 'LineStyle', 'none');
    set(harea, 'FaceColor', 'r')
    alpha(0.2)
end
