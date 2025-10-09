---
title: 使用容器镜像
linkTitle: 容器镜像
description: 使用存储在 Drycc 容器注册表中的容器镜像部署应用程序。
weight: 4
---

Drycc 支持通过现有的 [Docker 镜像][] 部署应用程序。
这对于将 Drycc 集成到基于 Docker 的 CI/CD 流水线中很有用。

## 准备应用程序

首先克隆示例应用程序：

    $ git clone https://github.com/drycc/example-dockerfile-http.git
    $ cd example-dockerfile-http

接下来使用您的本地 `docker` 客户端构建镜像并推送
到 [DockerHub][]。

    $ docker build -t <username>/example-dockerfile-http .
    $ docker push <username>/example-dockerfile-http

### Docker 镜像要求

为了部署 Docker 镜像，它们必须符合以下要求：

* Dockerfile 必须使用 `EXPOSE` 指令来公开恰好一个端口。
* 该端口必须监听 HTTP 连接。
* Dockerfile 必须使用 `CMD` 指令来定义将在容器内运行的默认进程。
* Docker 镜像必须包含 [bash](https://www.gnu.org/software/bash/) 来运行进程。

{{% alert title="Note" color="info" %}}
请注意，如果您使用任何类型的私有注册表（`gcr` 或其他），应用程序环境必须包含与 `EXPOSE` 端口匹配的 `$PORT` 配置变量，例如：`drycc config set PORT=5000`。有关更多信息，请参阅[配置注册表](../installing-workflow/configuring-registry/#configuring-off-cluster-private-registry)。
{{% /alert %}}

## 创建应用程序

使用 `drycc create` 在 [controller][] 上创建应用程序。

    $ mkdir -p /tmp/example-dockerfile-http && cd /tmp/example-dockerfile-http
    $ drycc create example-dockerfile-http --no-remote
    Creating application... done, created example-dockerfile-http

{{% alert title="Note" color="info" %}}
对于除 `drycc create` 之外的所有命令，如果您没有使用 `--app` 明确指定，`drycc` 客户端会使用当前目录的名称作为应用程序名称。
{{% /alert %}}

## 部署应用程序

使用 `drycc pull` 从 [DockerHub][] 或
公共注册表部署您的应用程序。

    $ drycc pull <username>/example-dockerfile-http:latest
    Creating build...  done, v2

    $ curl -s http://example-dockerfile-http.local3.dryccapp.com
    Powered by Drycc

因为您正在部署 Docker 镜像，`web` 进程类型在首次部署时自动扩展到 1。

使用 `drycc scale web=3` 将 `web` 进程增加到 3，例如。直接扩展进程类型会更改运行该进程的 [容器][container] 数量。

## 私有注册表

要从私有注册表或私有仓库部署 Docker 镜像，请使用 `drycc registry`
将凭据附加到您的应用程序。这些凭据与您在私有注册表运行
`docker login` 时使用的凭据相同。

要部署私有 Docker 镜像，请执行以下步骤：

* 收集注册表的用户名和密码，例如 [Quay.io Robot Account][] 或 [GCR.io Long Lived Token][]
* 运行 `drycc registry set <the-user> <secret> -a <application-name>`
* 现在像往常一样对私有注册表中的镜像执行 `drycc pull`

当使用 [GCR.io Long Lived Token][] 时，JSON blob 必须首先使用
[jq][] 等工具压缩，然后在 `drycc registry set` 的密码字段中使用。对于用户名，使用
`_json_key`。例如：

```
drycc registry set _json_key "$(cat google_cloud_cred.json | jq -c .)"
```

当使用私有注册表时，Docker 镜像不再通过 Drycc Workflow Controller 拉取到 Drycc 内部注册表，而是由 Kubernetes 管理。这将提高安全性和整体速度，
但是应用程序 `port` 信息无法再被发现。相反，应用程序 `port` 信息可以通过
`drycc config set PORT=80` 在设置注册表信息之前设置。

{{% alert title="Note" color="info" %}}
目前不支持短寿命认证令牌模式的 [GCR.io][] 和 [ECR][]。
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
