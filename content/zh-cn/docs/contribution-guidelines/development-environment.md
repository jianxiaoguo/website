---
title: 开发环境
linkTitle: 开发环境
description: 本文档面向对直接在 Drycc 代码库上工作的开发者。
weight: 3
---

在本指南中，我们将引导您完成设置适合对大多数 Drycc 组件进行黑客攻击的开发环境的过程。

我们努力使对 Drycc 组件进行黑客攻击变得简单。然而，必然有几个移动部件和一些设置要求。我们欢迎任何自动化或简化此过程的建议。

{{% alert title="Note" color="info" %}}
Drycc 团队正在积极致力于容器化 Go 和 Python 基础的开发环境，专门针对 Drycc 开发以最小化所需的设置。这项工作正在进行中。请参考 [drycc/router][router] 项目以获取完全容器化的开发环境的实际示例。
{{% /alert %}}

如果您刚刚接触 Drycc 代码库，请寻找带有 [easy-fix][] 标签的 GitHub 问题。这些是更直接或低风险的问题，是熟悉 Drycc 的好方法。

## 先决条件

为了成功编译和测试 Drycc 二进制文件以及构建 Drycc 组件的容器镜像，需要以下内容：

- [git][git]
- Go 1.5 或更高版本，支持编译到 `linux/amd64`
- [glide][glide]
- [golint][golint]
- [shellcheck][shellcheck]
- [Podman][podman]（在非 Linux 环境中，您还需要 [Podman Machine][machine]）

对于 [drycc/controller][controller]，特别是，您还需要：

- Python 2.7 或更高版本（带有 `pip`）
- virtualenv（`sudo pip install virtualenv`）

在大多数情况下，您应该按照说明简单安装。不过有一些特殊情况。我们在下面介绍这些。

### 配置 Go

如果您的本地工作站不支持 `linux/amd64` 目标环境，您将不得不从源代码安装 Go，并支持交叉编译该环境。这是因为某些组件是在您的本地机器上构建的，然后注入到容器中。

Homebrew 用户可以安装带有交叉编译支持：

```
$ brew install go --with-cc-common
```

从源代码构建 Go 也很简单：

```
$ sudo su
$ curl -sSL https://golang.org/dl/go1.5.src.tar.gz | tar -v -C /usr/local -xz
$ cd /usr/local/go/src
$ # 首先为我们的默认平台编译 Go，然后添加交叉编译支持
$ ./make.bash --no-clean
$ GOOS=linux GOARCH=amd64 ./make.bash --no-clean
```

一旦您可以编译到 `linux/amd64`，您应该能够正常编译 Drycc 组件。

## Fork 仓库

一旦满足先决条件，我们就可以开始处理 Drycc 组件。

从 Github 开始，fork 您想要贡献的 Drycc 项目，然后在本地克隆该 fork。由于 Drycc 主要用 Go 编写，最好的位置是在 `$GOPATH/src/github.com/drycc/` 下。

```
$ mkdir -p  $GOPATH/src/github.com/drycc
$ cd $GOPATH/src/github.com/drycc
$ git clone git@github.com:<username>/<component>.git
$ cd <component>
```

{{% alert title="Note" color="info" %}}
通过将 fork 的副本检出到命名空间 `github.com/drycc/<component>` 中，我们欺骗 Go 工具链将我们的 fork 视为"官方"源代码树。
{{% /alert %}}

如果您要向您 fork 的上游仓库发出拉取请求，我们建议配置 Git，以便您可以轻松地将代码变基到上游仓库的主分支。有各种策略可以做到这一点，但最常见的是添加一个 `upstream` 远程：

```
$ git remote add upstream https://github.com/drycc/<component>.git
```

为了简单起见，您可能希望将环境变量指向您的 Drycc 代码 - 包含一个或多个 Drycc 组件的目录：

```
$ export DRYCC=$GOPATH/src/github.com/drycc
```

在本文档的其余部分，`$DRYCC` 指的是该位置。

### 替代方案：使用 Pushurl Fork

许多 Drycc 贡献者更喜欢直接从 `drycc/<component>` 拉取，但推送到 `<username>/<component>`。如果该工作流程更适合您，您可以这样设置：

```
$ git clone git@github.com:drycc/<component>.git
$ cd drycc
$ git config remote.origin.pushurl git@github.com:<username>/<component>.git
```

在此设置中，获取和拉取代码将直接与上游仓库一起工作，而推送代码将向您的 fork 发送更改。这使得保持最新状态变得容易，同时进行更改然后发出拉取请求。

## 进行更改

