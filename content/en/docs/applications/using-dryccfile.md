---
title: Using drycc.yaml
linkTitle: Deploying with drycc.yaml
description: Drycc Container Registry allows you to deploy your Docker-based app to Drycc. Both Common Runtime and Private Spaces are supported.
weight: 15
---

The Drycc stack is intended for advanced use cases only. Unless you have a specific need for custom Docker images, we recommend using Drycc’s default buildpack-powered build system. It offers automatic base image security updates and language-specific optimizations. It also avoids the need to maintain a .containerDockerfile

## drycc.yaml Overview

A manifest has three top-level sections.

- build – Specifies the to build Dockerfile
- run – Specifies the release phase tasks to execute
- deploy  – Specifies process types and the commands to run for each type

Here’s an example that illustrates using a manifest to build Docker images.

```
build:
  docker:
    web: Dockerfile
    worker: worker/Dockerfile
  config:
    web:
      FOO: bar
    worker:
      RAILS_ENV: development
run:
  command:
  - ./deployment-tasks.sh
  image: worker
deploy:
  web:
    command:
    - bash
    - -ec
    args:
    - bundle exec puma -C config/puma.rb
  worker:
    command:
    - bash
    - -ec
    args:
    - python myworker.py
  asset-syncer:
    command:
    - bash
    - -ec
    args:
    - python asset-syncer.py
    image: worker
```

For more deployment information, please refer to the drycc [examples](https://github.com/drycc/samples).
