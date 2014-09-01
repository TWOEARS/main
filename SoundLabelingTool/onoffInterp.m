function [levelsInterp, interpFsFactor] = onoffInterp( onsets, offsets, handles )

onoffs = [];
for j = 1:length( onsets )
    for i = 1:length( onsets{j} )
        onset = onsets{j}(i);
        offset = offsets{j}(i);
        if isnan(onset) || isnan(offset)
            continue;
        end
        d = 0.5 * j;
        onoffs = [onoffs; onset, +d, 1; offset, -d, 1];
    end
end
onoffs = sortrows( onoffs, 1 );
i = 1;
while i < size( onoffs, 1 )
    if sign( onoffs(i,2) ) == sign( onoffs(i+1,2) )
        if onoffs(i,3) == 1
            onoffs(i+1,2) = onoffs(i,2) + onoffs(i+1,2);
            onoffs(i+1,3) = max( 1, onoffs(i+1,1) - onoffs(i,1) );
            onoffs(i,:) = [];
        else
            onoffs(i+1,3) = max( 1, onoffs(i+1,1) - onoffs(i,1) );
            i = i + 1;
        end
    else
        i = i + 1;
    end
end
s = 0;
levels = [];
for i = 1:size( onoffs, 1 )
    if onoffs(i,2) > 0
        levels = [levels; onoffs(i,1) - onoffs(i,3), s];
        s = s + onoffs(i,2);
        levels = [levels; onoffs(i,1), s];
    else
        levels = [levels; onoffs(i,1) - onoffs(i,3), s];
        s = s + onoffs(i,2);
        levels = [levels; onoffs(i,1), s];
    end
end
levels = [0,0; levels; length( handles.s ) + 1,0];
i = size( levels, 1 ) - 1;
while i > 0
    if levels(i,1) == levels(i+1,1)
        levels(i,:) = [];
    else
        i = i - 1;
    end
end
levelsMax = max( levels(:,2) );
levels(:,2) = levels(:,2) ./ levelsMax;
interpFsFactor = floor( handles.fs / 441 );
levelsInterp = interp1( levels(:,1), levels(:,2), 1:interpFsFactor:length( handles.s ) );
winSize = 0.2 * 441;
levelsInterp = filter( pdf( 'Normal', -floor(winSize/2):floor(winSize/2), 0, floor(winSize/6) ), 1, [levelsInterp zeros(1,ceil(winSize/2))] );
levelsInterp = [levelsInterp(ceil(winSize/2):end) zeros(1,ceil(winSize))];

