---
title: 创建自签名 SSL 证书
linkTitle: 创建自签名 SSL 证书
description: 自签名 TLS/SSL 证书不是由公开信任的证书颁发机构 (CA) 签发的，而是由负责网站的开发人员或公司签发的。
weight: 1
---

当[使用应用 SSL][app ssl] 功能用于非生产应用程序或[为平台安装 SSL][platform ssl] 时，您可以通过使用自签名 SSL 证书来避免与 SSL 证书相关的成本。虽然证书实现了完全加密，但访问您网站的访客会看到浏览器警告，指示该证书不应被信任。

## 先决条件

需要 openssl 库来生成您自己的证书。在您的本地环境中运行以下命令来查看是否已经安装了 openssl。

    $ which openssl
    /usr/bin/openssl

如果 which 命令没有返回路径，那么您需要自己安装 openssl：

如果您有... | 使用以下方式安装...
---------------|------------------------
Mac OS X       | Homebrew: `brew install openssl`
Windows        | 完整包 .exe 安装
Ubuntu Linux   | `apt-get install openssl`

## 生成私钥和证书签名请求

需要私钥和证书签名请求来创建 SSL 证书。这些可以通过几个简单的命令生成。当 openssl req 命令询问"challenge password"时，只需按回车键，将密码留空。

    $ openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
    ...
    $ openssl rsa -passin pass:x -in server.pass.key -out server.key
    writing RSA key
    $ rm server.pass.key
    $ openssl req -new -key server.key -out server.csr
    ...
    Country Name (2 letter code) [AU]:US
    State or Province Name (full name) [Some-State]:California
    ...
    A challenge password []:
    ...

## 生成 SSL 证书

自签名 SSL 证书是从 server.key 私钥和 server.csr 文件生成的。

    $ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

server.crt 文件是您的站点证书，适合与 [Drycc 的 SSL 端点][app ssl] 一起使用，以及 server.key 私钥。

[app ssl]: ../applications/ssl-certificates.md
[platform ssl]: https://gateway-api.sigs.k8s.io/guides/tls/