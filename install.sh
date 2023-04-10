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
if [ -z "${CURL}" -a ! -z "`command -v wget`" ]
then
   CURL="wget"
   CURLFLAGS=""
else
   CURLFLAGS="${CURLFLAGS} -L -O"
fi


echo "Downloading installer-all from \"${url}\"" >&2
"${CURL:-curl}" ${CURLFLAGS} "${url}" && \
chmod 755 installer-all && \
echo "Executing installer-all" >&2 && \
./installer-all "${HOME}" no