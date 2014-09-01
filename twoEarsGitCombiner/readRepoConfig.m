function repoConfig = readRepoConfig( rcXmlFileName, tagname )

rcXml = xmlread( rcXmlFileName );

repoConfig = char( rcXml.getElementsByTagName( tagname ).item(0).getFirstChild.getData );