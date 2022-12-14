#! /bin/sh

OTHER_PROJECTS="${OTHER_PROJECTS}
mulle-sde/mulle-test;"
SDE_PROJECTS="${SDE_PROJECTS}
mulle-sde-developer;"

#
# images that have mulle-sde already installed, skip...
#
if ! `PATH="${HOME}/bin:${PATH}" command -v mulle-sde 2> /dev/null`
then
   return
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

echo "Downloading installer-all from \"${url}\"" >&2
curl -L -O "${url}" && \
chmod 755 installer-all && \
echo "Executing installer-all" >&2
./installer-all "${HOME}" no