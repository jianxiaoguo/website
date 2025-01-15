---
title: Using drycc path
linkTitle: Deploying with drycc path
description: Drycc Container Registry allows you to deploy your Docker-based app to Drycc. Both Common Runtime and Private Spaces are supported.
weight: 15
---

The Drycc stack is intended for advanced use cases only. Unless you have a specific need for custom Docker images, we recommend using Drycc’s default buildpack-powered build system. It offers automatic base image security updates and language-specific optimizations. It also avoids the need to maintain a container Dockerfile.

## Drycc config path overview

A drycc repository comes in two different flavours:

 * a `.drycc` directory at the root of the working tree;

 * a root directory that is a 'bare' repository(i.e. without its own working tree).
   that is typically used for `drycc pull`.

These things may exist in a drycc repository.

```
config/[a-z0-9]+(\.[a-z0-9]+)*::
        Configure file name, file name is group name.
        Format is environment variable format.

[a-z0-9]+(\-[a-z0-9]+)*.(yaml|yml)::
        Pipeline configure file.
```

### Config format

Environment variables follow <NAME>=<VALUE> formatting. By convention, but not rule, environment variable names are always capitalized.

```
DEBUG=true
JVM_OPTIONS=-XX:+UseG1GC
```

### Pipeline format

A manifest has three top-level sections.

- build – Specifies the to build Dockerfile.
- env – Specifies environment variables in container.
- run – Specifies the release phase tasks to execute.
- config – Specifies config group, global group automatic reference.
- deploy – Specifies the commands and args to deploy.

Here’s an example that illustrates using a manifest to build Docker images.

```
kind: pipeline
ptype: web
build:
  docker: Dockerfile
  arg:
    CODENAME: bookworm
env:
  VERSION: 1.2.1
run:
  command:
  - ./deployment-tasks.sh
  image: task
  timeout: 100
config:
- jvm-config
deploy:
  command:
  - bash
  - -ec
  args:
  - bundle exec puma -C config/puma.rb
```

For more deployment information, please refer to the drycc [examples](https://github.com/drycc/samples).
