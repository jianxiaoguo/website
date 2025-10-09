---
title: 应用故障排除
linkTitle: 应用故障排除
description: 本文档描述了如何在部署或调试无法启动或部署的应用时排除常见问题。
weight: 3
---

## 应用有 Dockerfile，但发生了 Buildpack 部署

当您使用 `git push drycc master` 将应用部署到 Workflow 时，如果 [Builder][] 尝试使用 Buildpack 工作流进行部署，请检查以下步骤：

1. 您是否在部署正确的项目？
2. 您是否在推送正确的 git 分支（`git push drycc <branch>`）？
3. `Dockerfile` 是否在项目的根目录中？
4. 您是否已将 `Dockerfile` 提交到项目中？

## 应用已部署，但无法启动

如果您部署了应用但它无法启动，您可以使用 `drycc logs` 来检查应用无法启动的原因。有时，应用容器可能在没有记录任何错误信息的情况下启动失败。这通常发生在为应用配置的健康检查失败时。在这种情况下，您可以首先[使用 kubectl 进行故障排除][troubleshooting-kubectl]。您可以通过检查部署在应用命名空间中的 pod 来检查应用当前状态。为此，请运行

	$ kubectl --namespace=myapp get pods
	NAME                          READY     STATUS                RESTARTS   AGE
	myapp-web-1585713350-3brbo    0/1       CrashLoopBackOff      2          43s

然后我们可以描述 pod 并确定它为什么无法启动：


	Events:
	  FirstSeen     LastSeen        Count   From                            SubobjectPath                           Type            Reason          Message
	  ---------     --------        -----   ----                            -------------                           --------        ------          -------
	  43s           43s             1       {default-scheduler }                                                    Normal          Scheduled       Successfully assigned myapp-web-1585713350-3brbo to kubernetes-node-1
	  41s           41s             1       {kubelet kubernetes-node-1}     spec.containers{myapp-web}              Normal          Created         Created container with container id b86bd851a61f
	  41s           41s             1       {kubelet kubernetes-node-1}     spec.containers{myapp-web}              Normal          Started         Started container with container id b86bd851a61f
	  37s           35s             1       {kubelet kubernetes-node-1}     spec.containers{myapp-web}              Warning         Unhealthy       Liveness probe failed: Get http://10.246.39.13:8000/healthz: dial tcp 10.246.39.13:8000: getsockopt: connection refused

在这种情况下，我们将应用的健康检查初始延迟超时设置为 1 秒，这太激进了。应用在容器启动后需要一些时间来设置 API 服务器。通过将健康检查初始延迟超时增加到 10 秒，应用能够启动并正确响应。

有关如何自定义应用健康检查以更好地满足应用需求的更多信息，请参见[自定义健康检查][healthchecks]。


[builder]: ../understanding-workflow/components.md#builder
[healthchecks]: ../applications/managing-app-configuration.md#custom-health-checks
[troubleshooting-kubectl]: kubectl.md
