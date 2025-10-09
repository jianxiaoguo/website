---
title: 平台日志
linkTitle: 平台日志
description: 日志是从您的应用程序所有运行进程的输出流中聚合的时间戳事件流。检索、过滤或使用 syslog drains。
weight: 4
---

我们正在与 Quickwit 合作，为您提供应用程序日志集群和搜索界面。

## 架构图

```
┌───────────┐                   ┌───────────┐
│ Container │                   │  Grafana  │
└───────────┘                   └───────────┘
      │                               ^
     log                              |
      │                               |
      ˅                               │
┌───────────┐                   ┌───────────┐
│ Fluentbit │─────otel/grpc────>│  Quickwit │
└───────────┘                   └───────────┘

```

## 默认配置

Fluent Bit 基于可插拔架构，其中不同的插件在数据管道中发挥主要作用，有 70 多个内置插件可用。
请参考 charts [values.yaml](https://github.com/drycc/fluentbit/blob/main/charts/fluentbit/values.yaml) 以获取特定配置。
