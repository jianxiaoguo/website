---
title: Inter-app Communication
linkTitle: Inter-app Communication
description: Enable communication between Drycc applications using DNS service discovery.
weight: 11
---

Multi-process applications often feature one public-facing process supported by background processes that handle scheduled tasks or queue processing. Implement this architecture on Drycc Workflow by enabling DNS-based communication between applications and hiding supporting processes from public access.

## DNS Service Discovery

Drycc Workflow supports single applications composed of multiple processes. Each application communicates on a single port, so inter-app communication requires discovering the target application's address and port.

All Workflow applications map to port 80 externally. The challenge lies in discovering IP addresses. Workflow creates a [Kubernetes Service](https://kubernetes.io/docs/user-guide/services/) for each application, assigning a name and cluster-internal IP address.

The cluster's DNS service automatically manages DNS records, mapping application names to IP addresses as services start and stop. Applications communicate by sending requests to the service domain name: `app-name.app-namespace`.
