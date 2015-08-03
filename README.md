Two!Ears Auditory Model
=======================

**A computational framework for modelling active exploratory listening that assigns meaning to auditory scenes**

The Two!Ears auditory model consists of several stages for modeling active human
listening. These stages include not only classical signal driven processing
steps like you can find in the [Auditory Modeling
Toolbox](http://amtoolbox.sourceforge.net/). It comes also with a complete acoustical
simulation framework for creating binaural ear signals for specified acoustical
scenes. The classical auditory signal processing is further accompanied by a black
board architecture that allows top-down processing and the inclusion of world
knowledge to the model.

The model is being developed by the partners of the EU project [Two!Ears](http://www.twoears.eu/).

## Current State of the Model

The development of the model did just start and its current version includes
only some of its stages. But you can use already the data from our
[data repository](https://dev.qu.tu-berlin.de/projects/twoears-database)
and create acoustical simulations with the [Binaural
Simulator](https://github.com/TWOEARS/binaural-simulator) from which you then
can extract a large variety of different auditory cues with the [Auditory
Front-End](https://github.com/TWOEARS/auditory-front-end).

## Installation

Download this main repository and the additional parts of the Two!Ears model you need for your application.
The main repository is always needed, because it starts the other parts of the Two!Ears model.
Beside the main repository the following parts are available:
* [Two!Ears Binaural Simulator](https://github.com/TWOEARS/binaural-simulator)
* [Two!Ears Auditory Front-End](https://github.com/TWOEARS/auditory-front-end)
* [Two!Ears Blackboard System (coming soon)](https://github.com/TWOEARS/blackboard-system)
* [Two!Ears Tools](https://github.com/TWOEARS/tools)
* [Two!Ears Database](https://dev.qu.tu-berlin.de/projects/twoears-database)
* [SOFA](https://github.com/TWOEARS/SOFA)

If you have downloaded the desired model part you have to setup the path
configuration file `TwoEarsPaths.xml` of the main repository to include your
local paths to all of the installed model parts. Please don't change the names
in the brackets like `<auditory-front-end>`, they are used internally but put the
corresponding paths between the xml tags. On a linux PC the file could be
looking like this:

```xml
<?xml version="1.0" encoding="utf-8"?>
<repoPaths>
    <binaural-simulator>~/git/twoears/binaural-simulator</binaural-simulator>
    <auditory-front-end>~/git/twoears/auditory-cues</auditory-front-end>
    <blackboard-system>~/git/twoears/cognition</blackboard-system>
    <tools>~/git/twoears/tools</tools>
    <sofa>~/git/twoears/sofa</sofa>
    <data>~/git/twoears/data</data>
</repoPaths>
```

If you have set up all the paths you can start the model with

```matlab
>> startTwoEars;
```

## Usage

At the moment, only the [Binaural
Simulator](https://github.com/TWOEARS/binaural-simulator) and the [Auditory
Front-End](https://github.com/TWOEARS/auditory-front-end) are available and
their usage is explained at their corresponding pages.


### Model overview

Below you see an overview over the architecture of the complete Two!Ears model.
The [Binaural Simulator](https://github.com/TWOEARS/binaural-simulator) and the
[Auditory Front-End](https://github.com/TWOEARS/auditory-front-end) are just two
blocks in he complete model. At its center a blackboard architecture is realized
that is able to solve different tasks like auditory scene analysis or judgement
of the quality of a spatial audio reproduction.
The knowledge for solving those tasks is provided by different *Knowledge
Sources* that are experts for certain things like localization, head rotation,
speaker identification.
The knowledge sources and the whole blackboard architecture is part of the
[Blackboard System](https://github.com/TWOEARS/blackboard-system) which will be
released soon together with examples how to apply the model.

```
    ┌───────────────────┐     ┌───────────────────┐     ┌──────────────────┐
    │                   │     │ ┌───────────────┐ │     │                  │
    │                   │     │ │ Event register│ │     │                  │
    │     Graphical     │     │ └───────────────┘ │     │                  │
    │    Model Based    │────>│ ┌───────────────┐ │────>│    Scheduler     │
    │Dynamic Blackboard │     │ │    Agenda     │ │     │                  │
    │                   │     │ └───────────────┘ │     │                  │
    └───────────────────┘     └───────────────────┘     └──────────────────┘
              │                                                   │
              │                                                   │
  ┌───────────────────────────────────────────────────────────────────────────┐
  │ ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐ │
  │ │  Auditory │  │ Confusion │  │ Confusion │  │   Head    │  │ Identity  │ │
  │ │  Cues KS  │  │    KS     │  │Solving KS │  │Rotation KS│  │    KS     │ │
  │ └───────────┘  └───────────┘  └───────────┘  └───────────┘  └───────────┘ │
  │       │                     Knowledge Sources      │                      │
  └───────│────────────────────────────────────────────│──────────────────────┘
          │                                            │
          │                                    ┌───────────────┐
    ┌───────────┐                              │ ┌───────────┐ │
    │  Auditory │                              │ │           │ │
    │ Front-End │<─────────────────────────────│ │   Robot   │ │
    └───────────┘         Ear Signals          │ └───────────┘ │
                                               │ ┌───────────┐ │
                                               │ │ Binaural  │ │
                                               │ │ Simulator │ │
                                               │ └───────────┘ │
                                               └───────────────┘
 
```

## Partners

* [Assessment of IP-based Applications Group, TU Berlin, Germany](http://www.aipa.tu-berlin.de/menue/assessment_of_ip-based_applications/parameter/en/)  
* [Neural Information Processing Group, TU Berlin, Germany](http://www.ni.tu-berlin.de/)  
* [Department of Electrical Engineering-Hearing Systems, Technical University of Denmark](http://www.hea.elektro.dtu.dk/)  
* [Institute of Communication Acoustics, Ruhr University Bochum, Germany](http://www.ika.ruhr-uni-bochum.de/index_en.html)  
* [The Institute for Intelligent Systems and Robotics, UPMC, France](http://www.isir.upmc.fr/)  
* [Robotics, Action and Perception Group, LAAS, France](https://www.laas.fr/public/en/rap)  
* [Institute of Communications Engineering, University Rostock, Germany](http://www.int.uni-rostock.de/)  
* [Department of Computer Science, University of Sheffield, UK](http://www.sheffield.ac.uk/dcs/computer-science-home)  
* [Human-Technology Interaction Group, Eindhoven University of Technology, Netherlands](http://hti.ieis.tue.nl/)  
* [The Center for Cognition, Communication, and Culture, Rensselaer, USA](http://ccc-rpi.org/)  

See [map showing partners](doc/partner-locations.geojson).

## Publications

A [list of all project publications](http://twoears.aipa.tu-berlin.de/publications/) can be found on the project homepage. Additional material for some of the publications can be found in the [papers
repository](https://github.com/TWOEARS/papers).

## License

The data bases and related stuff is released under Creative Commons licences, the software under GPL2. See the License statements at the single projects for details.

## Funding

This project has received funding from the European Union’s Seventh Framework Programme for research, technological development and demonstration under grant agreement no 618075.

![EU Flag](doc/img/eu-flag.gif) [![Tree](doc/img/tree.jpg)](http://cordis.europa.eu/fet-proactive/)
