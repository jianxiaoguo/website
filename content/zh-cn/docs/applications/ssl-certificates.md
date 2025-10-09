---
title: 应用 SSL 证书
linkTitle: SSL 证书
description: SSL 是一种加密协议，为所有 Web 请求提供端到端加密和完整性。
weight: 14
---

# 应用 SSL 证书

SSL 是一种加密协议，为所有 Web 请求提供端到端加密和完整性。传输敏感数据的应用应启用 SSL，以确保所有信息安全传输。

要在自定义域名（如 `www.example.com`）上启用 SSL，请使用 SSL 端点。

{{% alert title="Note" color="info" %}}
`drycc certs` 仅适用于自定义域名。默认应用域名已启用 SSL，只需使用 https 即可访问，例如 `https://foo.dryccapp.com`（前提是您已在路由器或负载均衡器上[安装了通配符证书][platform-ssl]）。
{{% /alert %}}

## 概述

由于 SSL 验证的独特性质，为您的域名配置 SSL 是一个涉及多个第三方的多步骤过程。您需要：

1. 从 SSL 提供商处购买 SSL 证书
2. 将证书上传到 Drycc


## 获取 SSL 证书

购买 SSL 证书的成本和过程因供应商而异。[RapidSSL][] 提供了一种简单的方式来购买证书，是推荐的解决方案。如果您可以使用此提供商，请参阅[使用 RapidSSL 购买 SSL 证书][]以获取说明。


## DNS 和域名配置

SSL 证书配置完成后，您的证书确认后，您必须通过 Drycc 路由对域名的请求。除非您已经这样做，否则使用以下命令将生成 CSR 时指定的域名添加到您的应用中：

    $ drycc domains add www.example.com --ptype==web -a foo
    Adding www.example.com to foo... done


## 添加证书

使用 `certs:add` 命令将您的证书、任何中间证书和私钥添加到端点。

    $ drycc certs add example-com server.crt server.key -a foo
    Adding SSL endpoint... done
    www.example.com

{{% alert title="Note" color="info" %}}
证书名称只能包含 a-z（小写）、0-9 和连字符
{{% /alert %}}

Drycc 平台将检查证书并从中提取相关信息，如通用名称、主题备用名称 (SAN)、指纹等。

这允许通配符证书和 SAN 中的多个域名，而无需上传重复项。


### 添加证书链

有时，您的证书（如自签名或廉价证书）需要额外的证书来建立信任链。您需要将所有证书捆绑到一个文件中并提供给 Drycc。重要的是，您的站点证书必须是第一个：

    $ cat server.crt server.ca > server.bundle

之后，您可以使用 `certs add` 命令将其添加到 Drycc：

    $ drycc certs add example-com server.bundle server.key -a foo
    Adding SSL endpoint... done
    www.example.com

## 将 SSL 证书附加到域名

证书不会自动连接到域名，而是您必须将证书附加到域名

    $ drycc certs attach example-com example.com -a foo

每个证书可以连接到多个域名。不需要上传重复项。

要删除关联

    $ drycc certs detach example-com example.com -a foo

## 端点概述

您可以使用 `drycc certs` 验证域名的 SSL 配置详情。

    $ drycc certs
    NAME           COMMON-NAME    EXPIRES        SAN                 DOMAINS           
    example-com    example.com    14 Jan 2017    blog.example.com    example.com


或通过查看每个证书的详细信息

    $ drycc certs info example-com -a foo

    === bar-com Certificate
    Common Name(s):     example.com
    Expires At:         2017-01-14 23:57:57 +0000 UTC
    Starts At:          2016-01-15 23:57:57 +0000 UTC
    Fingerprint:        7A:CA:B8:50:FF:8D:EB:03:3D:AC:AD:13:4F:EE:03:D5:5D:EB:5E:37:51:8C:E0:98:F8:1B:36:2B:20:83:0D:C0
    Subject Alt Name:   blog.example.com
    Issuer:             /C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=example.com/emailAddress=engineering@drycc.cc
    Subject:            /C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=example.com/emailAddress=engineering@drycc.cc

    Connected Domains:  example.com
    Owner:              admin-user
    Created:            2016-01-28 19:07:41 +0000 UTC
    Updated:            2016-01-30 00:10:02 +0000 UTC

