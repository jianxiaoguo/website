---
title: 要求
linkTitle: 系统要求
description: 要在 Kubernetes 集群上运行 Drycc Workflow，需要记住一些要求。
weight: 1
---

## Kubernetes 版本

Drycc Workflow 需要 Kubernetes v1.16.15 或更高版本。

## 组件要求

Drycc 使用网关作为路由实现，因此您必须选择一个网关。我们推荐使用 [istio](https://istio.io/) 或 [kong](https://konghq.com/)。

Workflow 支持使用 ACME 来管理自动证书，[cert-manager](https://github.com/helm/charts/tree/master/stable/cert-manager) 也是必要组件之一，如果您使用 cert-manager EAB，您需要将 `clusterResourceNamespace` 设置为 drycc 的命名空间。

Workflow 支持有状态应用。您可以通过 'drycc volumes' 命令创建和使用它们。如果您想使用此功能，您必须有一个支持 `ReadWriteMany` 的 `StorageClass`。

Workflow 还通过 'drycc resources' 命令支持 [OSB](https://github.com/openservicebrokerapi/servicebroker) API。如果您想使用此功能，需要安装 [service-catalog](https://service-catalog.drycc.cc)。

## 存储要求

各种 Drycc Workflow 组件依赖对象存储系统来完成工作，包括存储应用程序 slugs、容器镜像和数据库日志。

Drycc Workflow 默认附带 drycc 存储，它提供集群内存储。

Workflow 支持 Amazon Simple Storage Service (S3)、Google Cloud Storage (GCS)、OpenShift Swift 和 Azure Blob Storage。请参阅[配置对象存储](configuring-object-storage)以获取设置说明。

## 资源要求

部署 Drycc Workflow 时，为机器提供充足资源很重要。Drycc 是一个高可用分布式系统，这意味着 Drycc 组件和您部署的应用程序会随着主机因各种原因（故障、重启、自动缩放器等）离开集群而移动到集群中的健康主机上。因此，您应该在集群中的任何机器上都有充足的备用资源，以承受运行失败机器服务的额外负载。

Drycc Workflow 组件在集群中使用大约 2.5GB 内存，并需要大约 30GB 硬盘空间。因为如果另一台机器失败，它可能需要处理额外负载，所以每台机器的最低要求是：

* 至少 4GB RAM（越多越好）
* 至少 40GB 硬盘空间

请注意，这些估计仅适用于 Drycc Workflow 和 Kubernetes。确保为您的应用程序占用空间留出足够的备用容量。

运行配置较低的机器可能会导致系统负载增加，并已知会导致组件故障和不稳定。
