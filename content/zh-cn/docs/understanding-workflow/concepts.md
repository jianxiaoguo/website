---
title: 概念
description: Drycc Workflow 是一个轻量级应用程序平台，将十二因子应用作为容器部署并扩展到 Kubernetes 集群。
weight: 1
---

## 十二因子应用程序

[十二因子应用][] 是一种构建现代应用程序的方法论，可以在分布式系统中进行扩展。

十二因子是对多年软件即服务应用经验的宝贵总结，特别是基于 Heroku 平台的经验。

Workflow 旨在运行遵循 [十二因子应用][] 方法论和最佳实践的应用程序。

## Kubernetes

[Kubernetes][] 是 Google 开发并捐赠给 [云原生计算基金会][cncf] 的开源集群管理器。Kubernetes 管理集群上的所有活动，包括：期望状态收敛、稳定服务地址、健康监控、服务发现和 DNS 解析。

Workflow 基于 Kubernetes 抽象如 Services、Deployments 和 Pods 来提供开发者友好的体验。从应用程序源代码直接构建容器、聚合日志、管理部署配置和应用发布只是 Workflow 添加的一些功能。

Drycc Workflow 是一组可通过 [Helm][] 安装的 Kubernetes 原生组件。熟悉 Kubernetes 的系统工程师会觉得运行 Workflow 很轻松。

有关更多详细信息，请参阅 [组件][components] 概述。

## 容器

[容器][] 是一个开源项目，用于构建、运输和运行任何应用程序作为轻量级、可移植、自给自足的容器。

如果您尚未将应用程序转换为容器，Workflow 提供了简单直接的“源代码到容器镜像”功能。通过社区 [buildpacks][] 支持多种语言运行时，在容器中构建您的应用程序可以像 `git push drycc master` 一样简单。

使用 Dockerfile 或引用外部容器镜像的应用程序将不经修改地启动。

## 应用程序

Workflow 围绕 [应用程序][] 或应用的理念设计。

应用程序有三种形式之一：

1. 存储在 `git` 仓库中的源文件集合
2. 存储在 `git` 仓库中的 Dockerfile 和相关源文件
3. 对容器仓库中现有镜像的引用

应用程序由唯一的名称标识以便轻松引用。如果您在创建应用程序时未指定名称，Workflow 会为您生成一个。Workflow 还管理相关信息，包括域名、SSL 证书和开发者提供的配置。

## 构建、发布、运行

![Git Push Workflow](/images/diagrams/Git_Push_Flow.png)

### 构建阶段

[builder][] 组件处理传入的 `git push drycc master` 请求并管理您的应用程序打包。

如果您的应用程序使用 [buildpack][buildpacks]，builder 将启动一个临时作业来提取和执行打包指令。生成的应用程序工件由平台存储，用于运行阶段执行。

如果 builder 找到 [Dockerfile][dockerfile]，它将遵循这些指令创建容器镜像。生成的工件存储在 Drycc 管理的注册表中，将在运行阶段引用。

如果另一个系统已经构建并打包了您的应用程序，可以直接使用该容器工件。当引用 [外部容器镜像][containerimage] 时，builder 组件不会尝试重新打包您的应用。

### 发布阶段

在发布阶段，[build][] 与 [应用程序配置][config] 结合创建新的编号 [release][]。每当创建新构建或更改应用程序配置时，就会创建新发布。以“只写账本”的方式跟踪发布，使回滚到任何以前的发布变得容易。

### 运行阶段

运行阶段通过更改引用新发布的 Deployment 对象，将新发布部署到底层 Kubernetes 集群。通过管理期望副本计数，Workflow 编排应用程序的零停机滚动更新。一旦成功更新，Workflow 将删除对旧发布的最后引用。请注意，在部署期间，您的应用程序将在混合模式下运行。

## 后备服务

Workflow 将所有持久服务如数据库、缓存、存储、消息系统和其他 [后备服务][] 视为与您的应用程序分开管理的资源。这种理念与十二因子最佳实践一致。

应用程序使用 [环境变量][] 附加到后备服务。因为应用与后备服务解耦，它们可以独立扩展、使用其他应用提供的服务，或切换到外部或第三方供应商服务。

## 另请参阅

* [Workflow 架构][architecture]
* [Workflow 组件][components]

[Build and Run]: http://12factor.net/build-release-run
[Podman]: https://podman.io/
[Kubernetes]: https://kubernetes.io
[十二因子应用]: http://12factor.net/
[application]: ../reference-guide/terms.md#application
[architecture]: architecture.md
[backing services]: http://12factor.net/backing-services
[build]: ../reference-guide/terms.md#build
[builder]: components.md#builder
[buildpacks]: ../applications/using-buildpacks.md
[cncf]: https://cncf.io/
[components]: components.md
[config]: ../reference-guide/terms.md#config
[dockerfile]: ../applications/using-dockerfiles.md
[containerimage]: ../applications/using-container-images.md
[environment variables]: http://12factor.net/config
[helm]: https://github.com/kubernetes/helm
[release]: ../reference-guide/terms.md#release
