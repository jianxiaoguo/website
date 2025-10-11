---
title: Using Dockerfiles
linkTitle: Deploying with Dockerfiles
description: Deploy Docker-based applications to Drycc using Dockerfiles. Supports both Common Runtime and Private Spaces.
weight: 3
---

Drycc supports deploying applications using Dockerfiles. A [Dockerfile][] automates the process of building a [Container Image][] that defines your application's runtime environment. While Dockerfiles offer powerful customization, they require careful configuration to work with Drycc.

## Add SSH Key

For Dockerfile-based deployments via `git push`, Drycc Workflow authenticates users using SSH keys. Each user must upload a unique SSH key to the platform.

- Generate an SSH key by following [these instructions](../users/ssh-keys.md#generate-an-ssh-key).
- Upload your SSH key using `drycc keys add`:

```
$ drycc keys add ~/.ssh/id_drycc.pub
Uploading id_drycc.pub to drycc... done
```

For more information about managing SSH keys, see [this guide](../users/ssh-keys.md#adding-and-removing-ssh-keys).


## Prepare an Application

If you don't have an existing application, clone this example application to explore the Dockerfile workflow:

    $ git clone https://github.com/drycc/helloworld.git
    $ cd helloworld

### Dockerfile Requirements

Your Dockerfile must meet these requirements for successful deployment:

* Use the `EXPOSE` directive to expose exactly one port for HTTP traffic.
* Ensure your application listens for HTTP connections on that port.
* Define the default process using the `CMD` directive.
* Include [bash](https://www.gnu.org/software/bash/) in your container image.

{{% alert title="Note" color="info" %}}
If you use a private registry (such as GCR or others), set a `$PORT` environment variable that matches your `EXPOSE`d port. For example: `drycc config set PORT=5000`. See [Configuring Registry](../installing-workflow/configuring-registry/#configuring-off-cluster-private-registry) for details.
{{% /alert %}}


## Create an Application

Create an application on the [Controller][]:

    $ drycc create
    Creating application... done, created folksy-offshoot
    Git remote drycc added

## Push to Deploy

Deploy your application using `git push drycc master`:

    $ git push drycc master
    Counting objects: 13, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (13/13), done.
    Writing objects: 100% (13/13), 1.99 KiB | 0 bytes/s, done.
    Total 13 (delta 2), reused 0 (delta 0)
    -----> Building Docker image
    Uploading context 4.096 kB
    Uploading context
    Step 0 : FROM drycc/base:latest
     ---> 60024338bc63
    Step 1 : RUN wget -O /tmp/go1.2.1.linux-amd64.tar.gz -q https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz
     ---> Using cache
     ---> cf9ef8c5caa7
    Step 2 : RUN tar -C /usr/local -xzf /tmp/go1.2.1.linux-amd64.tar.gz
     ---> Using cache
     ---> 515b1faf3bd8
    Step 3 : RUN mkdir -p /go
     ---> Using cache
     ---> ebf4927a00e9
    Step 4 : ENV GOPATH /go
     ---> Using cache
     ---> c6a276eded37
    Step 5 : ENV PATH /usr/local/go/bin:/go/bin:$PATH
     ---> Using cache
     ---> 2ba6f6c9f108
    Step 6 : ADD . /go/src/github.com/drycc/helloworld
     ---> 94ab7f4b977b
    Removing intermediate container 171b7d9fdb34
    Step 7 : RUN cd /go/src/github.com/drycc/helloworld && go install -v .
     ---> Running in 0c8fbb2d2812
    github.com/drycc/helloworld
     ---> 13b5af931393
    Removing intermediate container 0c8fbb2d2812
    Step 8 : ENV PORT 80
     ---> Running in 9b07da36a272
     ---> 2dce83167874
    Removing intermediate container 9b07da36a272
    Step 9 : CMD ["/go/bin/helloworld"]
     ---> Running in f7b215199940
     ---> b1e55ce5195a
    Removing intermediate container f7b215199940
    Step 10 : EXPOSE 80
     ---> Running in 7eb8ec45dcb0
     ---> ea1a8cc93ca3
    Removing intermediate container 7eb8ec45dcb0
    Successfully built ea1a8cc93ca3
    -----> Pushing image to private registry

           Launching... done, v2

    -----> folksy-offshoot deployed to Drycc
           http://folksy-offshoot.local3.dryccapp.com

           To learn more, use `drycc help` or visit https://www.drycc.cc

    To ssh://git@local3.dryccapp.com:2222/folksy-offshoot.git
     * [new branch]      master -> master

    $ curl -s http://folksy-offshoot.local3.dryccapp.com
    Welcome to Drycc!
    See the documentation at http://docs.drycc.cc/ for more information.

Drycc automatically detects Dockerfile applications and scales the `web` process type to 1 on first deployment.

Scale your application by adjusting the number of containers. For example, use `drycc scale web=3` to run 3 web containers.


## Container Build Arguments

Starting with Workflow v2.13.0, you can inject application configuration into your container image using [Docker build arguments][build-args]. Enable this feature by setting an environment variable:

```
$ drycc config set DRYCC_DOCKER_BUILD_ARGS_ENABLED=1
```

Once enabled, all environment variables set with `drycc config set` become available in your Dockerfile. For example, after running `drycc config set POWERED_BY=Workflow`, you can use this build argument in your Dockerfile:

```
ARG POWERED_BY
RUN echo "Powered by $POWERED_BY" > /etc/motd
```


[build-args]: https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables---build-arg
[container]: ../reference-guide/terms.md#container
[controller]: ../understanding-workflow/components.md#controller
[Dockerfile]: https://docs.docker.com/reference/builder/
[Docker Image]: https://docs.docker.com/introduction/understanding-docker/
[CMD instruction]:  https://docs.docker.com/reference/builder/#cmd
[Procfile]: https://devcenter.heroku.com/articles/procfile
