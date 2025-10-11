---
title: 使用 Kubectl 进行故障排除
linkTitle: 使用 Kubectl 进行故障排除
description: Kubernetes 提供了一个命令行工具，用于与 Kubernetes 集群的控制平面通信，使用 Kubernetes API。
weight: 2
---

本文档描述了如何使用 `kubectl` 来调试集群中的任何问题。

## 深入了解组件

使用 `kubectl`，可以检查集群的当前状态。当使用 `helm` 安装 Workflow 时，Workflow 被安装到 `drycc` 命名空间中。要检查 Workflow 是否正在运行，请运行：

	$ kubectl --namespace=drycc get pods
	NAME                          READY     STATUS              RESTARTS   AGE
	drycc-builder-gqum7            0/1       ContainerCreating   0          4s
	drycc-controller-h6lk6         0/1       ContainerCreating   0          4s
	drycc-controller-celery-cmxxn  0/3       ContainerCreating   0          4s
	drycc-database-56v39           0/1       ContainerCreating   0          4s
	drycc-fluentbit-xihr1          0/1       Pending             0          2s
	drycc-storage-c2exb            0/1       Pending             0          3s
	drycc-grafana-9ccur            0/1       Pending             0          3s
	drycc-registry-5bor6           0/1       Pending             0          3s

{{% alert title="Note" color="primary" %}} tip
为了节省宝贵的击键次数，将 `kubectl --namespace=drycc` 别名为 `kd`，这样以后更容易输入。
{{% /alert %}}

要获取特定组件的日志，请使用 `kubectl logs`：

	$ kubectl --namespace=drycc logs drycc-controller-h6lk6
	system information:
	Django Version: 1.9.6
	Python 3.5.1
	addgroup: gid '0' in use
	Django checks:
	System check identified no issues (2 silenced).
	[...]

要深入运行中的容器来检查其环境，请使用 `kubectl exec`：

	$ kubectl --namespace=drycc exec -it drycc-database-56v39 gosu postgres psql
    psql (13.4 (Debian 13.4-1.pgdg100+1))
    Type "help" for help.

	postgres=# \l
	                                                List of databases
	     Name          |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
	-------------------+----------+----------+------------+------------+-----------------------
	 drycc_controller  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
	 drycc_passport    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
	 postgres          | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
	 template0         | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
	                   |          |          |            |            | postgres=CTc/postgres
	 template1         | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
	                   |          |          |            |            | postgres=CTc/postgres
	(4 rows)
	postgres=# \connect drycc_controller
	You are now connected to database "drycc_controller" as user "postgres".
	drycc_controller=# \dt
	                                 List of relations
	 Schema |              Name              | Type  |      Owner
	--------+--------------------------------+-------+-------------------
	 public | api_app                        | table | drycc_controller
	 public | api_build                      | table | drycc_controller
	 public | api_certificate                | table | drycc_controller
	 public | api_config                     | table | drycc_controller
	 public | api_domain                     | table | drycc_controller
	 public | api_key                        | table | drycc_controller
	 public | api_push                       | table | drycc_controller
	 public | api_release                    | table | drycc_controller
	 public | auth_group                     | table | drycc_controller
	 --More--
	 drycc_controller=# SELECT COUNT(*) from api_app;
	 count
	-------
	     0
	(1 row)
