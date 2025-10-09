---
title: 资源限制
linkTitle: 资源限制
description: Drycc Workflow 支持限制每个进程的内存和 CPU 份额。
weight: 12
---

## 管理应用资源限制

Drycc Workflow 支持限制每个进程的内存和 CPU 份额。为每个进程类型设置的请求/限制将作为请求和限制提供给 Kubernetes。这意味着您为进程保证 <requests\> 数量的资源，同时限制进程使用不超过 <limits\> 的资源。
默认情况下，如果我们没有明确设置 <requests\> 值，Kubernetes 会将 <requests\> 设置为等于 <limit\>。请记住 `0 <= requests <= limits`。

## 限制

如果您设置的请求/限制超出集群的范围，Kubernetes 将无法将您的应用进程调度到集群中！

```
$ drycc limits plans

ID                    SPEC    CPU              VCPUS    MEMORY     FEATURES
std1.large.c1m1       std1    Universal CPU    1        1 GiB      Integrated GPU shared
std1.large.c1m2       std1    Universal CPU    1        2 GiB      Integrated GPU shared
std1.large.c1m4       std1    Universal CPU    1        4 GiB      Integrated GPU shared
std1.large.c1m8       std1    Universal CPU    1        8 GiB      Integrated GPU shared
std1.large.c2m2       std1    Universal CPU    2        2 GiB      Integrated GPU shared
std1.large.c2m4       std1    Universal CPU    2        4 GiB      Integrated GPU shared
std1.large.c2m8       std1    Universal CPU    2        8 GiB      Integrated GPU shared
std1.large.c2m16      std1    Universal CPU    2        16 GiB     Integrated GPU shared

$ drycc limits set web=std1.large.c1m1
Applying limits... done
```

