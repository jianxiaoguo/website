---
title: 组件
description: Workflow 由许多小型、独立的服务的组合而成，创建了一个分布式 CaaS。
weight: 3
---

所有 Workflow 组件都作为服务（以及相关控制器）部署在您的 Kubernetes 集群中。如果您感兴趣，我们提供了更详细的 [Workflow 架构][architecture] 说明。

Workflow 的所有组件都是以可组合性为理念构建的。如果您需要为您的特定部署定制其中一个组件，或者在您自己的项目中需要该功能，我们邀请您尝试使用！

## Controller

**项目位置：** [drycc/controller](https://github.com/drycc/controller)

controller 组件是一个 HTTP API 服务器，作为 `drycc` CLI 的端点。controller 提供所有平台功能以及与您的 Kubernetes 集群的接口。controller 将其所有数据持久化到数据库组件。

## Passport

**项目位置：** [drycc/passport](https://github.com/drycc/passport)

passport 组件公开一个 Web API 并提供 OAuth2 身份验证。

## Database

**项目位置：** [drycc/postgres](https://github.com/drycc/postgres)

database 组件是一个托管的 [PostgreSQL][] 实例，保存平台的大部分状态。备份和 WAL 文件通过 [WAL-E][] 推送到对象存储。当数据库重新启动时，备份从对象存储中获取并重放，因此不会丢失数据。

## Builder

**项目位置：** [drycc/builder](https://github.com/drycc/builder)

builder 组件负责通过 [Git][] 接受代码推送并管理您的 [Application][] 的构建过程。构建过程是：

1. 通过 SSH 接收传入的 `git push` 请求
2. 通过 SSH 密钥指纹验证用户
3. 授权用户访问推送代码到应用程序
4. 启动应用程序构建阶段（见下文）
5. 通过 Controller 触发新的 [Release][]

Builder 目前支持基于 buildpack 和 Dockerfile 的构建。

**项目位置：** [drycc/imagebuilder](https://github.com/drycc/imagebuilder)

对于基于 Buildpack 的部署，builder 组件将在 `drycc` 命名空间中启动一个一次性 Job。此作业运行 `imagebuilder` 组件，该组件处理默认和自定义 buildpacks（由 `.packbuilder` 指定）。完成的镜像推送到集群上的托管容器注册表。有关 buildpacks 的更多信息，请参阅 [使用 buildpacks][using-buildpacks]。

与基于 buildpack 的不同，对于包含根目录中 `Dockerfile` 的应用程序，它生成一个容器镜像（使用底层容器引擎）。有关更多信息，请参阅 [使用 Dockerfiles][using-dockerfiles]。

## Object Storage

**项目位置：** [drycc/storage](https://github.com/drycc/storage)

所有需要持久化数据的 Workflow 组件都会将它们发送到为集群配置的对象存储。例如，数据库发送其 WAL 文件，注册表存储容器镜像，slugbuilder 存储 slugs。

Workflow 支持集群内或集群外存储。对于生产部署，我们强烈推荐您配置 [集群外对象存储][configure-objectstorage]。

为了便于实验、开发和测试环境，默认的 Workflow 图表包括通过 [storage](https://github.com/drycc/storage) 的集群内存储。

如果您也对使用 Kubernetes 持久卷感到满意，您可以配置存储以使用您的环境中可用的持久存储。

## Registry

**项目位置：** [drycc/registry](https://github.com/drycc/registry)

registry 组件是一个托管的容器注册表，保存从 builder 组件生成的应用程序镜像。Registry 将容器镜像持久化到本地存储（在开发模式下）或为集群配置的对象存储。

## Quickwit

**项目位置：** [drycc/quickwit](https://github.com/drycc/quickwit)

Quickwit 是第一个直接在云存储上执行复杂搜索和分析查询的引擎，具有亚秒级延迟。由 Rust 和其解耦的计算和存储架构提供支持，它被设计为资源高效、易于操作，并可扩展到 PB 级数据。

Quickwit 非常适合日志管理、分布式跟踪，以及通常不可变的数据，如对话数据（电子邮件、文本、消息平台）和基于事件的分析。

## Fluentbit

**项目位置：** [drycc/fluentbit](https://github.com/drycc/fluentbit)

Fluent Bit 是一个快速且轻量级的遥测代理，用于 Linux、macOS、Windows 和 BSD 系列操作系统的日志、指标和跟踪。Fluent Bit 以强大的性能为重点而构建，允许从不同来源收集和处理遥测数据而无复杂性。

## HelmBroker

**项目位置：** [drycc-addons/helmbroker](https://github.com/drycc-addons/helmbroker)

Helm Broker 是一个服务代理，它在服务目录中将 Helm 图表公开为服务类。为此，Helm Broker 使用插件的概念。插件是 Helm 图表的抽象层，提供将图表转换为服务类所需的所有信息。

## Victoriametrics

**项目位置：** [drycc/victoriametrics](https://github.com/drycc/victoriametrics)

Victoriametrics 是一个开源的系统监控和警报工具包，最初由 SoundCloud 构建。它于 2012 年开源，是继 Kubernetes 之后第二个加入并毕业于云原生计算基金会的项目。Victoriametrics 将所有指标数据存储为时间序列，即指标信息与其记录的时间戳一起存储，可选的键值对称为标签也可以与指标一起存储。

## 另请参阅

* [Workflow 概念][concepts]
* [Workflow 架构][architecture]

[Application]: ../reference-guide/terms.md#application
[Config]: ../reference-guide/terms.md#config
[Git]: http://git-scm.com/
[Nginx]: http://nginx.org/
[PostgreSQL]: http://www.postgresql.org/
[WAL-E]: https://github.com/wal-e/wal-e
[architecture]: architecture.md
[concepts]: concepts.md
[configure-objectstorage]: ../installing-workflow/configuring-object-storage.md
[release]: ../reference-guide/terms.md#release
[using-buildpacks]: ../applications/using-buildpacks.md
[using-dockerfiles]: ../applications/using-dockerfiles.md
