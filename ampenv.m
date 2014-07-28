function [ye, fsr] = ampenv( y, fs )

if size( y, 2 ) == 2
    [~,ii] = max( std( y ) );
    y = y(:,ii);
end
y = abs( y );
y = y / max( y );
winSize = 0.33 * fs;
ye = filter( pdf( 'Normal', -floor(winSize/2):floor(winSize/2), 0, floor(winSize/6) ), 1, [y; zeros( ceil(winSize/2), 1 )] );
ye = [ye(ceil(winSize/2):end); zeros(ceil(winSize),1)];
ye = ye / max( abs( ye ) );

fsr = min( fs, ceil( fs * 1000 / length( y ) ) );
ye = resample( ye, fsr, fs );
