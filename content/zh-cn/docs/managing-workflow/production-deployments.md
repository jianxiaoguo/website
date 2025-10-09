---
title: 生产部署
linkTitle: 生产部署
description: 为生产工作负载准备 Workflow 部署时，有一些额外的建议。
weight: 6
---

## 在生产环境中运行 Workflow 而无需 drycc 存储

在生产环境中，可以通过运行外部对象存储来实现持久存储。对于 AWS、GCE/GKE 或 Azure 上的用户，Amazon S3、Google GCS 或 Microsoft Azure Storage 的便利性使得运行无存储的 Workflow 集群的前景相当合理。对于对使用外部对象存储有限制的用户，使用 swift 对象存储可能是一个选项。

运行无存储的 Workflow 集群提供了几个优势：

 - 从工作节点移除状态
 - 减少资源使用
 - 减少管理 Workflow 的复杂性和运营负担

有关移除此运营复杂性的详细信息，请参阅[Configuring Object Storage][]。


## 审查安全注意事项

在生产环境中运行 Workflow 时，有一些额外的安全相关注意事项。有关详细信息，请参阅[Security Considerations][]。


## 注册仅限管理员

默认情况下，与 Workflow 控制器的注册处于"admin_only"模式。第一个运行 `drycc register` 命令的用户成为初始"admin"用户，此后的注册将被禁止，除非由管理员请求。

请参阅以下文档了解如何更改注册模式：

 - [Customizing Controller][]

## 禁用 Grafana 注册

还建议禁用 Grafana 仪表板的注册。

请参阅以下文档了解如何禁用 Grafana 注册：

 - [Customizing Monitor][]

[configuring object storage]: ../installing-workflow/configuring-object-storage.md
[customizing controller]: tuning-component-settings.md#customizing-the-controller
[customizing monitor]: tuning-component-settings.md#customizing-the-monitor
[database]: ../understanding-workflow/components.md#database
[storage]: ../understanding-workflow/components.md#storage
[platform ssl]: platform-ssl.md
[registry]: ../understanding-workflow/components.md#registry
