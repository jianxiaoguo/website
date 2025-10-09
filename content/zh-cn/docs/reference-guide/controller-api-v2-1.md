---
title: Controller API v2.1
linkTitle: Controller API v2.1
description: 这是 Controller 的 v2.1 REST API。
weight: 4
---

## 新功能

**新增！** 配置中的 `healthcheck` 字段，弃用 `HEALTHCHECK_*` 环境变量。

**新增！** 取消设置不存在的配置变量将返回 422。

**新增！** 创建相同的连续发布将返回 409 而不是创建无操作发布。

## 认证

### 注册新用户

示例请求：

```
POST /v2/auth/register/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json

{
    "username": "test",
    "password": "opensesame",
    "email": "test@example.com"
}
```

可选参数：

```
{
    "first_name": "test",
    "last_name": "testerson"
}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "id": 1,
    "last_login": "2014-10-19T22:01:00.601Z",
    "is_superuser": true,
    "username": "test",
    "first_name": "test",
    "last_name": "testerson",
    "email": "test@example.com",
    "is_staff": true,
    "is_active": true,
    "date_joined": "2014-10-19T22:01:00.601Z",
    "groups": [],
    "user_permissions": []
}
```

### 登录

示例请求：

```
POST /v2/auth/login/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json

{"username": "test", "password": "opensesame"}
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{"token": "abc123"}
```

### 注销账户

示例请求：

```
DELETE /v2/auth/cancel/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

### 重新生成令牌

> **注意**
>
> 此命令可能需要管理员权限

示例请求：

```
POST /v2/auth/tokens/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

可选参数：

```
{
    "username" : "test"
    "all" : "true"
}
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{"token": "abc123"}
```

### 修改密码

示例请求：

```
POST /v2/auth/passwd/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123

{
    "password": "foo",
    "new_password": "bar"
}
```

可选参数：

```
{"username": "testuser"}
```

> **注意**
>
> 使用 `username` 参数需要管理员权限，并使 `password` 参数可选。

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

## 应用

### 列出所有应用

示例请求：

```
GET /v2/apps HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 1,
    "next": null,
    "previous": null,
    "results": [
        {
            "created": "2014-01-01T00:00:00UTC",
            "id": "example-go",
            "owner": "test",
            "structure": {},
            "updated": "2014-01-01T00:00:00UTC",
            "url": "example-go.example.com",
            "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
        }
    ]
}
```

### 创建应用

示例请求：

```
POST /v2/apps/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123
```

可选参数：

```
{"id": "example-go"}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "created": "2014-01-01T00:00:00UTC",
    "id": "example-go",
    "owner": "test",
    "structure": {},
    "updated": "2014-01-01T00:00:00UTC",
    "url": "example-go.example.com",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

### 销毁应用

示例请求：

```
DELETE /v2/apps/example-go/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

### 列出应用详情

示例请求：

```
GET /v2/apps/example-go/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "created": "2014-01-01T00:00:00UTC",
    "id": "example-go",
    "owner": "test",
    "structure": {},
    "updated": "2014-01-01T00:00:00UTC",
    "url": "example-go.example.com",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

### 更新应用详情

示例请求：

```
POST /v2/apps/example-go/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

可选参数：

```
{
  "owner": "test"
}
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 1.8.0
Content-Type: application/json
```

### 获取应用日志

示例请求：

```
GET /v2/apps/example-go/logs/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

可选 URL 查询参数：

```
?log_lines=
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: text/plain

"16:51:14 drycc[api]: test created initial release\n"
```

### 运行一次性命令

```
POST /v2/apps/example-go/run/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123

