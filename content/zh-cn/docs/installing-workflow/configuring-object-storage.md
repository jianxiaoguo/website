---
title: 配置对象存储
linkTitle: 配置对象存储
description: 各种 Drycc Workflow 组件依赖对象存储系统来完成工作，包括存储应用程序 slugs、容器镜像和数据库日志。
weight: 4
---

Drycc Workflow 默认附带 [Storage][storage]，它提供集群内存储。

## 配置集群外对象存储

每个依赖对象存储的组件使用两个输入进行配置：

1. 您必须使用与 S3 API 兼容的对象存储服务
2. 访问凭据存储为名为 `storage-creds` 的 Kubernetes secret

Drycc Workflow 的 helm chart 可以轻松配置以将 Workflow 组件连接到集群外对象存储。Drycc Workflow 目前支持 Google Compute Storage、Amazon S3、[Azure Blob Storage][] 和 OpenStack Swift Storage。

### 步骤 1：创建存储桶

为每个 Workflow 子系统创建存储桶：`builder`、`registry` 和 `database`。

根据您选择的对象存储，您可能需要提供全局唯一的桶名称。如果您使用 S3，请在桶名称中使用连字符而不是句点。在桶名称中使用句点会导致 [S3 的 ssl 证书验证问题](https://forums.aws.amazon.com/thread.jspa?threadID=105357)。

如果您提供对底层存储有足够访问权限的凭据，Workflow 组件将在桶不存在时创建它们。

### 步骤 2：生成存储凭据

如果适用，生成对步骤 1 中创建的存储桶具有创建和写入访问权限的凭据。

如果您使用 AWS S3 并且您的 Kubernetes 节点通过 InstanceRoles 配置了适当的 [IAM][aws-iam] API 密钥，您不需要创建 API 凭据。但是，请验证 InstanceRole 对配置的桶具有适当的权限！

### 步骤 3：配置 Workflow Chart

操作员应该在运行 `helm install` 之前通过编辑 Helm values 文件来配置对象存储。为此：

* 通过运行 `helm inspect values oci://registry.drycc.cc/charts/workflow > values.yaml` 获取 Helm values
* 更新 `global/storage` 参数以引用您使用的平台，例如 `s3`、`azure`、`gcs` 或 `swift`
* 找到您的存储类型的相应部分，并提供适当的值，包括区域、桶名称和访问凭据。
* 保存您的更改。

{{% alert title="Note" color="info" %}}
所有值将自动进行 base64 编码，_除了_ `gcs`/`gcr` 下的 `key_json` 值。这些必须进行 base64 编码。这是为了支持通过 `helm --set` cli 功能干净地传递所述编码文本，而不是尝试传递原始 JSON 数据。例如：

	$ helm install drycc oci://registry.drycc.cc/charts/workflow \
		--namespace drycc \
		--set global.platformDomain=youdomain.com
		--set global.storage=gcs,gcs.key_json="$(cat /path/to/gcs_creds.json | base64 -w 0)"
{{% /alert %}}

现在您可以使用所需的集群外对象存储运行 `helm install drycc oci://registry.drycc.cc/charts/workflow --namespace drycc -f values.yaml`。


[storage]: ../understanding-workflow/components.md#object-storage
[aws-iam]: http://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html
[Azure Blob Storage]: https://azure.microsoft.com/en-us/services/storage/blobs/
