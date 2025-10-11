---
title: Using Docker Images
linkTitle: Container Images
description: Deploy applications using container images from Drycc Container Registry or external registries.
weight: 4
---

Drycc supports deploying applications using existing [Docker Images][]. This approach integrates well with Docker-based CI/CD pipelines.

## Prepare an Application

Clone this example application to get started:

    $ git clone https://github.com/drycc/example-dockerfile-http.git
    $ cd example-dockerfile-http

Build the image and push it to [DockerHub][] using your local Docker client:

    $ docker build -t <username>/example-dockerfile-http .
    $ docker push <username>/example-dockerfile-http

### Docker Image Requirements

Container images must meet these requirements for successful deployment:

* Use the `EXPOSE` directive to expose exactly one port for HTTP traffic.
* Ensure your application listens for HTTP connections on that port.
* Define the default process using the `CMD` directive.
* Include [bash](https://www.gnu.org/software/bash/) in the container image.

{{% alert title="Note" color="info" %}}
For private registries (such as GCR), set a `$PORT` environment variable that matches your `EXPOSE`d port. For example: `drycc config set PORT=5000`. See [Configuring Registry](../installing-workflow/configuring-registry/#configuring-off-cluster-private-registry) for details.
{{% /alert %}}

## Create an Application

Create an application on the [controller][]:

    $ mkdir -p /tmp/example-dockerfile-http && cd /tmp/example-dockerfile-http
    $ drycc create example-dockerfile-http --no-remote
    Creating application... done, created example-dockerfile-http

{{% alert title="Note" color="info" %}}
For commands other than `drycc create`, the client uses the current directory name as the app name if not specified with `--app`.
{{% /alert %}}

## Deploy the Application

Deploy from [DockerHub][] or a public registry using `drycc pull`:

    $ drycc pull <username>/example-dockerfile-http:latest
    Creating build...  done, v2

    $ curl -s http://example-dockerfile-http.local3.dryccapp.com
    Powered by Drycc

Drycc automatically detects container images and scales the `web` process type to 1 on first deployment.

Scale your application by adjusting the number of containers. For example, use `drycc scale web=3` to run 3 web containers.

## Private Registry

Deploy images from private registries by attaching credentials using `drycc registry`. Use the same credentials as `docker login`.

Follow these steps for private Docker images:

1. Obtain registry credentials (such as [Quay.io Robot Account][] or [GCR.io Long Lived Token][])
2. Run `drycc registry set <username> <password> -a <application-name>`
3. Use `drycc pull` normally against private registry images

For [GCR.io Long Lived Token][], compact the JSON blob using [jq][] and use `_json_key` as the username:

```
drycc registry set _json_key "$(cat google_cloud_cred.json | jq -c .)"
```

When using private registries, Kubernetes manages image pulls directly. This improves security and speed, but requires setting the application port manually with `drycc config set PORT=80` before configuring registry credentials.

{{% alert title="Note" color="info" %}}
[GCR.io][] and [ECR][] with short-lived authentication tokens are not currently supported.
{{% /alert %}}

[container]: ../reference-guide/terms.md#container
[controller]: ../understanding-workflow/components.md#controller
[Docker Image]: https://docs.docker.com/introduction/understanding-docker/
[DockerHub]: https://registry.hub.docker.com/
[CMD instruction]: https://docs.docker.com/reference/builder/#cmd
[Quay.io Robot Account]: https://docs.quay.io/glossary/robot-accounts.html
[GCR.io Long Lived Token]: https://cloud.google.com/container-registry/docs/auth#using_a_json_key_file
[jq]: https://stedolan.github.io/jq/
[GCR.io]: https://gcr.io
[ECR]: https://aws.amazon.com/ecr/