{"command": "echo hi"}
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{"exit_code": 0, "output": "hi\n"}
```

## 证书

### 列出所有证书

示例请求：

```
GET /v2/certs HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 22,
      "owner": "test",
      "san": [],
      "domains": [],
      "created": "2016-06-22T22:24:20Z",
      "updated": "2016-06-22T22:24:20Z",
      "name": "foo",
      "common_name": "bar.com",
      "fingerprint": "7A:CA:B8:50:FF:8D:EB:03:3D:AC:AD:13:4F:EE:03:D5:5D:EB:5E:37:51:8C:E0:98:F8:1B:36:2B:20:83:0D:C0",
      "expires": "2017-01-14T23:57:57Z",
      "starts": "2016-01-15T23:57:57Z",
      "issuer": "/C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=bar.com/emailAddress=engineering@drycc.cc",
      "subject": "/C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=bar.com/emailAddress=engineering@drycc.cc"
    }
  ]
}
```

### 获取证书详情

示例请求：

```
GET /v2/certs/foo HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
  "id": 22,
  "owner": "test",
  "san": [],
  "domains": [],
  "created": "2016-06-22T22:24:20Z",
  "updated": "2016-06-22T22:24:20Z",
  "name": "foo",
  "common_name": "bar.com",
  "fingerprint": "7A:CA:B8:50:FF:8D:EB:03:3D:AC:AD:13:4F:EE:03:D5:5D:EB:5E:37:51:8C:E0:98:F8:1B:36:2B:20:83:0D:C0",
  "expires": "2017-01-14T23:57:57Z",
  "starts": "2016-01-15T23:57:57Z",
  "issuer": "/C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=bar.com/emailAddress=engineering@drycc.cc",
  "subject": "/C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=bar.com/emailAddress=engineering@drycc.cc"
}
```

### 创建证书

示例请求：

```
POST /v2/certs/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123

{
    "name": "foo"
    "certificate": "-----BEGIN CERTIFICATE-----",
    "key": "-----BEGIN RSA PRIVATE KEY-----"
}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
  "id": 22,
  "owner": "test",
  "san": [],
  "domains": [],
  "created": "2016-06-22T22:24:20Z",
  "updated": "2016-06-22T22:24:20Z",
  "name": "foo",
  "common_name": "bar.com",
  "fingerprint": "7A:CA:B8:50:FF:8D:EB:03:3D:AC:AD:13:4F:EE:03:D5:5D:EB:5E:37:51:8C:E0:98:F8:1B:36:2B:20:83:0D:C0",
  "expires": "2017-01-14T23:57:57Z",
  "starts": "2016-01-15T23:57:57Z",
  "issuer": "/C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=bar.com/emailAddress=engineering@drycc.cc",
  "subject": "/C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=bar.com/emailAddress=engineering@drycc.cc"
}
```

### 销毁证书

示例请求：

```
DELETE /v2/certs/foo HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

### 将域名附加到证书

示例请求：

```
POST /v2/certs/foo/domain/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123

{
    "domain": "test.com"
}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

### 从证书中移除域名

示例请求：

```
DELETE /v2/certs/foo/domain/test.com/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

## Pods

### 列出所有 Pods

示例请求：

```
GET /v2/apps/example-go/pods/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 1,
    "results": [
        {
            "name": "go-v2-web-e7dej",
            "release": "v2",
            "started": "2014-01-01T00:00:00Z",
            "state": "up",
            "type": "web"
        }
    ]
}
```

### 按类型列出所有 Pods

示例请求：

```
GET /v2/apps/example-go/pods/web/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 1,
    "results": [
        {
            "name": "go-v2-web-e7dej",
            "release": "v2",
            "started": "2014-01-01T00:00:00Z",
            "state": "up",
            "type": "web"
        }
    ]
}
```

### 重启所有 Pods

示例请求：

```
POST /v2/apps/example-go/pods/restart/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

[
    {
        "name": "go-v2-web-atots",
        "release": "v2",
        "started": "2016-04-11T21:07:54Z",
        "state": "up",
        "type": "web"
    }
]
```

### 按类型重启 Pods

示例请求：

```
POST /v2/apps/example-go/pods/web/restart/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

[
    {
        "name": "go-v2-web-atots",
        "release": "v2",
        "started": "2016-04-11T21:07:54Z",
        "state": "up",
        "type": "web"
    }
]
```

### 按类型和名称重启 Pods

示例请求：

```
POST /v2/apps/example-go/pods/go-v2-web-atots/restart/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

[
    {
        "name": "go-v2-web-atots",
        "release": "v2",
        "started": "2016-04-11T21:07:54Z",
        "state": "up",
        "type": "web"
    }
]
```

### 缩放 Pods

示例请求：

