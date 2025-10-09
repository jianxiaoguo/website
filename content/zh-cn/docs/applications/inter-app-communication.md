---
title: 应用间通信
linkTitle: 应用间通信
description: Drycc 应用程序之间的通信解决方案。
weight: 11
---

多进程应用程序的常见架构模式是让一个进程服务公共请求，同时让多个其他进程支持公共进程，例如按计划执行操作或处理队列中的工作项。要在 Drycc Workflow 中实现这种应用程序系统，请设置应用程序使用 DNS 解析进行通信，如上所示，并通过从 Drycc Workflow 路由器中删除它们来隐藏支持进程的公共视图。

### DNS 服务发现

Drycc Workflow 支持部署由进程系统组成的单个应用程序。每个 Drycc Workflow 应用程序都在单个端口上通信，因此与其他 Workflow 应用程序通信意味着找到该应用程序的地址和端口。所有 Workflow 应用程序在外部都映射到端口 80，因此找到其 IP 地址是唯一的挑战。Workflow 为每个应用程序创建一个 [Kubernetes Service](https://kubernetes.io/docs/user-guide/services/)，这有效地为应用程序分配了一个名称和一个集群内部 IP 地址。集群中运行的 DNS 服务添加和删除 DNS 记录，这些记录在添加和删除服务时从应用程序名称指向其 IP 地址。然后，Drycc Workflow 应用程序可以简单地向服务的域名发送请求，该域名是"app-name.app-namespace"。
