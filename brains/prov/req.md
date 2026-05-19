# Requirements

## Purpose
To generate a scaffloding shell scripts to generate a skeleton of the new project for the AI code agent assistant 
project. 

Publish the tools to npm package as well, so that user can install the package and use this tool locally. 

## The Skeleton

The place of the target project skeleton base directory.

### Base

Files:
CLAUDE.md   # Overall way of thinking of AI
Agent.md     # same contents of CLAUDE.md
.gitignore   #  
README.md    # The contents includes the project goal, prcicinples, design and architecture, key tech, guide for build, installation, and user guide.   




### brains

first level Sub directory "brains" which hold on all the text which both AI and huamn thoughtout. 
the next level subdirectory of brains are type of project. It can be one of the following

- prov    provisioning  this kind of proejct is to create tools for provisisioning dev environment, such as docker image creation, virtual machine generation, scripts tool to install buildutils, etc
- cpp     C and CPP progamming  project mainly uses c and cpp
- rust    Rust programming 
- java
- backend  project of the backend server etc. 


Under each project-type sub dirctory, there will be severl markdown files:
 - req.md   requirements of the project, both code agent and dev can update it
 - plan.md  plan genrated by and for coding agent
 - tool.md  the prerequisite tools 
 - verify.md  how to verify the result


### skills

first level subdirectory "skills" holds the domain specific skills 


### staging

first level subdirectory which is for intermediate result of project.  such as the iso image downloaded, virtual machine directory etc.
the subdirectory should be set in .gitigore and never submit to git repo

## Deliver

a shell script. it can
1. generate a skeleton direcotry based on "$PRJ_BASE" dir. If "$PRJ_BASE" is empty then the $PRJ_BASE is the current dir. 
2. the script copy all the files under this projects skeletop to the target PRO_BASE

the end user could use curl -fsSL https://github.com/.../saladbrain.sh | bash to set up the skeleton.

REAMDME.md  the project goal, prcicinples, design and architecture, key tech, guide for build, installation, and user guide.  


@end