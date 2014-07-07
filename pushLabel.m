function handles = pushLabel( handles )

handles.onsets = [handles.onsets handles.sStart];
handles.offsets = [handles.offsets handles.sEnd];
guidata( handles.labelingGuiFig, handles );
plotSound( handles.labelingGuiFig );
tout = [sprintf( 'onsets: %s\n', mat2str( double(int64(100*(handles.onsets ./ handles.fs)))/100 ) ),  sprintf( 'offsets: %s\n', mat2str( double(int64(100*(handles.offsets ./ handles.fs)))/100 ) )];
set( handles.textfield, 'String', tout );
