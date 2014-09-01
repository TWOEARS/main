function branchName = currentBranch( repoDir )

dirTmp = pwd;
cd( repoDir );

branchReturn = git( 'branch' );
branchSignPos = strfind( branchReturn, '*' );
branchName = sscanf( branchReturn(branchSignPos+1:end), '%s', 1 );

cd( dirTmp );