```
POST /v2/apps/example-go/scale/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123

{"web": 3}
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

## 配置

### 列出应用配置

示例请求：

```
GET /v2/apps/example-go/config/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "owner": "test",
    "app": "example-go",
    "values": {
      "PLATFORM": "drycc"
    },
    "memory": {},
    "cpu": {},
    "tags": {},
    "healthcheck": {},
    "created": "2014-01-01T00:00:00UTC",
    "updated": "2014-01-01T00:00:00UTC",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

### 创建新配置

示例请求：

```
POST /v2/apps/example-go/config/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123

{"values": {"HELLO": "world", "PLATFORM": "drycc"}}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "owner": "test",
    "app": "example-go",
    "values": {
        "DRYCC_APP": "example-go",
        "DRYCC_RELEASE": "v3",
        "HELLO": "world",
        "PLATFORM": "drycc"

    },
    "memory": {},
    "cpu": {},
    "tags": {},
    "healthcheck": {},
    "created": "2014-01-01T00:00:00UTC",
    "updated": "2014-01-01T00:00:00UTC",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

### 取消设置配置变量

示例请求：

```
POST /v2/apps/example-go/config/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123

{"values": {"HELLO": null}}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "owner": "test",
    "app": "example-go",
    "values": {
        "DRYCC_APP": "example-go",
        "DRYCC_RELEASE": "v4",
        "PLATFORM": "drycc"
   },
    "memory": {},
    "cpu": {},
    "tags": {},
    "healthcheck": {},
    "created": "2014-01-01T00:00:00UTC",
    "updated": "2014-01-01T00:00:00UTC",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

## 域名

### 列出应用域名

示例请求：

```
GET /v2/apps/example-go/domains/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 1,
    "next": null,
    "previous": null,
    "results": [
        {
            "app": "example-go",
            "created": "2014-01-01T00:00:00UTC",
            "domain": "example.example.com",
            "owner": "test",
            "updated": "2014-01-01T00:00:00UTC"
        }
    ]
}
```

### 添加域名

示例请求：

```
POST /v2/apps/example-go/domains/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123

{'domain': 'example.example.com'}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "app": "example-go",
    "created": "2014-01-01T00:00:00UTC",
    "domain": "example.example.com",
    "owner": "test",
    "updated": "2014-01-01T00:00:00UTC"
}
```

### 移除域名

示例请求：

```
DELETE /v2/apps/example-go/domains/example.example.com HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

## 构建

### 列出应用构建

示例请求：

```
GET /v2/apps/example-go/build/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "app": "example-go",
    "created": "2014-01-01T00:00:00UTC",
    "dockerfile": "FROM drycc/slugrunner RUN mkdir -p /app WORKDIR /app ENTRYPOINT [\"/runner/init\"] ADD slug.tgz /app ENV GIT_SHA 060da68f654e75fac06dbedd1995d5f8ad9084db",
    "image": "example-go",
    "owner": "test",
    "procfile": {
        "web": "example-go"
    },
    "sha": "060da68f",
    "updated": "2014-01-01T00:00:00UTC",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

### 创建应用构建

示例请求：

```
POST /v2/apps/example-go/build/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123

{"image": "drycc/example-go:latest"}
```

可选参数：

