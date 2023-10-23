#! /usr/bin/env bash

[ "${TRACE}" = 'YES' ] && set -x && : "$0" "$@"

OTHER_PROJECTS="${OTHER_PROJECTS}
mulle-sde/mulle-test;"
SDE_PROJECTS="${SDE_PROJECTS}
mulle-sde-developer;"

#
# images that have mulle-sde already installed, skip...
#
if PATH="${HOME}/bin:${PATH}" command -v mulle-sde > /dev/null
then
   echo "mulle-sde is already installed" >&2
   exit 0
fi

echo "GITHUB_REF = ${GITHUB_REF}" >&2

case "${GITHUB_REF}" in
   */prerelease)
      MULLE_SDE_DEFAULT_VERSION="latest-prerelease"
   ;;

   */*[-]prerelease)
      MULLE_SDE_DEFAULT_VERSION="`basename -- "${GITHUB_REF}"`"
   ;;

   *)
      case "${MULLE_HOSTNAME}" in
         ci-prerelease)
            MULLE_SDE_DEFAULT_VERSION="latest-prerelease"
         ;;

         *)
            MULLE_SDE_DEFAULT_VERSION="${MULLE_SDE_DEFAULT_VERSION:-release}"
         ;;
      esac
   ;;
esac

export MULLE_SDE_DEFAULT_VERSION
export SDE_PROJECTS
export OTHER_PROJECTS

url="https://raw.githubusercontent.com/mulle-sde/mulle-sde/${MULLE_SDE_DEFAULT_VERSION}/bin/installer-all"

CURL="`command -v curl`"
CURLFLAGS="${CURLFLAGS} -L -O"
if [ -z "${CURL}" ]
then
   if [ ! -z "`command -v wget`" ]
   then
      CURL="wget"
      CURLFLAGS=""
   else
      if [ ! -z "`command -v uname`" ]
      then
         case "`uname`" in
            [Dd]arwin)
               brew install curl
            ;;

            [Ll]inux)
               if [ `id -u` -eq 0 ]
               then
                  apt-get update
                  apt-get install -y curl git
               else
                  sudo apt-get update
                  sudo apt-get install -y curl git
               fi
            ;;
         esac
      fi
   fi
fi

echo "Downloading installer-all from \"${url}\"" >&2
"${CURL:-curl}" ${CURLFLAGS} "${url}" && \
chmod 755 installer-all && \
echo "Executing installer-all" >&2 && \
./installer-all "${HOME}" no