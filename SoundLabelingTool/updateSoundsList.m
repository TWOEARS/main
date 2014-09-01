function updateSoundsList( handles )

wavsDirStruct = dir( [handles.soundsDir '\*.wav'] );
wavs = {wavsDirStruct.name};
for i=1:size(wavs,2)
    if ~exist( [handles.soundsDir '\' wavs{i} '.txt'], 'file' )
        wavs{i} = ['<html><b>' wavs{i} '</b></html>'];
    end
end
set( handles.soundsList, 'String', wavs );

end

