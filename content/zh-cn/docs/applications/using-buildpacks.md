---
title: 使用 Buildpacks
linkTitle: Buildpacks
description: Buildpacks 概述，负责将部署的代码转换为 slug，然后可以在容器上执行。
weight: 2
---

Drycc 支持通过 [Cloud Native Buildpacks](https://buildpacks.io/) 部署应用程序。如果您想遵循 [cnb 的文档](https://buildpacks.io/docs/) 来构建应用程序，Cloud Native Buildpacks 很有用。

## 添加 SSH 密钥

对于通过 `git push` 的基于 **Buildpack** 的应用程序部署，Drycc Workflow 通过 SSH 密钥识别用户。SSH 密钥被推送到平台，并且必须对每个用户唯一。

- 请参阅 [此文档](../users/ssh-keys.md#generate-an-ssh-key) 以获取生成 SSH 密钥的说明。

- 运行 `drycc keys add` 将您的 SSH 密钥上传到 Drycc Workflow。

```
$ drycc keys add ~/.ssh/id_drycc.pub
Uploading id_drycc.pub to drycc... done
```

阅读有关添加/删除 SSH 密钥的更多信息 [此处](../users/ssh-keys.md#adding-and-removing-ssh-keys)。

## 准备应用程序

如果您没有现有应用程序，您可以克隆演示 Heroku Buildpack 工作流的示例应用程序。

    $ git clone https://github.com/drycc/example-go.git
    $ cd example-go


## 创建应用程序

使用 `drycc create` 在 [Controller][] 上创建应用程序。

    $ drycc create
    Creating application... done, created skiing-keypunch
    Git remote drycc added


## 推送以部署

使用 `git push drycc master` 部署您的应用程序。

    $ git push drycc master
    Counting objects: 75, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (75/75), 18.28 KiB | 0 bytes/s, done.
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

因为检测到 Buildpacks 风格的应用程序，`web` 进程类型在首次部署时自动扩展到 1。

使用 `drycc scale web=3` 将 `web` 进程增加到 3，例如。直接扩展进程类型会更改运行该进程的 [pods] 数量。


## 包含的 Buildpacks

为方便起见，Drycc 捆绑了许多 buildpacks：

 * [Go Buildpack][]
 * [Java Buildpack][]
 * [Nodejs Buildpack][]
 * [PHP Buildpack][]
 * [Python Buildpack][]
 * [Ruby Buildpack][]
 * [Rust Buildpack][]

Drycc 将循环遍历每个 buildpack 的 `bin/detect` 脚本以匹配您推送的代码。

{{% alert title="Note" color="info" %}}
如果您正在测试 [Scala Buildpack][]，[Builder][] 至少需要 512MB 可用内存来执行 Scala Build Tool。
{{% /alert %}}

## 使用自定义 Buildpack

要使用自定义 buildpack，您需要在您的根路径应用中创建 `.pack_builder` 文件。

    $  tee > .pack-builder << EOF
       > registry.drycc.cc/drycc/buildpacks:bookworm
       > EOF

在您的下一次 `git push` 中，将使用自定义 buildpack。

## 使用私有仓库

要从私有仓库拉取代码，将 `SSH_KEY` 环境变量设置为具有访问权限的私钥。使用私钥文件的路径或原始密钥材料：

    $ drycc config set SSH_KEY=/home/user/.ssh/id_rsa
    $ drycc config set SSH_KEY="""-----BEGIN RSA PRIVATE KEY-----
    (...)
    -----END RSA PRIVATE KEY-----"""

例如，要使用托管在私有 GitHub URL 的自定义 buildpack，请确保 SSH 公钥存在于您的 [GitHub 设置][] 中。然后将 `SSH_KEY` 设置为相应的 SSH 私钥，并将 `.pack_builder` 设置为构建器镜像：

    $  tee > .pack-builder << EOF
       > registry.drycc.cc/drycc/buildpacks:bookworm
       > EOF
    $ git add .buildpack
    $ git commit -m "chore(buildpack): modify the pack_builder"
    $ git push drycc master

## 构建器选择器

构建项目的哪种方式符合以下原则：

- 如果项目中存在 Dockerfile，堆栈使用 `container`
- 如果项目中存在 Procfile，堆栈使用 `buildpack`
- 如果两者都存在，默认使用 `container`
- 您也可以设置 `DRYCC_STACK` 为 `container` 或 `buildpack` 来确定使用哪种堆栈。


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
