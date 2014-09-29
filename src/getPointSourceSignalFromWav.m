function sourceWavSignal = getPointSourceSignalFromWav( wavName, targetFs, zeroOffsetLength_s )

[sourceWavSignal,wavFs] = audioread( wavName );

% Stereo signals don't make sense. 
if ~isvector( sourceWavSignal )
    [~,m] = max( std( sourceWavSignal ) ); % choose the channel with higher energy
    sourceWavSignal = sourceWavSignal(:,m);
end

% Resample source signal if required
if wavFs ~= targetFs
    sourceWavSignal = resample(sourceWavSignal, targetFs, wavFs);
end

% Normalize source signal
sourceWavSignal = sourceWavSignal ./ max(sourceWavSignal(:));

% add some zero-signal to beginning and end
zeroOffset = zeros( targetFs * zeroOffsetLength_s, 1 ) + mean( sourceWavSignal );
sourceWavSignal = [zeroOffset; sourceWavSignal; zeroOffset];
