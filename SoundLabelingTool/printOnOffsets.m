function printOnOffsets( handles )

tout = '';
for i = 1:length(handles.onsets)
    tout = [tout, sprintf( '\nonsets{%d}: %s\n', i, mat2str( double(int64(100*(handles.onsets{i} ./ handles.fs)))/100 ) ),  sprintf( 'offsets{%d}: %s\n', i, mat2str( double(int64(100*(handles.offsets{i} ./ handles.fs)))/100 ) )];
end
tout = [tout, sprintf( '\ninterpolated onsets: %s\n', mat2str( double(int64(100*(handles.onsetsInterp ./ handles.fs)))/100 ) ),  sprintf( 'interpolated offsets: %s\n', mat2str( double(int64(100*(handles.offsetsInterp ./ handles.fs)))/100 ) )];
set( handles.textfield, 'String', tout );
