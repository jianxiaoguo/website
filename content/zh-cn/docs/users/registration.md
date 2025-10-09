---
title: 用户和注册
linkTitle: 用户和注册
description: 立即开始使用 Drycc
weight: 2
---

Workflow 使用 passport 组件来创建和授权用户，它可以配置 LDAP 认证选项或浏览 passport 网站来注册用户。

## 登录到 Workflow

如果您已经有账户，请使用 `drycc login` 来针对 Drycc Workflow API 进行认证。

    $ drycc login http://drycc.example.com
    Opening browser to http://drycc.example.com/v2/login/drycc/?key=4ccc81ee2dce4349ad5261ceffe72c71
    Waiting for login... .o.Logged in as drycc
    Configuration file written to /root/.drycc/client.json

或者您可以使用用户名和密码登录
    $ drycc login http://drycc.example.com --username=demo --password=demo
    Configuration file written to /root/.drycc/client.json

## 从 Workflow 注销

使用 `drycc logout` 从现有控制器会话注销。

    $ drycc logout
    Logged out as drycc

## 验证您的会话

您可以通过运行 `drycc whoami` 来验证您的客户端配置。

    $ drycc whoami
    You are drycc at http://drycc.example.com

{{% alert title="Note" color="info" %}}
会话和客户端配置存储在 `~/.drycc/client.json` 文件中。
{{% /alert %}}

[controller]: ../understanding-workflow/components.md#controller