```
{
    "procfile": {
      "web": "./cmd"
    }
}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "app": "example-go",
    "created": "2014-01-01T00:00:00UTC",
    "dockerfile": "",
    "image": "drycc/example-go:latest",
    "owner": "test",
    "procfile": {},
    "sha": "",
    "updated": "2014-01-01T00:00:00UTC",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

## 发布

### 列出应用发布

示例请求：

```
GET /v2/apps/example-go/releases/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 3,
    "next": null,
    "previous": null,
    "results": [
        {
            "app": "example-go",
            "build": "202d8e4b-600e-4425-a85c-ffc7ea607f61",
            "config": "ed637ceb-5d32-44bd-9406-d326a777a513",
            "created": "2014-01-01T00:00:00UTC",
            "owner": "test",
            "summary": "test changed nothing",
            "updated": "2014-01-01T00:00:00UTC",
            "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75",
            "version": 3
        },
        {
            "app": "example-go",
            "build": "202d8e4b-600e-4425-a85c-ffc7ea607f61",
            "config": "95bd6dea-1685-4f78-a03d-fd7270b058d1",
            "created": "2014-01-01T00:00:00UTC",
            "owner": "test",
            "summary": "test deployed 060da68",
            "updated": "2014-01-01T00:00:00UTC",
            "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75",
            "version": 2
        },
        {
            "app": "example-go",
            "build": null,
            "config": "95bd6dea-1685-4f78-a03d-fd7270b058d1",
            "created": "2014-01-01T00:00:00UTC",
            "owner": "test",
            "summary": "test created initial release",
            "updated": "2014-01-01T00:00:00UTC",
            "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75",
            "version": 1
        }
    ]
}
```

### 列出发布详情

示例请求：

```
GET /v2/apps/example-go/releases/v2/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "app": "example-go",
    "build": null,
    "config": "95bd6dea-1685-4f78-a03d-fd7270b058d1",
    "created": "2014-01-01T00:00:00UTC",
    "owner": "test",
    "summary": "test created initial release",
    "updated": "2014-01-01T00:00:00UTC",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75",
    "version": 1
}
```

### 回滚发布

示例请求：

```
POST /v2/apps/example-go/releases/rollback/ HTTP/1.1
Host: drycc.example.com
Content-Type: application/json
Authorization: token abc123

{"version": 1}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{"version": 5}
```

## 密钥

### 列出密钥

示例请求：

```
GET /v2/keys/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 1,
    "next": null,
    "previous": null,
    "results": [
        {
            "created": "2014-01-01T00:00:00UTC",
            "id": "test@example.com",
            "owner": "test",
            "public": "ssh-rsa <...>",
            "updated": "2014-01-01T00:00:00UTC",
            "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
        }
    ]
}
```

### 向用户添加密钥

示例请求：

```
POST /v2/keys/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123

{
    "id": "example",
    "public": "ssh-rsa <...>"
}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "created": "2014-01-01T00:00:00UTC",
    "id": "example",
    "owner": "example",
    "public": "ssh-rsa <...>",
    "updated": "2014-01-01T00:00:00UTC",
    "uuid": "de1bf5b5-4a72-4f94-a10c-d2a3741cdf75"
}
```

### 从用户移除密钥

示例请求：

```
DELETE /v2/keys/example HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

## 权限

### 列出应用权限

> **注意**
>
> 这不包括应用所有者。

示例请求：

```
GET /v2/apps/example-go/perms/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "users": [
        "test",
        "foo"
    ]
}
```

### 创建应用权限

示例请求：

```
POST /v2/apps/example-go/perms/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123

{"username": "example"}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

### 移除应用权限

示例请求：

```
DELETE /v2/apps/example-go/perms/example HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

### 列出管理员

示例请求：

```
GET /v2/admin/perms/ HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 2,
    "next": null
    "previous": null,
    "results": [
        {
            "username": "test",
            "is_superuser": true
        },
        {
            "username": "foo",
            "is_superuser": true
        }
    ]
}
```

### 授予用户管理员权限

> **注意**
>
> 此命令需要管理员权限

示例请求：

```
POST /v2/admin/perms HTTP/1.1
Host: drycc.example.com
Authorization: token abc123

{"username": "example"}
```

示例响应：

```
HTTP/1.1 201 CREATED
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

### 移除用户的管理员权限

> **注意**
>
> 此命令需要管理员权限

示例请求：

```
DELETE /v2/admin/perms/example HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 204 NO CONTENT
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
```

## 用户

### 列出所有用户

> **注意**
>
> 此命令需要管理员权限

示例请求：

```
GET /v2/users HTTP/1.1
Host: drycc.example.com
Authorization: token abc123
```

示例响应：

```
HTTP/1.1 200 OK
DRYCC_API_VERSION: 2.1
DRYCC_PLATFORM_VERSION: 2.1.0
Content-Type: application/json

{
    "count": 1,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 1,
            "last_login": "2014-10-19T22:01:00.601Z",
            "is_superuser": true,
            "username": "test",
            "first_name": "test",
            "last_name": "testerson",
            "email": "test@example.com",
            "is_staff": true,
            "is_active": true,
            "date_joined": "2014-10-19T22:01:00.601Z",
            "groups": [],
            "user_permissions": []
        }
    ]
}
```
