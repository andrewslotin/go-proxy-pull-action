Go proxy warming action
=======================

This action ensures that a newly released version of a Go module is pulled to the specified proxy.

Each time there is a new tag created in repository with a name that looks like a [semantic version](https://blog.golang.org/publishing-go-modules), the action gets triggered, pulling this version with `go get` via the
configured proxy (https://proxy.golang.org by default).

The action also recognizes the tags that version submodules stored within the same repository,
e.g. `contrib/awesomity/v1.2.3`.

Usage
-----

Create a new workflow file with following context:

```yaml
on:
  release:
    types:
      - created
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
      - '**/v[0-9]+.[0-9]+.[0-9]+'

jobs:
  build:
    name: Renew documentation
    runs-on: ubuntu-latest
    steps:
    - name: Pull new module version
      uses: andrewslotin/go-proxy-pull-action@master
```

This will trigger the action each time whenever a new release is published for a tag that looks either like `vX.Y.Z` or
`submodule/path/vX.Y.Z`.

Why?
----

Although the Go module proxies are capable of pulling the missing versions on-demand, there are cases when
this needs to be done before anyone has requested a new version via `go get` through this proxy. An example
would be updating the `pkg.go.dev` documentation of your library upon release.

Currently the [pkg.go.dev](https://pkg.go.dev), unlike [godoc.org](https://godoc.org) does not track new
module versions, displaying the last one it knows about as the latest one. The proposed workaround
[suggests](https://github.com/golang/go/issues/37005#issuecomment-599541549) pulling the new version via
`go get` after it has been released, which is now automated with this GitHub action.

License
-------

The scripts and documentation in this project are released under the [MIT License](LICENSE).
