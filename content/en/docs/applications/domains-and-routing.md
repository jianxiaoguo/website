---
title: Domains and Routing
linkTitle: Domains and Routing
description: Make applications accessible via custom domain names and manage routing.
weight: 13
---

Add or remove custom domains for your application using `drycc domains`:

    $ drycc domains add hello.bacongobbler.com --ptype=web
    Adding hello.bacongobbler.com to finest-woodshed... done

After adding the domain, configure DNS by setting up a CNAME record from your custom domain to the Drycc domain:

    $ dig hello.dryccapp.com
    [...]
    ;; ANSWER SECTION:
    hello.bacongobbler.com.         1759    IN    CNAME    finest-woodshed.dryccapp.com.
    finest-woodshed.dryccapp.com.    270     IN    A        172.17.8.100

{{% alert title="Note" color="info" %}}
Setting a CNAME for a root domain can cause issues. An @ record as a CNAME redirects all traffic to another domain, including mail and SOA records. We recommend using subdomains, but you can work around this by pointing the @ record to the load balancer's IP address.
{{% /alert %}}

## Manage Routing

Control application accessibility through the routing mesh using `drycc routing`:

Disable routing to make the application unreachable externally (but still accessible internally via Kubernetes Service):

    $ drycc routing disable
    Disabling routing for finest-woodshed... done

Re-enable routing to restore external access:

    $ drycc routing enable
    Enabling routing for finest-woodshed... done

[router]: ../understanding-workflow/components.md#router
[service]: ../reference-guide/terms.md#service
