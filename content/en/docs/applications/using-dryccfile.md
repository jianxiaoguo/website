---
title: Using drycc.yaml
linkTitle: Deploying with drycc.yaml
description: Drycc Container Registry allows you to deploy your Docker-based app to Drycc. Both Common Runtime and Private Spaces are supported.
weight: 15
---

The Drycc stack is intended for advanced use cases only. Unless you have a specific need for custom Docker images, we recommend using Drycc’s default buildpack-powered build system. It offers automatic base image security updates and language-specific optimizations. It also avoids the need to maintain a .containerDockerfile

## drycc.yaml Overview

A manifest has three top-level sections.

- build – Specifies the to build Dockerfile.
- run – Specifies the release phase tasks to execute.
- config -  Specifies config group, global group automatic reference.
- deploy  – Specifies process types and the commands to run for each type.

Here’s an example that illustrates using a manifest to build Docker images.

```
build:
  docker:
    web: Dockerfile
    worker: worker/Dockerfile
  config:
    web:
    - name: FOO
      value: bar
    worker:
    - name: RAILS_ENV
      value: development
config:
  global:
  - name: DEBUG
    value: "true"
  jvm-config:
  - name: JAVA_OPTIONS
    value: -Xms512m -Xmx1024m -XX:PermSize=128m
run:
- command:
  - ./deployment-tasks.sh
  image: worker
  # If the field is empty, it means it will be executed forever
  when:
    ptypes:
    - web
    - webbbsbs
  # Maximum execution time
  timeout: 100
deploy:
  web:
    command:
    - bash
    - -ec
    args:
    - bundle exec puma -C config/puma.rb
    config:
      env:
      - name: PORT
        value: 5000
      ref:
      - jvm-config
    # https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
    healthcheck:
      livenessProbe:
        httpGet:
          path: /healthz
          port: 8080
        initialDelaySeconds: 3
        periodSeconds: 3
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
