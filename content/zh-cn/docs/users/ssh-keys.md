---
title: 用户和 SSH 密钥
linkTitle: SSH 密钥
description: 为 Drycc 创建、管理和上传 SSH 密钥，用于部署和连接应用程序。
weight: 3
---

对于通过 `git push` 进行的 **Dockerfile** 和 **Buildpack** 基础应用部署，Drycc Workflow 通过 SSH 密钥识别用户。SSH 密钥被推送到平台，并且必须对每个用户唯一。用户可以根据需要拥有多个 SSH 密钥。

## 生成 SSH 密钥

如果您还没有 SSH 密钥或者想为 Drycc Workflow 创建新密钥，请使用 `ssh-keygen` 生成新密钥：

```
$ ssh-keygen -f ~/.ssh/id_drycc -t rsa
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/admin/.ssh/id_drycc.
Your public key has been saved in /Users/admin/.ssh/id_drycc.pub.
The key fingerprint is:
3d:ac:1f:f4:83:f7:64:51:c1:7e:7f:80:b6:70:36:c9 admin@plinth-23437.local
The key's randomart image is:
+--[ RSA 2048]----+
|              .. |
|               ..|
|           . o. .|
|         o. E .o.|
|        S == o..o|
|         o +.  .o|
|        . o + o .|
|         . o =   |
|          .   .  |
+-----------------+
$ ssh-add ~/.ssh/id_drycc
Identity added: /Users/admin/.ssh/id_drycc (/Users/admin/.ssh/id_drycc)
```

## 添加和移除 SSH 密钥

通过将 SSH 密钥的**公钥**部分发布到 Drycc Workflow，负责接收 `git push` 的组件将能够认证用户并确保他们有权访问目标应用。

```
$ drycc keys add ~/.ssh/id_drycc.pub
Uploading id_drycc.pub to drycc... done
```

您还可以随时查看与您的用户关联的密钥：

```
$ drycc keys list
ID                              OWNER    KEY                           
admin@plinth-23437.local        admin    ssh-rsa abc AAAAB3Nz...3437.local
admin@subgenius.local           admin    ssh-rsa 123 AAAAB3Nz...nius.local
```

按名称移除密钥：
```
$ drycc keys remove admin@plinth-23437.local
Removing admin@plinth-23437.local SSH Key... don
```
