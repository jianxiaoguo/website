---
title: 平台监控
linkTitle: 平台监控
description: 为您的应用提供平台监控，提前发现问题并快速响应事件。

weight: 5
---

## 描述

我们现在为运行中的 Kubernetes 集群提供了一个监控堆栈，用于内省。该堆栈包括 4 个组件：

* [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)，kube-state-metrics (KSM) 是一个简单的服务，它监听 Kubernetes API 服务器并生成关于对象状态的指标。
* [Node Exporter](http://github.com/prometheus/node_exporter)，Prometheus 导出器，用于 *NIX 内核暴露的硬件和操作系统指标。
* [Victoriametrics](https://victoriametrics.com/)，一个 [Cloud Native Computing Foundation](https://cncf.io/) 项目，是一个系统和服务监控系统。
* [Grafana](http://grafana.org/)，时序数据的图形化工具

## 架构图

```
┌────────────────┐                                                        
│ HOST           │                                                        
│  node-exporter │◀──┐                          ┌──────────────────┐         
└────────────────┘   │                          │kube-state-metrics│         
                     │                          └──────────────────┘         
┌────────────────┐   │                                    ▲                    
│ HOST           │   │    ┌─────────────────┐             │                    
│  node-exporter │◀──┼────│ victoriametrics │─────────────┘                    
└────────────────┘   │    └─────────────────┘                                  
                     │             ▲                                         
┌───────────────┐    │             │                                         
│ HOST          │    │             ▼                                         
│  node-exporter│◀───┘       ┌──────────┐                                    
└───────────────┘            │ Grafana  │                                    
                             └──────────┘                                    
```

## [Grafana](https://grafana.com/)
Grafana 允许用户创建自定义仪表板，可视化捕获到运行中的 VictoriaMetrics 组件的数据。默认情况下，Grafana 通过路由器使用[服务注解](https://github.com/drycc/router#how-it-works)暴露在以下 URL：`http://grafana.mydomain.com`。默认登录是 `admin/admin`。如果您有兴趣更改这些值，请参阅[调整组件设置][]。

Grafana 将预加载几个仪表板，帮助操作员开始监控 Kubernetes 和 Drycc Workflow。这些仪表板旨在作为起点，并不包括生产安装中可能需要监控的每个项目。

Drycc Workflow 监控默认情况下不会将数据写入主机文件系统或长期存储。如果 Grafana 实例失败，修改的仪表板将丢失。

### 生产配置
生产安装的 Grafana 应尽可能更改以下配置值：

* 将默认用户名和密码从 `admin/admin` 更改。密码值以明文传递，因此最好在命令行上设置此值，而不是将其检入版本控制。
* 启用持久性
* 使用受支持的外部数据库，如 mysql 或 postgres。您可以在[此处](https://github.com/drycc/monitor/blob/main/grafana/rootfs/usr/share/grafana/grafana.ini.tpl#L62)找到更多信息


### 集群内持久性
启用持久性将允许您的自定义配置在 pod 重启后保持。这意味着如果您升级 Workflow 安装，默认的 sqllite 数据库（存储会话和用户数据等）不会消失。

如果您希望为 Grafana 启用持久性，可以在运行 `helm install` 之前在 `values.yaml` 文件中将 `enabled` 设置为 `true`。

```
 grafana:
   # Configure the following ONLY if you want persistence for on-cluster grafana
   # GCP PDs and EBS volumes are supported only
   persistence:
     enabled: true # Set to true to enable persistence
     size: 5Gi # PVC size
```

### 集群外 Grafana

如果您希望提供自己的 Grafana 实例，可以在运行 `helm install` 之前在 `values.yaml` 文件中设置 `grafana.enabled`。

## [VictoriaMetrics](https://victoriametrics.com/)
VictoriaMetrics 是一个快速且可扩展的开源时序数据库和监控解决方案，让用户无需扩展性问题和最小的运营负担即可构建监控平台，它与 prometheus 格式完全兼容。

### 集群内持久性
您可以在 `values.yaml` 中将 `node-exporter` 和 `kube-state-metrics` 设置为 `true` 或 `false`。
如果您希望为 VictoriaMetrics 启用持久性，可以在运行 `helm install` 之前在 `values.yaml` 文件中将 `enabled` 设置为 `true`。

```
victoriametrics:
  vmstorage:
    replicas: 3
    extraArgs:
    - --retentionPeriod=30d
    temporary:
      enabled: true
      size: 5Gi
      storageClass: "toplvm-ssd"
    persistence:
      enabled: true
      size: 10Gi
      storageClass: "toplvm-hdd"
  node-exporter:
    enabled: true
  kube-state-metrics:
    enabled: true
```

### 集群外 VictoriaMetrics

要使用外部 VictoriaMetrics，请在运行 `helm install` 之前在 `values.yaml` 文件中提供以下值。

* `victoriametrics.enabled=false`
* `grafana.prometheusUrl="http://my.prometheus.url:9090"`
* `controller.prometheusUrl="http://my.prometheus.url:9090"`
