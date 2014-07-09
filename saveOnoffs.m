function saveOnoffs( handles )

contents = cellstr( get( handles.soundsList, 'String' ) );
selectedSound = regexprep( contents{get( hObject, 'Value' ) }, '<html><b>', '' );
selectedSound = regexprep( selectedSound, '</b></html>', '' );
labelFileName = [handles.soundsDir '\' selectedSound '.txt'];
