function sourceWavSignal = getPointSourceSignalFromWav( wavName, targetFs, zeroOffsetLength_s, normalize )

[sourceWavSignal,wavFs] = audioread( wavName );

% Stereo signals don't make sense. 
if ~isvector( sourceWavSignal )
    sourceWavSignal = mean( sourceWavSignal, 2 );
end

% Resample source signal if required
if wavFs ~= targetFs
    sourceWavSignal = resample(sourceWavSignal, targetFs, wavFs);
end

% Normalize source signal
if nargin < 4, normalize = true; end
if normalize
    sourceWavSignal = sourceWavSignal ./ max( abs( sourceWavSignal(:) ) );
end

% add some zero-signal to beginning and end
zeroOffset = zeros( floor( targetFs * zeroOffsetLength_s ), 1 ) + mean( sourceWavSignal );
sourceWavSignal = [zeroOffset; sourceWavSignal; zeroOffset];

sourceWavSignal = single( sourceWavSignal );  % single is good enough for wav data