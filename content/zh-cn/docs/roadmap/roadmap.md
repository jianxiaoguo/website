---
title: Drycc Workflow 路线图
linkTitle: 路线图
description: Drycc 路线图由社区驱动并通过 GitHub 管理。
weight: 2
---

# Drycc Workflow 路线图

Drycc Workflow 路线图是一个社区文档，作为开放 [规划过程](planning-process.md) 的一部分创建。每个路线图项目描述了一个高级功能或功能分组，这些被认为对 Drycc 的未来很重要。

鉴于项目的快速 [发布计划](releases.md)，路线图项目旨在提供跨越多个发布的方向感。

## 交互式 `drycc run /bin/bash`

为开发者提供在他们的应用程序环境中启动交互式终端会话的能力。

相关问题：

* <https://github.com/drycc/workflow-cli/issues/28>
* <https://github.com/drycc/drycc/issues/117>

## 日志流式传输

通过 `drycc logs -f` 流式传输应用程序日志 <https://github.com/drycc/drycc/issues/465>

## 团队和权限

团队和权限代表了一个更灵活的权限模型，允许对平台上的应用程序、能力和资源进行更细致的控制。在这个领域有许多提议，需要在开始实施 Drycc Workflow 之前进行协调。

相关问题：

* 部署密钥： <https://github.com/drycc/drycc/issues/3875>
* 团队： <https://github.com/drycc/drycc/issues/4173>
* 细粒度权限： <https://github.com/drycc/drycc/issues/4150>
* 仅管理员创建应用： <https://github.com/drycc/drycc/issues/4052>
* 管理员证书权限： <https://github.com/drycc/drycc/issues/4576#issuecomment-170987223>

## 监控

* [ ] 使用 Kapacitor 定义和交付警报： <https://github.com/drycc/monitor/issues/44>

## Workflow 插件/服务

开发者应该能够使用服务或插件抽象快速轻松地配置应用程序依赖项。
<https://github.com/drycc/drycc/issues/231>

## 入站/出站 Webhooks

Drycc Workflow 应该能够从外部系统发送和接收 webhooks。促进与第三方服务如 GitHub、Gitlab、Slack、Hipchat 的集成。

* [X] 在平台事件上发送 webhook： <https://github.com/drycc/drycc/issues/1486> (Workflow v2.10)