设置好开发环境并 fork 和克隆了您想要处理的代码后，您可以开始进行更改。

## 测试更改

Drycc 组件每个都包含一套全面的自动化测试，主要用 Go 编写。请参阅 [testing][] 以获取运行测试的说明。

## 部署更改

虽然编写和执行测试对于确保代码质量至关重要，但大多数贡献者还希望将更改部署到实时环境中，无论是使用这些更改还是进一步测试它们。本节的其余部分记录了在开发集群中运行官方发布的 Drycc 组件并用您的自定义替换其中任何一个的过程。

### 运行用于开发的 Kubernetes 集群

要在本地或其他地方运行 Kubernetes 集群以支持您的开发活动，请参考 Drycc 安装说明 [here](../quickstart/index.md)。

### 使用开发注册表

为了便于将包含您的更改的容器镜像部署到您的 Kubernetes 集群，您需要使用容器注册表。这是一个位置，您可以将自定义构建的镜像推送到那里，从那里您的 Kubernetes 集群可以检索相同的镜像。

如果您的开发集群在本地运行（例如在 Minikube 中），实现这一目标的最有效和经济的方法是在本地作为容器运行容器注册表。

为了促进这一点，大多数 Drycc 组件提供了一个 make 目标来创建这样的注册表：

```
$ make dev-registry
```

在 Linux 环境中，开始使用注册表：

```
export DRYCC_REGISTRY=<主机机器的 IP>:5000
```

在非 Linux 环境中：

```
export DRYCC_REGISTRY=<drycc 容器机器 VM 的 IP>:5000
```

如果您的开发集群在 Google Container Engine 等云提供商上运行，上述本地注册表将无法被您的 Kubernetes 节点访问。在这种情况下，[DockerHub][dh] 或 [quay.io][quay] 等公共注册表就足够了。

例如，要使用 DockerHub：

```
$ export DRYCC_REGISTRY="registry.drycc.cc"
$ export IMAGE_PREFIX=<您的 DockerHub 用户名>
```

要使用 quay.io：

```
$ export DRYCC_REGISTRY=quay.io
$ export IMAGE_PREFIX=<您的 quay.io 用户名>
```

注意尾随斜杠的重要性。

### 开发/部署工作流程

有了功能正常的 Kubernetes 集群和安装在其上的官方发布的 Drycc 组件，通过用包含您的更改的自定义构建镜像替换官方发布的组件，可以促进任何您已更改的 Drycc 组件的部署和进一步测试。大多数 Drycc 组件包括 Makefiles，其中包含专门旨在以最小摩擦促进此工作流程的目标。

一般情况下，此工作流程如下所示：

1. 使用 `git` 更新源代码并提交您的更改
2. 使用 `make build` 构建新的容器镜像
3. 使用 `make dev-release` 生成 Kubernetes 清单
4. 使用 `make deploy` 使用更新的清单重新启动组件

这可以使用 `deploy` 目标缩短为一行：

```
$ make deploy
```

## 有用的命令

一旦您的自定义 Drycc 组件已部署，以下是一些有用的命令，允许您检查集群并在必要时进行故障排除：

### 查看所有 Drycc Pods

```
$ kubectl --namespace=drycc get pods
```

### 描述 Pod

这通常对故障排除处于待处理或崩溃状态的 pod 很有用：

```
$ kubectl --namespace=drycc describe -f <pod 名称>
```

### 尾随日志

```
$ kubectl --namespace=drycc logs -f <pod 名称>
```

### Django Shell

特定于 [drycc/controller][controller]

```
$ kubectl --namespace=drycc exec -it <pod 名称> -- python manage.py shell
```

有其他 Drycc 贡献者可能觉得有用的命令？给我们发 PR！

## 拉取请求

对您的更改满意？分享它们！

请阅读 [Submitting a Pull Request](submitting-a-pull-request.md)。它包含了在提议对任何 Drycc 组件进行更改时应该做的事情的清单。

[router]: https://github.com/drycc/router
[easy-fix]: https://github.com/issues?q=user%3Adrycc+label%3Aeasy-fix+is%3Aopen
[git]: https://git-scm.com/
[glide]: https://github.com/Masterminds/glide
[golint]: https://github.com/golang/lint
[shellcheck]: https://github.com/koalaman/shellcheck
[podman]: https://podman.io/
[controller]: https://github.com/drycc/controller
[vbox]: https://www.virtualbox.org/
[testing]: testing.md
[k8s]: http://kubernetes.io/
[k8s-getting-started]: http://kubernetes.io/gettingstarted/
[pr]: submitting-a-pull-request.md
[quay]: https://quay.io/
