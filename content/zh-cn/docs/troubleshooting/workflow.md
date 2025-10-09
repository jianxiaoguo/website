---
title: Workflow 故障排除
linkTitle: Workflow 故障排除
description: 用户在配置 Workflow 时遇到的常见问题详述如下。
weight: 1
---

## 组件启动失败

有关故障排除失败组件的信息，请参见[使用 Kubectl 进行故障排除][kubectl]。

## 应用启动失败

有关应用部署问题故障排除的信息，请参见[应用故障排除][troubleshooting-app]。


## 权限被拒绝 (publickey)

此问题最常见的原因是用户忘记运行 `drycc keys:add` 或将他们的私钥添加到 SSH 代理。要这样做，请运行 `ssh-add ~/.ssh/id_rsa`，然后再次尝试运行 `git push drycc master`。

如果在尝试运行上述 `ssh-add` 命令后收到 `Could not open a connection to your authentication agent` 错误，您可能需要在运行 `ssh-add` 之前通过发出 `eval "$(ssh-agent)"` 命令来加载 SSH 代理环境变量。

## 其他问题

遇到这里没有详细说明的问题？请[打开一个 issue][issue] 或加入 [Slack 上的 #community][slack] 获取帮助！

[kubectl]: kubectl.md
[issue]: https://github.com/drycc/workflow/issues/new
[slack]: http://slack.drycc.cc/
[troubleshooting-app]: applications.md
