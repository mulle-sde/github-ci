#
# This docker file is for "act" (nektos/act). It preinstalls the
# mulle-clang compiler and mulle-sde
#
#FROM debian:bullseye-slim
# docker build --rm=false -t debian:mulle-ci-latest .

FROM ubuntu:latest
# docker build --rm=false -t ubuntu:mulle-ci-latest .

ENV MULLE_HOSTNAME=ci-prerelease

#
# more convenient to have three different container step
# if the compiler step fails, we don't need to rerun the curl install
# on the next fix run
#
RUN DEBIAN_FRONTEND=noninteractive \
   apt-get update \
   && apt-get -y install curl build-essential cmake uuid-runtime git lsb-release libpthread-stubs0-dev

RUN curl -L -O "https://github.com/mulle-cc/mulle-clang-project/releases/download/14.0.6.2/mulle-clang-14.0.6.2-bullseye-amd64.deb" \
   && dpkg --install "mulle-clang-14.0.6.2-bullseye-amd64.deb"

RUN curl -L -O "https://raw.githubusercontent.com/mulle-sde/mulle-sde/latest-prerelease/bin/installer-all" \
   && chmod 755 installer-all  \
   && OTHER_PROJECTS="mulle-sde/mulle-test; \
mulle-c/mulle-c-developer; \
mulle-objc/mulle-objc-developer; \
MulleFoundation/mulle-foundation-developer; \
MulleFoundation/foundation-developer;" \
      SDE_PROJECTS="mulle-sde-developer;" \
      MULLE_SDE_DEFAULT_VERSION=latest-prerelease ./installer-all /usr no

# # How to run without act
#
# MEMO must install into /usr so that mulle-bash finds libexec as /bin is
#      a symlink, but /libexec is not
#
# ``` bash
# export MULLE_HOSTNAME=ci-prerelease
# mkdir /tmp/src
# cd /tmp/src
# git clone -b prerelease https://github.com/MulleWeb/mulle-scion
# cd mulle-scion/
# mulle-sde craft
# ```


