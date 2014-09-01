function [ye, fsr] = ampenv( y, fs )

if size( y, 2 ) == 2
    [~,ii] = max( std( y ) );
    y = y(:,ii);
end

yep = y;
yen = y;
xep = 1:length(y);
xen = 1:length(y);

del = 1;
while ~isempty(del)
    del = zeros(size(yep));
    for k = 2:length(yep)-1
        if xep(k) - xep(k-1) >= fs * 0.01, continue, end
        if ~(yep(k-1) < yep(k) && yep(k) > yep(k+1)) % not maximum
            del(k) = k;
        end
    end
    del(del==0) = [];
    yep(del) = [];
    xep(del) = [];
end

del = 1;
while ~isempty(del)
    del = zeros(size(yen));
    for k = 2:length(yen)-1
        if xen(k) - xen(k-1) >= fs * 0.01, continue, end
        if ~(yen(k-1) > yen(k) && yen(k) < yen(k+1)) % not minimum
            del(k) = k;
        end
    end
    del(del==0) = [];
    yen(del) = [];
    xen(del) = [];
end

yep = interp1( xep, yep, 1:length(y) );
yen = interp1( xen, yen, 1:length(y) );
yep = yep / max( abs( yep ) );
yen = yen / max( abs( yen ) );

fsr = min( fs, ceil( fs * 1000 / length( y ) ) );
yep = resample( yep, fsr, fs );
yen = resample( yen, fsr, fs );

ye(1,:) = yep;
ye(2,:) = yen;