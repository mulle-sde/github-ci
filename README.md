# github-ci

😷  MulleSDE Continous Integration with GitHub Actions

This will install [mulle-sde](//mulle-sde.github.io) into the test container.

It doesn't run or test your project. That's what you need to specify in
your projects `action.yml`.

If the `GITHUB_REF` being pushed ends with `prerelease`, then the prerelease
mulle-sde version will be used. 


## Run github actions locally with docker

Clone the project and then create a docker image

``` bash
docker build --rm=false -t ubuntu:mulle-ci-latest github-ci
```


Use [act](//github.com/nektos/act) to run the github workflows locally:

``` bash
alias mulle-act='act -P ubuntu-latest=ubuntu:mulle-ci-latest --env MULLE_HOSTNAME=ci-prerelease'
mulle-act
```