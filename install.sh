#! /bin/sh

OTHER_PROJECTS="${OTHER_PROJECTS}
mulle-c/mulle-c-developer;latest
mulle-sde/mulle-test;latest"
SDE_PROJECTS="${SDE_PROJECTS}
mulle-sde-developer;latest" 

export SDE_PROJECTS
export OTHER_PROJECTS

MULLE_SDE_DEFAULT_VERSION="${MULLE_SDE_DEFAULT_VERSION:-release}"
export MULLE_SDE_DEFAULT_VERSION

curl -L -O 'https://raw.githubusercontent.com/mulle-sde/mulle-sde/${MULLE_SDE_DEFAULT_VERSION}/bin/installer-all' && \
chmod 755 installer-all && \
./installer-all ~ no
