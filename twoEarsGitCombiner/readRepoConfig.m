function repoConfig = readRepoConfig( rcXmlFileName, tagname )
%READREPOCONFIG returns the path for the specififed Two!Ears part
%
% readRepoConfig( configXmlFile, partName ) returns the path for the Two!Ears
% software part partName as specified in the configXmlFile.

rcXml = xmlread( rcXmlFileName );

repoConfig = char( rcXml.getElementsByTagName( tagname ).item(0).getFirstChild.getData );
