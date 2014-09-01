function setupRepoConfig( rrqXmlFileName )

[reposNeeded, subsNeeded, branchesNeeded, startupNeeded] = getRepoRequirements( rrqXmlFileName );

for k = 1:length(reposNeeded)
    repoPath = readRepoConfig( 'reposConfig.xml', reposNeeded{k} );
    repoBranch = currentBranch( repoPath );
    if ~strcmp( repoBranch, branchesNeeded{k} )
        warning( '"%s" needs to be checked out at "%s" branch, but current branch is "%s".', ...
            repoPath, branchesNeeded{k}, repoBranch );
    end
    addpath( genpath( fullfile( repoPath, subsNeeded{k} ) ) );
    if ~isempty( startupNeeded{k} )
        startupFunc = str2func( startupNeeded{k} );
        startupFunc();
    end
end
