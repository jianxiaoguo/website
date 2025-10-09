---
title: 为应用挂载卷
linkTitle: 管理应用卷
description: Drycc 支持多种类型的卷。一个容器可以同时使用任意数量的卷类型。
weight: 8
---

我们可以使用以下命令创建卷并挂载已创建的卷。
Drycc 创建卷支持 [ReadWriteMany](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes)，因此在部署 drycc 之前，您需要有一个支持 ReadWriteMany 的 StorageClass。
部署 drycc 时，将 controller.appStorageClass 设置为此 StorageClass。

使用 `drycc volumes` 为已部署应用的进程挂载卷。

    $ drycc help volumes
    Valid commands for volumes:

    add              create a volume for the application
    expand           expand a volume for the application
    list             list volumes in the application
    info             print information about a volume
    remove           delete a volume from the application
    client           the client used to manage volume files
    mount            mount a volume to process of the application
    unmount          unmount a volume from process of the application

    Use 'drycc help [command]' to learn more.

## 为应用创建卷

您可以使用 `drycc volumes add` 命令创建 csi 卷。

    $ drycc volumes add myvolume 200M
    Creating myvolume to scenic-icehouse... done

或使用现有的 nfs 服务器

    $ drycc volumes add mynfsvolume 200M -t nfs --nfs-server=nfs.drycc.com --nfs-path=/
    Creating mynfsvolume to scenic-icehouse... done

或使用现有的 oss3

    $ drycc volumes add myossvolume 200M -t oss --oss-server=oss.drycc.com --oss-bucket=vbucket --oss-access-key=ak --oss-secret-key=sk
    Creating myossvolume to scenic-icehouse... done

## 列出应用中的卷

卷创建后，您可以列出此应用中的卷。

    $ drycc volumes list
    NAME          OWNER    TYPE    PTYPE    PATH     SIZE
    myvolume      admin    csi                       200M
    mynfsvolume   admin    nfs                       200M
    myossvolume   admin    oss                       200M

## 挂载卷

名为 myvolume 的卷已创建，您可以使用应用的进程挂载该卷，使用 `drycc volumes mount` 命令。卷挂载时，将自动创建并部署新版本。

    $ drycc volumes mount myvolume web=/data/web
    Mounting volume... done

使用 `drycc volumes list` 显示挂载详情。

    $ drycc volumes list
    NAME       OWNER    TYPE    PTYPE    PATH         SIZE
    myvolume   admin    nfs     web      /data/web    200M

如果您不再需要卷，请使用 `drycc volumes unmount` 卸载卷，然后使用 `drycc volumes remove` 从应用中删除卷。
删除卷之前，必须先卸载卷。

    $ drycc volumes unmount myvolume web
    Unmounting volume... done

    $ drycc volumes remove myvolume
    Deleting myvolume from scenic-icehouse... done

## 使用卷客户端管理卷文件。
假设名为 myvolume 的卷已创建并挂载。

准备一个名为 testfile 的文件。

    $ echo "testtext" > testfile

上传。
    $ drycc volumes client cp testfile vol://myvolume/
    [↑] testfile                       100% [==================================================] (5/ 5 B, 355 B/s)

列出 myvolume 中的文件。

    $ drycc volumes client ls vol://myvolume/
    [2024-07-22T15:32:28+08:00]    5    testfile

删除 myvolume 中的 testfile。

    $ drycc volumes client rm vol://myvolume/testfile