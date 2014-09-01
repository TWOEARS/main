Two!Ears Git Combiner
=====================

This tool, in particular the "setupRepoConfig" function will help you setup the Matlab pathes / Two!Ears git repositories according to the needs of your scenario.


Usage as scenario-user
======================

1.) Permanently add the Git Combiner path to your matlab pathes.
2.) Update "repoConfig.xml" (in this directory) to your specific pathes. The structure is very self-explaining.
3.) That's it. Start the script that's been build using the Combiner.


Usage as scenario-creator
=========================

1.) All steps above, as you'll also be a user ;).
2.) Put an xml file with arbitrary name into the path of your scenario script with a structure like in the following example:
------------------------------------------
<?xml version="1.0" encoding="utf-8"?>
<requirements>
<repoRequirement sub="src" startup="startWP1">wp1</repoRequirement>
<repoRequirement sub="src" branch="gt_feature_condition_change" >wp2</repoRequirement>
<repoRequirement sub="src" branch="blackboard_s1_refactoring" >wp3</repoRequirement>
<repoRequirement sub="identificationModels" >data</repoRequirement>
</requirements>
------------------------------------------
For each "repoRequirement", the according path will be added temporarily to matlab.
If you put a "sub" attribute to the requirement, the specified subpath will be added instead of the repository home path.
If you put a "branch" attribute to the requirement, it will be checked that your repository is checked out into that specific branch and warn if otherwise.
If you put a "startup" attribute to the requirement, the respective function will be executed after adding the path of this requirement.
3.) As first action in your scenario script, call "setupRepoConfig( 'yourScenarioSetup.xml' )".


=======================================================
(c) Ivo Trowitzsch, Neural Processing Group, TU Berlin.