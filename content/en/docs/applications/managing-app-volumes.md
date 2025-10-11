---
title: Managing App Volumes
linkTitle: Managing App Volumes
description: Learn how to create, mount, and manage persistent volumes for Drycc applications, including CSI, NFS, and OSS volume types.
weight: 8
---

You can use the commands below to create volumes and mount them to applications. Drycc supports [ReadWriteMany](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes) access mode, so before deploying Drycc, you need to have a StorageClass ready that can support ReadWriteMany. When deploying Drycc, set `controller.appStorageClass` to this StorageClass.

Use `drycc volumes` to mount a volume for a deployed application's processes.

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

## Create a Volume for the Application

You can create a CSI volume with the `drycc volumes add` command:

    $ drycc volumes add myvolume 200M
    Creating myvolume to scenic-icehouse... done

Or use an existing NFS server:

    $ drycc volumes add mynfsvolume 200M -t nfs --nfs-server=nfs.drycc.com --nfs-path=/
    Creating mynfsvolume to scenic-icehouse... done

Or use an existing OSS:

    $ drycc volumes add myossvolume 200M -t oss --oss-server=oss.drycc.com --oss-bucket=vbucket --oss-access-key=ak --oss-secret-key=sk
    Creating myossvolume to scenic-icehouse... done

## List Volumes in the Application

After a volume is created, you can list the volumes in this application:

    $ drycc volumes list
    NAME          OWNER    TYPE    PTYPE    PATH     SIZE
    myvolume      admin    csi                       200M
    mynfsvolume   admin    nfs                       200M
    myossvolume   admin    oss                       200M

## Mount a Volume

The volume named "myvolume" is created. You can mount the volume to a process of the application using the `drycc volumes mount` command. When a volume is mounted, a new release will be created and deployed automatically.

    $ drycc volumes mount myvolume web=/data/web
    Mounting volume... done

Use `drycc volumes list` to show mount details:

    $ drycc volumes list
    NAME       OWNER    TYPE    PTYPE    PATH         SIZE
    myvolume   admin    nfs     web      /data/web    200M

If you no longer need the volume, use `drycc volumes unmount` to unmount the volume and then use `drycc volumes remove` to delete the volume from the application. The volume must be unmounted before it can be deleted.

    $ drycc volumes unmount myvolume web
    Unmounting volume... done

    $ drycc volumes remove myvolume
    Deleting myvolume from scenic-icehouse... done

## Use Volume Client to Manage Volume Files

Assuming the volume named "myvolume" is created and mounted.

Prepare a file named testfile:

    $ echo "testtext" > testfile

Upload the file:

    $ drycc volumes client cp testfile vol://myvolume/
    [↑] testfile                       100% [==================================================] (5/ 5 B, 355 B/s)

List files in myvolume:

    $ drycc volumes client ls vol://myvolume/
    [2024-07-22T15:32:28+08:00]    5    testfile

Delete testfile in myvolume:

    $ drycc volumes client rm vol://myvolume/testfile