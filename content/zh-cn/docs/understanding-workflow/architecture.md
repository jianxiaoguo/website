---
title: 架构
linkTitle: 架构
description: Drycc Workflow 使用面向服务的架构构建。
weight: 2
---

所有组件都作为一组容器镜像发布，可以部署到任何兼容的 Kubernetes 集群。

## 概述

![系统概述](/images/diagrams/Ecosystem_Basic.jpg)

操作员使用 [Helm][] 配置和安装 Workflow 组件，这些组件直接与底层 Kubernetes 集群对接。服务发现、容器可用性和网络都委托给 Kubernetes，而 Workflow 提供干净简单的开发者体验。

## 平台服务

![Workflow 概述](/images/diagrams/Workflow_Overview.jpg)

Drycc Workflow 为您的 Kubernetes 集群提供额外功能，包括：

* [源到镜像构建器][builder]，通过 Buildpacks 或 Dockerfiles 编译您的应用程序代码
* [简单 REST API][controller]，为 CLI 和任何外部集成提供支持
* 应用程序发布和回滚
* 对应用程序资源的身份验证和授权

## Kubernetes 原生

所有平台组件和通过 Workflow 部署的应用程序都期望在现有的 Kubernetes 集群上运行。这意味着您可以愉快地在通过 Drycc Workflow 管理的应用程序旁边运行您的 Kubernetes 原生工作负载。

![Workflow 和 Kubernetes](/images/diagrams/Workflow_Detail.png)

## 应用程序布局和边缘路由

默认情况下，Workflow 为每个应用程序创建命名空间和服务，因此您可以通过标准 Kubernetes 机制轻松将您的应用程序连接到集群上的其他服务。

![应用程序配置](/images/diagrams/Application_Layout.png)

路由器组件负责将 HTTP/s 流量路由到您的应用程序，以及代理 `git push` 和平台 API 流量。

默认情况下，路由器组件作为类型为 `LoadBalancer` 的 Kubernetes 服务部署；根据您的配置，这将自动配置云原生负载均衡器。

路由器通过使用 Kubernetes 注解自动发现可路由的应用程序、SSL/TLS 证书和应用程序特定配置。对路由器配置或证书的任何更改都会在几秒钟内应用。

## 拓扑

Drycc Workflow 不再为您的部署规定特定的拓扑或服务器计数。平台组件可以在单服务器配置以及多服务器生产集群上愉快运行。

[builder]: components.md#builder
[components]: components.md
[controller]: components.md#controller
[helm]: https://github.com/kubernetes/helm
