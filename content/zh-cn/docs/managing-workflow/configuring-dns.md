---
title: 配置 DNS
linkTitle: 配置 DNS
description: Drycc Workflow 控制器和通过 Workflow 部署的所有应用程序默认情况下旨在作为 Workflow 集群域的子域访问。
weight: 2
---

例如，假设 `example.com` 是集群的域：

* 控制器应该可以在 `drycc.example.com` 访问
* 应用程序应该默认可以在 `<application name>.example.com` 访问

鉴于这种情况，配置 DNS 的主要目标是将集群域的所有子域的流量定向到托管平台的路由器组件的集群节点，该组件能够将流量引导到集群内的正确端点。


## 使用负载均衡器

通常，建议使用 [load balancer][] 将入站流量定向到一个或多个路由器。在这种情况下，配置 DNS 就像在 DNS 中定义一个指向负载均衡器的通配符记录一样简单。

例如，假设域为 `example.com`：

* 枚举每个负载均衡器 IP 的 `A` 记录（即 DNS 轮询）
* 引用负载均衡器现有完全限定域名的 `CNAME` 记录
    * 根据 [AWS 自己的文档][AWS recommends]，当使用 AWS Elastic Load Balancers 时，这是推荐策略，因为 ELB IP 可能会随时间变化。

对于使用"自定义域"（不是集群自己域的子域的完全限定域名）的任何应用程序的 DNS，可以通过创建引用上述通配符记录的 `CNAME` 记录来配置。

虽然这取决于您的 Kubernetes 发行版和底层基础设施，但在许多情况下，可以使用 `kubectl` 工具直接确定负载均衡器的 IP 或现有完全限定域名：

```
$ kubectl --namespace=istio-nginx describe service | grep "LoadBalancer"
LoadBalancer Ingress:	a493e4e58ea0511e5bb390686bc85da3-1558404688.us-west-2.elb.amazonaws.com
```

`LoadBalancer Ingress` 字段通常描述现有域名或公共 IP。请注意，如果 Kubernetes 能够为您自动提供负载均衡器，它会异步执行此操作。如果在 Workflow 安装后不久发出上述命令，负载均衡器可能尚不存在。

## 没有负载均衡器

在某些平台（例如 Minikube）上，提供负载均衡器不是一件容易或实际的事情。在这些情况下，可以直接识别托管路由器 pod 的 Kubernetes 节点的公共 IP，并使用该信息来配置本地 `/etc/hosts` 文件。

因为通配符条目在本地 `/etc/hosts` 文件中不起作用，使用此策略可能导致频繁编辑该文件，为添加到该集群的每个应用程序添加集群的完全限定子域。因此，更可行的选项可能是利用 [xip.io][xip] 服务。

一般来说，对于任何 IP `a.b.c.d`，完全限定域名 `any-subdomain.a.b.c.d.xip.io` 将解析为 IP `a.b.c.d`。这可能非常有用。

首先，使用 `kubectl` 查找托管路由器实例的节点：

```
$ kubectl --namespace=istio-ingress describe pod | grep Node:
Node:       ip-10-0-0-199.us-west-2.compute.internal/10.0.0.199
Node:       ip-10-0-0-198.us-west-2.compute.internal/10.0.0.198
```

该命令将显示每个路由器 pod 的信息。对于每个，`Node` 字段中显示节点名称和 IP。如果这些字段中出现的 IP 是公共的，则可以使用其中任何一个来配置您的本地 `/etc/hosts` 文件，或与 [xip.io][xip] 一起使用。如果显示的 IP 不是公共的，则可能需要进一步调查。

您可以使用 `kubectl` 列出节点的 IP 地址：

```
$ kubectl describe node ip-10-0-0-199.us-west-2.compute.internal
# ...
Addresses:	10.0.0.199,10.0.0.199,54.218.85.175
# ...
```

在这里，`Addresses` 字段列出了节点的所有 IP。如果其中任何一个是公共的，则可以再次使用它们来配置您的本地 `/etc/hosts` 文件，或与 [xip.io][xip] 一起使用。

## 教程：使用 [Google Cloud DNS][cloud dns] 配置 DNS

在本节中，我们将描述如何配置 Google Cloud DNS 以将您的域名路由到您的 Drycc 集群。

在本节中，我们假设以下内容：

- 您的入口服务前面有一个负载均衡器。
  - 负载均衡器不必基于云，它只需要提供稳定的 IP 地址或稳定的域名
- 您在注册商处注册了 `mystuff.com` 域名
  - 在以下说明中用您的域名替换 `mystuff.com`
- 您的注册商允许您更改域名的名称服务器（大多数注册商都这样做）

以下是配置云 DNS 以路由到您的 drycc 集群的步骤：

1. 获取负载均衡器 IP 或域名
  - 如果您在 Google Container Engine 上，可以运行 `kubectl get svc -n istio-ingress` 并查找 `LoadBalancer Ingress` 列以获取 IP 地址
2. 创建新的 Cloud DNS Zone（在控制台上：`Networking` => `Cloud DNS`，然后点击 `Create Zone`）
3. 命名您的区域，并将 DNS 名称设置为 `mystuff.com.`（注意末尾的 `.`
4. 点击 `Create` 按钮
5. 在结果页面上点击 `Add Record Set` 按钮
6. 如果您的负载均衡器提供稳定的 IP 地址，请在结果表单中输入以下字段：
  1. `DNS Name`: `*`
  2. `Resource Record Type`: `A`
  3. `TTL`: 您选择的 DNS TTL。如果您正在测试或预计您会随着时间推移拆除和重建许多 drycc 集群，我们推荐较低的 TTL
  4. `IPv4 Address`: 您在第一步中获得的 IP
  5. 点击 `Create` 按钮
7. 如果您的负载均衡器提供稳定的域名 `lbdomain.com`，请在结果表单中输入以下字段：
  1. `DNS Name`: `*`
  2. `Resource Record Type`: `CNAME`
  3. `TTL`: 您选择的 DNS TTL。如果您正在测试或预计您会随着时间推移拆除和重建许多 drycc 集群，我们推荐较低的 TTL
  4. `Canonical name`: `lbdomain.com.`（注意末尾的 `.`）
  5. 点击 `Create` 按钮
8. 在您的域注册商中，将您的 `mystuff.com` 域的名称服务器设置为同一页面上 `NS` 记录的 `data` 列下的名称服务器。它们通常如下所示（注意尾随 `.` 字符）。

  ```
  ns-cloud-b1.googledomains.com.
  ns-cloud-b2.googledomains.com.
  ns-cloud-b3.googledomains.com.
  ns-cloud-b4.googledomains.com.
  ```


注意：如果您必须重新创建您的 drycc 集群，只需返回步骤 6.4 或 7.4（取决于您的负载均衡器）并将 IP 地址或域名更改为新值。您可能必须等待您设置的 TTL 到期。


## 测试

要测试流量是否到达其预期目的地，可以像这样向 Drycc 控制器发送请求（不要忘记尾随斜杠！）：

```
curl http://drycc.example.com/v2/
```

或：

```
curl http://drycc.54.218.85.175.xip.io/v2/
```


由于此类请求需要身份验证，以下响应应被视为成功的指标：

```
{"detail":"Authentication credentials were not provided."}
```

[AWS recommends]: https://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/using-domain-names-with-elb.html
[xip]: http://xip.io/
[cloud dns]: https://cloud.google.com/dns/docs
