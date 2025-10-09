---
title: 关于应用的网关
linkTitle: 管理应用网关
description: Gateway 描述了如何将流量转换为集群内的服务。
weight: 9
---

[Gateway][gateway api] 描述了如何将流量转换为集群内的服务。也就是说，它定义了一种将流量从不知道 Kubernetes 的地方转换为知道的地方的方式。例如，由云负载均衡器、集群内代理或外部硬件负载均衡器发送到 Kubernetes 服务的流量。虽然许多用例的客户端流量源于"集群外部"，但这不是必需的。

## 为应用创建网关

网关是一种对外暴露服务的方式，它生成一个外部 IP 地址来连接路由和服务。
部署后，网关已创建。

列出容器：
```
# drycc gateways
NAME                      LISENTER       PORT     PROTOCOL    ADDRESSES
python-getting-started    tcp-80-0       80       HTTP        101.65.132.51
```

您也可以在此网关中添加端口或创建一个端口。
```
# drycc gateways add python-getting-started --port=443 --protocol=HTTPS
Adding gateway python-getting-started to python-getting-started... done
```

## 为应用创建服务

服务是一种对内暴露服务的方式，创建服务会生成一个内部 DNS，可以访问 `ptype`。
web 进程类型已创建，对于其他类型，您应该根据需要添加。

列出服务：
```
$ drycc services
PTYPE      PORT    PROTOCOL    TARGET-PORT    DOMAIN
web        80      TCP         8000           python-getting-started.python-getting-started.svc
```

为进程类型添加新服务
```
# drycc services add --help
# drycc services add sleep 8001:8001
```

## 为应用创建路由

网关可以附加到一个或多个路由引用，这些路由引用用于将部分流量引导到特定服务。
与上述相同，web 进程类型已经绑定了网关和服务。

```
# drycc routes
NAME                           OWNER        KIND           GATEWAYS                              SERVICES
python-getting-started         demo         HTTPRoute      ["python-getting-started:80"]         ["python-getting-started:80"]
```

创建新路由并附加网关。
```
drycc routes add sleep HTTPRoute --ptype=sleep  sleep:8001,100
drycc routes attach sleep --gateway=python-getting-started --port=80
```


[gateway api]: https://gateway-api.sigs.k8s.io/
