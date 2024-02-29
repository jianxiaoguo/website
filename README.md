# Working on Website
[![Build Status](https://woodpecker.drycc.cc/api/badges/drycc/website/status.svg)](https://woodpecker.drycc.cc/drycc/website)

The Drycc project welcomes contributions from all developers. The high level process for development matches many other open source projects. See below for an outline.

* Fork this repository.
* Make your changes.
* [Submit a pull request](https://github.com/drycc/workflow/pulls) (PR) to this repository with your changes, and unit tests whenever possible.
    * If your PR fixes any [issues](https://github.com/drycc/workflow/issues), make sure you write `Fixes #1234` in your PR description (where `#1234` is the number of the issue you're closing).
* The Drycc core contributors will review your code. After each of them sign off on your code, they'll label your PR with `LGTM1` and `LGTM2` (respectively). Once that happens, a contributor will merge it.

## Requirements

Install [Hugo](https://gohugo.io/installation/) on macOS, Linux, Windows, BSD, and on any machine that can run the Go compiler tool chain.

### Dependencies Installation

In this project, the Docsy theme is pulled in as a Hugo module, together with
its dependencies:

```console
$ hugo mod graph
...
```

## Building Documentation

To build the documentation run: `hugo`.

To learn how to deploy your site, see the [hosting and deployment](https://gohugo.io/hosting-and-deployment/) section.

## Serve Documentation Locally

To serve documenation run: `hugo serve`.

Then view the documentation on [http://localhost:1313](http://localhost:1313).
