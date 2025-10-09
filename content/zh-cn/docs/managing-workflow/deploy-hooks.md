---
title: 部署钩子
linkTitle: 部署钩子
description: 部署钩子允许外部服务在您的应用程序的新版本推送到 Workflow 时接收通知。
weight: 3
---

它有助于让开发团队了解部署情况，同时也可以用于将不同系统集成在一起。

设置一个或多个钩子后，钩子输出和错误会出现在您的Drycc Grafana应用程序日志中：

```
2011-03-15T15:07:29-07:00 drycc[api]: Deploy hook sent to http://drycc.rocks
```

部署钩子是一个通用的 HTTP 钩子。管理员可以通过 [调整控制器设置][controller-settings] 来创建和配置多个部署钩子。

## HTTP POST 钩子

HTTP 部署钩子对 URL 执行 HTTP POST。请求中包含的参数与钩子消息中可用的变量相同：`app`、`release`、`release_summary`、`sha` 和 `user`。请参见下面的描述：

```
app=secure-woodland&release=v4&release_summary=gabrtv%20deployed%35b3726&sha=35b3726&user=gabrtv
```

可选地，如果通过 [调整控制器设置][controller-settings] 将部署钩子密钥添加到控制器，则 POST 请求中将存在新的 `Authorization` 标头。此标头的值是使用密钥作为密钥计算的请求 URL 的 [HMAC][] 十六进制摘要。

为了验证此请求是否来自 Workflow，请使用密钥、完整 URL 和 HMAC-SHA1 哈希算法来计算签名。在 Python 中，这看起来像这样：

```python
import hashlib
import hmac

hmac.new("my_secret_key", "http://drycc.rocks?app=secure-woodland&release=v4&release_summary=gabrtv%20deployed%35b3726&sha=35b3726&user=gabrtv", digestmod=hashlib.sha1).hexdigest()
```

如果计算的 HMAC 十六进制摘要的值和 `Authorization` 标头中的值相同，则请求来自 Workflow。

{{% alert title="Note" color="danger" %}}
计算签名时，请确保 URL 参数按字母顺序排列。这在计算加密签名时至关重要，因为大多数 Web 应用程序不关心 HTTP 参数的顺序，但加密签名将不会相同。
{{% /alert %}}

[controller-settings]: tuning-component-settings.md#customizing-the-controller
[hmac]: https://en.wikipedia.org/wiki/Hash-based_message_authentication_code
