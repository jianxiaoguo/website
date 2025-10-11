---
title: Using Buildpacks
linkTitle: Buildpacks
description: Deploy applications using Cloud Native Buildpacks, which transform code into executable containers.
weight: 2
---

Drycc supports deploying applications using [Cloud Native Buildpacks](https://buildpacks.io/). Buildpacks transform deployed code into executable containers following [CNB documentation](https://buildpacks.io/docs/).

## Add SSH Key

For buildpack-based deployments via `git push`, Drycc Workflow authenticates users using SSH keys. Each user must upload a unique SSH key.

- Generate an SSH key by following [these instructions](../users/ssh-keys.md#generate-an-ssh-key).
- Upload your SSH key using `drycc keys add`:

```
$ drycc keys add ~/.ssh/id_drycc.pub
Uploading id_drycc.pub to drycc... done
```

For more information about managing SSH keys, see [this guide](../users/ssh-keys.md#adding-and-removing-ssh-keys).

## Prepare an Application

Clone this example application to explore the buildpack workflow if you don't have an existing application:

    $ git clone https://github.com/drycc/example-go.git
    $ cd example-go

## Create an Application

Create an application on the [Controller][]:

    $ drycc create
    Creating application... done, created skiing-keypunch
    Git remote drycc added

## Push to Deploy

Deploy your application using `git push drycc master`:

    $ git push drycc master
    Counting objects: 75, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (48/48), done.
    Writing objects: 100% (75/75), 18.28 KiB | 0 bytes/s, done.
    Total 75 (delta 30), reused 58 (delta 22)
    remote: --->
    Starting build... but first, coffee!
    ---> Waiting podman running.
    ---> Process podman started.
    ---> Waiting caddy running.
    ---> Process caddy started.
    ---> Building pack
    ---> Using builder registry.drycc.cc/drycc/buildpacks:bookworm
    Builder 'registry.drycc.cc/drycc/buildpacks:bookworm' is trusted
    Pulling image 'registry.drycc.cc/drycc/buildpacks:bookworm'
    Resolving "drycc/buildpacks" using unqualified-search registries (/etc/containers/registries.conf)
    Trying to pull registry.drycc.cc/drycc/buildpacks:bookworm...
    Getting image source signatures
    ...
    ---> Skip generate base layer
    ---> Python Buildpack
    ---> Downloading and extracting Python 3.10.0
    ---> Installing requirements with pip
    Collecting Django==3.2.8
    Downloading Django-3.2.8-py3-none-any.whl (7.9 MB)
    Collecting gunicorn==20.1.0
    Downloading gunicorn-20.1.0-py3-none-any.whl (79 kB)
    Collecting sqlparse>=0.2.2
    Downloading sqlparse-0.4.2-py3-none-any.whl (42 kB)
    Collecting pytz
    Downloading pytz-2021.3-py2.py3-none-any.whl (503 kB)
    Collecting asgiref<4,>=3.3.2
    Downloading asgiref-3.4.1-py3-none-any.whl (25 kB)
    Requirement already satisfied: setuptools>=3.0 in /layers/drycc_python/python/lib/python3.10/site-packages (from gunicorn==20.1.0->-r requirements.txt (line 2)) (57.5.0)
    Installing collected packages: sqlparse, pytz, asgiref, gunicorn, Django
    Successfully installed Django-3.2.8 asgiref-3.4.1 gunicorn-20.1.0 pytz-2021.3 sqlparse-0.4.2
    ---> Generate Launcher
    ...
    Build complete.
    Launching App...
    ...
    Done, skiing-keypunch:v2 deployed to Workflow

    Use 'drycc open' to view this application in your browser

    To learn more, use 'drycc help' or visit https://www.drycc.cc

    To ssh://git@drycc.staging-2.drycc.cc:2222/skiing-keypunch.git
     * [new branch]      master -> master

    $ curl -s http://skiing-keypunch.example.com
    Powered by Drycc
    Release v2 on skiing-keypunch-v2-web-02zb9

Drycc automatically detects buildpack applications and scales the `web` process type to 1 on first deployment.

Scale your application by adjusting the number of containers. For example, use `drycc scale web=3` to run 3 web containers.


## Included Buildpacks

Drycc includes these buildpacks for convenience:

* [Go Buildpack][]
* [Java Buildpack][]
* [Node.js Buildpack][]
* [PHP Buildpack][]
* [Python Buildpack][]
* [Ruby Buildpack][]
* [Rust Buildpack][]

Drycc runs the `bin/detect` script from each buildpack to match your code.

{{% alert title="Note" color="info" %}}
The [Scala Buildpack][] requires at least 512MB of free memory for the Scala Build Tool.
{{% /alert %}}

## Using a Custom Buildpack

Use a custom buildpack by creating a `.pack-builder` file in your project root:

    $ tee .pack-builder << EOF
    registry.drycc.cc/drycc/buildpacks:bookworm
    EOF

The custom buildpack will be used on your next `git push`.

## Using Private Repositories

Pull code from private repositories by setting the `SSH_KEY` environment variable to a private key with access. Use either a file path or raw key material:

    $ drycc config set SSH_KEY=/home/user/.ssh/id_rsa
    $ drycc config set SSH_KEY="""-----BEGIN RSA PRIVATE KEY-----
    (...)
    -----END RSA PRIVATE KEY-----"""

For example, use a custom buildpack from a private GitHub URL by adding an SSH public key to your [GitHub settings][], then set `SSH_KEY` to the corresponding private key and configure `.pack-builder`:

    $ tee .pack-builder << EOF
    registry.drycc.cc/drycc/buildpacks:bookworm
    EOF
    $ git add .pack-builder
    $ git commit -m "chore(buildpack): modify the pack_builder"
    $ git push drycc master

## Builder Selection

Drycc selects the build method following these rules:

- Uses `container` if Dockerfile exists
- Uses `buildpack` if Procfile exists
- Defaults to `container` if both exist
- Override with `DRYCC_STACK=container` or `DRYCC_STACK=buildpack`


[pods]: http://kubernetes.io/v1.1/docs/user-guide/pods.html
[controller]: ../understanding-workflow/components.md#controller
[builder]: ../understanding-workflow/components.md#builder
[Go Buildpack]: https://github.com/drycc/pack-images/tree/main/buildpacks/go
[Java Buildpack]: https://github.com/drycc/pack-images/tree/main/buildpacks/java
[Nodejs Buildpack]: https://github.com/drycc/pack-images/tree/main/buildpacks/nodejs
[PHP Buildpack]: https://github.com/drycc/pack-images/tree/main/buildpacks/php
[Python Buildpack]: https://github.com/drycc/pack-images/tree/main/buildpacks/python
[Ruby Buildpack]: https://github.com/drycc/pack-images/tree/main/buildpacks/ruby
[Rust Buildpack]: https://github.com/drycc/pack-images/tree/main/buildpacks/rust
[Cloud Native Buildpacks]: https://buildpacks.io/
[GitHub settings]: https://github.com/settings/ssh
