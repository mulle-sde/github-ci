# github-ci

😷  MulleSDE Continous Integration with GitHub Actions

This will install [mulle-sde](//mulle-sde.github.io) into the test container.

It doesn't run or test your project. That's what you need to specify in
your projects `action.yml`.

If the `GITHUB_REF` being pushed ends with `prerelease`, then the prerelease
mulle-sde version will be used. 

