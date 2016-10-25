# croc-hunter

[![](https://images.microbadger.com/badges/image/lachlanevenson/croc-hunter.svg)](http://microbadger.com/images/lachlanevenson/croc-hunter "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/lachlanevenson/croc-hunter.svg)](http://microbadger.com/images/lachlanevenson/croc-hunter "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/commit/lachlanevenson/croc-hunter.svg)](http://microbadger.com/images/lachlanevenson/croc-hunter "Get your own commit badge on microbadger.com")

[![CircleCI](https://circleci.com/gh/lachie83/croc-hunter.svg?style=svg)](https://circleci.com/gh/lachie83/croc-hunter)

# Makefile

```
make build
make test
make docker_build
make docker_push
```

# Captain

https://github.com/harbur/captain

```
# git has changes: tagged as latest
# git has no changes: tagged as COMMIT_ID & BRANCH_NAME
captain build
captain test # intended to be a blackbox style test
```

# Wercker

```
wercker build --artifacts
wercker deploy # currently runs docker container
```
