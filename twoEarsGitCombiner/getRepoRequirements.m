function [paths, subs, branches, startup] = getRepoRequirements( rrqXmlFileName )

rrqXml = xmlread( rrqXmlFileName );

requirements = rrqXml.getElementsByTagName( 'repoRequirement' );

paths = {};
branches = {};
startup = {};
subs = {};
for k = 1:requirements.getLength()
    paths{end+1,1} = char( requirements.item(k-1).getFirstChild.getData() );
    subAttr = requirements.item(k-1).getAttributes.getNamedItem('sub');
    if ~isempty( subAttr )
        subs{end+1,1} = char( subAttr.getFirstChild.getData() );
    else
        subs{end+1,1} = '';
    end
    branchAttr = requirements.item(k-1).getAttributes.getNamedItem('branch');
    if ~isempty( branchAttr )
        branches{end+1,1} = char( branchAttr.getFirstChild.getData() );
    else
        branches{end+1,1} = 'master';
    end
    startupAttr = requirements.item(k-1).getAttributes.getNamedItem('startup');
    if ~isempty( startupAttr )
        startup{end+1,1} = char( startupAttr.getFirstChild.getData() );
    else
        startup{end+1,1} = [];
    end
end
