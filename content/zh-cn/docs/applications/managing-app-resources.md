---
title: 管理应用的资源
linkTitle: 管理应用资源
description: 用于开发、扩展和操作您的应用的工具和服务。
weight: 10
---

我们可以使用以下命令创建资源并绑定已创建的资源。
此命令依赖于 [service-catalog](https://service-catalog.drycc.cc)。

使用 `drycc resources` 为已部署的应用创建和绑定资源。

    $ drycc help resources
    Manage resources for your applications

    Usage:
    drycc resources [flags]
    drycc resources [command]

    Available Commands:
    services    List all available resource services
    plans       List all available plans for a resource service
    create      Create a resource for the application
    list        List resources in the application
    describe    Get a resource's detail in the application
    update      Update a resource from the application
    bind        Bind a resource for an application
    unbind      unbind a resources for an application
    destroy     Delete a resource from the application

    Flags:
    -a, --app string   The uniquely identifiable name for the application
    -l, --limit int    The maximum number of results to display

    Global Flags:
    -c, --config string   Path to configuration file. (default "~/.drycc/client.json")
    -h, --help            Display help information
    -v, --version         Display client version

    Use "drycc resources [command] --help" for more information about a command.

## 列出所有可用的资源服务

您可以使用 `drycc resources services` 命令列出可用的资源服务

    $ drycc resources services
    ID                                      NAME                  UPDATEABLE
    15032a52-33c2-4b40-97aa-ceb972f51509    airflow               true
    b7cb26a4-b258-445c-860b-a664239a67f8    cloudbeaver           true
    9ce3c3ba-33b5-4e4e-a5e9-a338a83d5070    flink                 true
    b80c51a1-957c-4d93-b3d5-efde84cd8031    fluentbit             true
    fff5b6c7-ed85-429b-8265-493e40cc53c7    grafana               true
    412e368f-bf78-4798-92cc-43343119a57d    kafka                 true
    ea2a9b87-fbc4-4e2a-adee-161c1f91d98d    minio                 true
    383f7316-84f3-4955-8491-1d4b02b749c8    mongodb               true
    fbee746b-f3a7-4bef-8b55-cbecfd4c8ac3    mysql-cluster         true
    5975094d-45cc-4e85-8573-f93937d026c7    opensearch            true
    1db95161-7193-4544-8c76-e5ad5f6c03f6    pmm                   true
    5cfb0abf-276c-445b-9060-9aa964ede87d    postgresql-cluster    true
    b8f70264-eafc-4b2f-848e-2ec0d059032b    prometheus            true
    e1fd0d37-9046-4152-a29b-d155c5657c8b    redis                 true
    7d2b64c6-0b59-4f08-a2f5-7b17cea6e5ee    redis-cluster         true
    2e6877df-86e7-4bcc-a869-2a9b6847a465    seaweedfs             true
    4aea5c0f-9495-420d-896a-ffc61a3eced5    spark                 true
    b50db3b5-8d5f-4be9-b8bd-467ecd6cc11d    zookeeper             true

## 列出资源服务的所有可用计划

您可以使用 `drycc resources plans` 命令列出资源服务的所有可用计划

    $ drycc resources plans redis
    ID                                      NAME              DESCRIPTION
    8d659058-a3b4-4058-b039-cc03a31b9442    standard-128      Redis standard-128 plan which limit resources memory size 128Mi.
    36e3dbec-fc51-4f6b-9baa-e31e316858be    standard-256      Redis standard-256 plan which limit resources memory size 256Mi.
    560817c2-5aa1-41c4-9ee6-a77e3ee552d5    standard-512      Redis standard-512 plan which limit resources memory size 512Mi.
    d544d989-9fb8-43e9-a74e-0840ce1b8f0f    standard-1024     Redis standard-1024 plan which limit resources memory size 1Gi.
    ad51b7bb-9b12-4ffd-8e49-010c0141b263    standard-2048     Redis standard-2048 plan which limit resources memory size 2Gi.
    5097d76e-557c-453f-bdb1-54009e0df78d    standard-4096     Redis standard-4096 plan which limit resources memory size 4Gi.
    be3fa2d0-36d2-47c5-9561-9deffe5ba373    standard-8192     Redis standard-8192 plan which limit resources memory size 8Gi.
    4ca812a8-d7c3-439f-96cd-26523e88400e    standard-16384    Redis standard-16384 plan which limit resources memory size 16Gi.
    b7f2a71f-0d97-48fd-8eed-aab24a7822f3    standard-32768    Redis standard-32768 plan which limit resources memory size 32Gi.
    25c6b5d5-7505-47c8-95b1-dc9bdc698063    standard-65536    Redis standard-65536 plan which limit resources memory size 64Gi.

## 在应用中创建资源

您可以使用 `drycc resources create` 命令创建资源

    $ drycc resources create redis redis standard-128
    Creating redis to scenic-icehouse... done

资源创建后，您可以列出此应用中的资源。

    $ drycc resources list
    UUID                                    NAME     OWNER    PLAN                  UPDATED
    07220e9e-d54d-4d74-a88c-f464aa374386    redis    admin    redis:standard-128    2024-05-08T01:01:00Z

## 绑定资源

名为 redis 的资源已创建，您可以将 redis 绑定到应用，使用 `drycc resources bind redis` 命令。

    $ drycc resources bind redis
    Binding resource... done

## 描述资源

使用 `drycc resources describe` 显示绑定详情。如果绑定成功，此命令将显示连接到资源的信息。

    $ drycc resources describe redis
    === scenic-icehouse resource redis
    plan:               redis:1000
    status:             Ready
    binding:            Ready

    REDISPORT:          6379
    REDIS_PASSWORD:     RzG87SJWG1
    SENTINELHOST:       172.16.0.2
    SENTINELPORT:       26379

## 更新资源

您可以使用 `drycc resources update` 命令升级到新计划。
将计划容量升级到 128MB 的示例：

    $ drycc resources update redis redis standard-128
    Updating redis to scenic-icehouse... done

## 删除资源

如果您不再需要资源，请使用 `drycc resources unbind` 取消绑定资源，然后使用 `drycc resources destroy` 从应用中删除资源。
删除资源之前，必须先取消绑定资源。

    $ drycc resources unbind redis
    Unbinding resource... done

    $ drycc resources destroy redis
    Deleting redis from scenic-icehouse... done
