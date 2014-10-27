function lms = lMomentAlongDim( d, nl, dim )

lms = arrayFunAlongDim( @(x)(lMoments(x,nl)), d, dim );
lms = cell2mat( lms );


