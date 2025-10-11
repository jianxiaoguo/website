---
title: Managing App Gateway
linkTitle: Managing App Gateway
description: Learn how to manage gateways, services, and routes for Drycc applications to control traffic flow and service exposure.
weight: 9
---

A [Gateway][gateway-api] describes how traffic can be translated to services within the cluster. It defines a request for a way to translate traffic from outside the cluster to Kubernetes services. For example, traffic sent to a Kubernetes service by a cloud load balancer, an in-cluster proxy, or an external hardware load balancer. While many use cases have client traffic originating "outside" the cluster, this is not a requirement.

## Create a Gateway for an Application

A gateway is a way of exposing services externally, which generates an external IP address to connect routes and services. After deployment, the gateway is automatically created.

List the gateways:

```
$ drycc gateways
NAME                      LISTENER       PORT     PROTOCOL    ADDRESSES
python-getting-started    tcp-80-0       80       HTTP        101.65.132.51
```

You can also add a port to this gateway or create a new one:

```
$ drycc gateways add python-getting-started --port=443 --protocol=HTTPS
Adding gateway python-getting-started to python-getting-started... done
```

## Create a Service for an Application

A service is a way of exposing services internally, creating a service generates an internal DNS that can access process types. The web process type is created automatically; for other types, you should add them as needed.

List the services:

```
$ drycc services
PTYPE      PORT    PROTOCOL    TARGET-PORT    DOMAIN
web        80      TCP         8000           python-getting-started.python-getting-started.svc
```

Add a new service for a process type:

```
$ drycc services add sleep 8001:8001
```

## Create a Route for an Application

A gateway may be attached to one or more route references which serve to direct traffic for a subset of traffic to a specific service. The web process type is already bound to the gateway and service.

List the routes:

```
$ drycc routes
NAME                           OWNER        KIND           GATEWAYS                              SERVICES
python-getting-started         demo         HTTPRoute      ["python-getting-started:80"]         ["python-getting-started:80"]
```

Create a new route and attach a gateway:

```
$ drycc routes add sleep HTTPRoute --ptype=sleep sleep:8001,100
$ drycc routes attach sleep --gateway=python-getting-started --port=80
```

[gateway-api]: https://gateway-api.sigs.k8s.io/
