---
title: Managing App Metrics
linkTitle: Managing App Metrics
description: Learn how to monitor Drycc applications using metrics collection with Prometheus, including CPU, memory, disk, and network monitoring.
weight: 6
---

Metrics provide basic monitoring capabilities for pods, offering various monitoring indicators such as CPU, memory, disk, and network usage to meet basic monitoring requirements for pod resources.

## Create an Authentication Token

Create an authentication token using the Drycc client:

```
$ drycc tokens add prometheus --password admin --username admin
 !    WARNING: Make sure to copy your token now.
 !    You won't be able to see it again, please confirm whether to continue.
 !    To proceed, type "yes" !

> yes
UUID                                  USERNAME    TOKEN
58176cf1-37a8-4c52-9b27-4c7a47269dfb  admin       1F2c7A802aF640fd9F31dD846AdDf56BcMsay
```

## Add Scrape Configurations for Prometheus

A valid example configuration file can be found in the Drycc documentation.

The global configuration specifies parameters that are valid in all other configuration contexts. They also serve as defaults for other configuration sections:

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

