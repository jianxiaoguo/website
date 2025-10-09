---
title: 域名和路由
linkTitle: 域名和路由
description: 通过自定义域名使您的应用可访问。
weight: 13
---

您可以使用 `drycc domains` 向应用程序添加或删除自定义域名：

    $ drycc domains add hello.bacongobbler.com --ptype=web
    Adding hello.bacongobbler.com to finest-woodshed... done

完成后，您可以进入 DNS 注册商并设置从新应用名称到旧应用名称的 CNAME：

    $ dig hello.dryccapp.com
    [...]
    ;; ANSWER SECTION:
    hello.bacongobbler.com.         1759    IN    CNAME    finest-woodshed.dryccapp.com.
    finest-woodshed.dryccapp.com.    270     IN    A        172.17.8.100

{{% alert title="Note" color="info" %}}
为根域名设置 CNAME 可能会导致问题。将 @ 记录设置为 CNAME 会导致所有流量都转到其他域名，包括邮件和 SOA（"start-of-authority"）记录。强烈建议您将子域名绑定到应用程序，但是您可以通过将 @ 记录指向负载均衡器（如果有）的地址来解决这个问题。
{{% /alert %}}

要从路由网格中添加或删除应用程序，请使用 `drycc routing`：

    $ drycc routing disable
    Disabling routing for finest-woodshed... done

这将使应用程序无法通过 [路由器][] 访问，但应用程序仍然可以通过其 [Kubernetes 服务][service] 在内部访问。要重新启用路由：

    $ drycc routing enable
    Enabling routing for finest-woodshed... done


[router]: ../understanding-workflow/components.md#router
[service]: ../reference-guide/terms.md#service
