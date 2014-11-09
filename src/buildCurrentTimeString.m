function timestr = buildCurrentTimeString()

timestr = arrayfun( @num2str, clock(), 'UniformOutput', false );
timestr = strcat( '.', timestr );
timestr = [timestr{:}];
