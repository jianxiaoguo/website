---
title: 管理应用指标
linkTitle: 管理应用指标
description: 指标支持 Pod 的基本监控功能，提供 CPU、内存、磁盘、网络等各种监控指标，以满足 Pod 资源的基本监控需求。
weight: 6
---

## 创建认证令牌

使用 drycc 客户端创建认证令牌。

```
# drycc tokens add prometheus --password admin --username admin
 !    WARNING: Make sure to copy your token now.
 !    You won't be able to see it again, please confirm whether to continue.
 !    To proceed, type "yes" !

> yes
UUID                                  USERNAME    TOKEN
58176cf1-37a8-4c52-9b27-4c7a47269dfb  admin       1F2c7A802aF640fd9F31dD846AdDf56BcMsay
```

## 为 prometheus 添加抓取配置

有效的示例文件可以在这里找到。

全局配置指定在所有其他配置上下文中有效的参数。它们还作为其他配置部分的默认值。

```
global:
  scrape_interval:   60s
  evaluation_interval: 60s
scrape_configs:
- job_name: 'drycc'
  scheme: https
  metrics_path: /v2/apps/<appname>/metrics
  authorization:
    type: Token
    credentials: 1F2c7A802aF640fd9F31dD846AdDf56BcMsay
  static_configs:
  - targets: ['drycc.domain.com']
```



