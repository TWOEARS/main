function plotSound( hfig )

handles = guidata( hfig );
if ~isfield( handles, 'senv' )
    return;
end

buttonDown = get(handles.soundAxes, 'ButtonDownFcn');

hold( handles.soundAxes, 'off' );
h = plot( handles.soundAxes, [1:length(handles.senv)]./handles.fsenv, handles.senv, 'b' );
set(h,'HitTest','off');
set(h, 'Zdata', -1 * ones(1,length(handles.senv)));
hold( handles.soundAxes, 'on' );
h = plot( handles.soundAxes, [1:length(handles.senv)]./handles.fsenv, -handles.senv, 'b' );
set(h,'HitTest','off');
set(h, 'Zdata', -1 * ones(1,length(handles.senv)));

for i = 1:length(handles.onsetsPre)
    onset = median( handles.onsetsPre{i} ) / handles.fs;
    offset = median( handles.offsetsPre{i} ) / handles.fs;
    if isnan(onset) || isnan(offset)
        continue;
    end
    harea = area( handles.soundAxes, [onset offset], [0 0], -0.3, 'LineStyle', 'none');
    set(harea,'HitTest','off');
    set(harea, 'FaceColor', 'y')
    set(get(harea,'children'), 'FaceAlpha', 0.6)
    uistack( harea, 'top' );
end

for j = 1:length( handles.onsets )
    for i = 1:length( handles.onsets{j} )
        onset = handles.onsets{j}(i) / handles.fs;
        offset = handles.offsets{j}(i) / handles.fs;
        if isnan(onset) || isnan(offset)
            continue;
        end
        harea = area( handles.soundAxes, [onset offset], [-0.3 -0.3], -0.6, 'LineStyle', 'none');
        set(harea,'HitTest','off');
        set(harea, 'FaceColor', 'm')
        set(get(harea,'children'), 'FaceAlpha', 0.2)
    end
end

for i = 1:length( handles.onsetsInterp )
    onset = handles.onsetsInterp(i) / handles.fs;
    offset = handles.offsetsInterp(i) / handles.fs;
    if isnan(onset) || isnan(offset)
        continue;
    end
    harea = area( handles.soundAxes, [onset offset], [0.8 0.8], 0, 'LineStyle', 'none');
    set(harea,'HitTest','off');
    set(harea, 'FaceColor', 'r')
    set(get(harea,'children'), 'FaceAlpha', 0.2)
    uistack( harea, 'top' );
end

set(handles.soundAxes,'ButtonDownFcn',buttonDown);