## 测试 SSL

使用命令行工具如 `curl` 来测试您的安全域名的配置是否正确。

{{% alert title="Note" color="info" %}}
-k 选项标志告诉 curl 忽略不受信任的证书。
{{% /alert %}}

注意输出。它应该打印 `SSL certificate verify ok`。如果它打印类似 `common name: www.example.com (does not match 'www.somedomain.com')` 的内容，则说明配置不正确。

## 在路由器上强制 SSL

要强制所有 HTTP 请求重定向到 HTTPS，可以通过运行以下命令在路由器级别强制 TLS

    $ drycc tls force enable -a foo
    Enabling https-only requests for foo... done

访问应用 HTTP 端点的用户现在将收到 301 重定向到 HTTPS 端点。

要禁用强制 TLS，请运行

    $ drycc tls force disable -a foo
    Disabling https-only requests for foo... done

## 自动证书管理

通过自动证书管理 (ACM)，Drycc 自动管理通用运行时上具有 Hobby 和 Professional dyno 的应用的 TLS 证书，以及启用该功能的私有空间中的应用。由 ACM 处理的证书会在到期前一个月自动续订，每当您添加或删除自定义域名时，会自动创建新证书。所有具有付费 dyno 的应用都免费包含 ACM。自动证书管理使用 Let’s Encrypt，这是免费、自动化和开放的证书颁发机构，用于管理您的应用的 TLS 证书。Let’s Encrypt 由互联网安全研究小组 (ISRG) 为公共利益运营。

使用以下命令启用 ACM：
    $ drycc tls auto enable -a foo

使用以下命令禁用 ACM：
    $ drycc tls auto disable -a foo


## 删除证书

您可以使用 `certs:remove` 命令删除证书：

    $ drycc certs remove my-cert -a foo
    Removing www.example.com... Done.

## 更换证书

在应用的生命周期中，操作员将不得不获取具有新到期日期的证书并将其应用到所有相关应用，下面是更换证书的推荐方法。

有意选择证书名称，尽可能将其命名为 `example-com-2017`，其中年份表示到期年份。这允许在购买新证书时使用 `example-com-2018`。

假设所有应用已经在使用 `example-com-2017`，可以运行以下命令，链接在一起或其他方式：

    $ drycc certs detach example-com-2017 example.com -a foo
    $ drycc certs attach example-com-2018 example.com -a foo

这将处理单个域名，允许操作员验证一切按计划进行，并慢慢将其推广到使用相同方法的任何其他应用。

## 故障排除

如果您的 SSL 端点未按预期工作，以下是一些可以遵循的步骤。


### 不受信任的证书

在某些情况下访问 SSL 端点时，它可能会将您的证书列为不受信任。

如果发生这种情况，可能是因为它不受 Mozilla 的[root CA][]列表信任。如果是这种情况，您的证书可能被许多浏览器视为不受信任。

如果您上传了由根机构签名的证书，但收到消息说它不受信任，则证书有问题。例如，它可能缺少[中间证书][]。如果是这样，从您的 SSL 提供商下载中间证书，从 Drycc 中删除证书，然后重新运行 `certs add` 命令。

[RapidSSL]: https://www.rapidssl.com/
[buy an SSL certificate with RapidSSL]: https://www.rapidssl.com/buy-ssl/
[platform-ssl]: https://gateway-api.sigs.k8s.io/guides/tls/
[root CAs]: https://www.mozilla.org/en-US/about/governance/policies/security-group/certs/included/
[intermediary certificates]: http://en.wikipedia.org/wiki/Intermediate_certificate_authorities
