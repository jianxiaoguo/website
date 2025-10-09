---
title: 使用 Dockerfiles
linkTitle: 使用 Dockerfiles 部署
description: Drycc 容器注册表允许您将基于 Docker 的应用部署到 Drycc。支持通用运行时和私有空间。
weight: 3
---

Drycc 支持通过 Dockerfiles 部署应用程序。[Dockerfile][] 自动化了制作 [容器镜像][] 的步骤。
Dockerfiles 非常强大，但需要额外工作来定义您的确切应用程序运行时环境。

## 添加 SSH 密钥

对于通过 `git push` 的基于 **Dockerfile** 的应用程序部署，Drycc Workflow 通过 SSH 密钥识别用户。SSH 密钥被推送到平台，并且必须对每个用户唯一。

- 请参阅 [此文档](../users/ssh-keys.md#generate-an-ssh-key) 以获取生成 SSH 密钥的说明。

- 运行 `drycc keys add` 将您的 SSH 密钥上传到 Drycc Workflow。

```
$ drycc keys add ~/.ssh/id_drycc.pub
Uploading id_drycc.pub to drycc... done
```

阅读有关添加/删除 SSH 密钥的更多信息 [此处](../users/ssh-keys.md#adding-and-removing-ssh-keys)。


## 准备应用程序

如果您没有现有应用程序，您可以克隆演示 Dockerfile 工作流的示例应用程序。

    $ git clone https://github.com/drycc/helloworld.git
    $ cd helloworld


### Dockerfile 要求

为了部署 Dockerfile 应用程序，它们必须符合以下要求：

* Dockerfile 必须使用 `EXPOSE` 指令来公开恰好一个端口。
* 该端口必须监听 HTTP 连接。
* Dockerfile 必须使用 `CMD` 指令来定义将在容器内运行的默认进程。
* 容器镜像必须包含 [bash](https://www.gnu.org/software/bash/) 来运行进程。

{{% alert title="Note" color="info" %}}
请注意，如果您使用任何类型的私有注册表（`gcr` 或其他），应用程序环境必须包含与 `EXPOSE` 端口匹配的 `$PORT` 配置变量，例如：`drycc config set PORT=5000`。有关更多信息，请参阅 [配置注册表](../installing-workflow/configuring-registry/#configuring-off-cluster-private-registry)。
{{% /alert %}}


## 创建应用程序

使用 `drycc create` 在 [Controller][] 上创建应用程序。

    $ drycc create
    Creating application... done, created folksy-offshoot
    Git remote drycc added


## 推送部署

使用 `git push drycc master` 部署您的应用程序。

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

因为检测到 Dockerfile 应用程序，`web` 进程类型在首次部署时自动扩展到 1。

使用 `drycc scale web=3` 将 `web` 进程增加到 3，例如。直接扩展进程类型会更改运行该进程的 [容器][container] 数量。


## 容器构建参数

从 Workflow v2.13.0 开始，用户可以使用 [容器构建参数][build-args] 将其应用程序配置注入到容器镜像中。要选择加入，用户必须向其应用程序添加新的环境变量：

```
$ drycc config set DRYCC_DOCKER_BUILD_ARGS_ENABLED=1
```

使用 `drycc config set` 设置的每个环境变量都将在用户的 Dockerfile 中可用。例如，如果用户运行 `drycc config set POWERED_BY=Workflow`，用户可以在其 Dockerfile 中使用该构建参数：

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
