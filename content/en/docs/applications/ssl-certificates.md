---
title: SSL Certificates
linkTitle: SSL Certificates
description: Configure SSL certificates for secure HTTPS connections on custom domains in Drycc applications.
weight: 14
---

SSL is a cryptographic protocol that provides end-to-end encryption and integrity for all web requests. Applications that transmit sensitive data should enable SSL to ensure all information is transmitted securely.

To enable SSL on a custom domain, such as `www.example.com`, use the SSL certificate endpoint.

{{% alert title="Note" color="info" %}}
The `drycc certs` command is only useful for custom domains. Default application domains are SSL-enabled by default and can be accessed using HTTPS, for example `https://foo.dryccapp.com` (provided that you have [installed your wildcard certificate][platform-ssl] on the routers or load balancer).
{{% /alert %}}

## Overview

Due to the unique nature of SSL validation, provisioning SSL for your domain is a multi-step process that involves several third parties. You will need to:

1. Purchase an SSL certificate from your SSL provider
2. Upload the certificate to Drycc

## Acquire an SSL Certificate

Purchasing an SSL certificate varies in cost and process depending on the vendor. [RapidSSL][] offers a simple way to purchase a certificate and is a recommended solution. If you can use this provider, see [buy an SSL certificate with RapidSSL][] for instructions.

## DNS and Domain Configuration

Once the SSL certificate is provisioned and confirmed, you must route requests for your domain through Drycc. Unless you've already done so, add the domain specified when generating the CSR to your application with:

    $ drycc domains add www.example.com --ptype=web -a foo
    Adding www.example.com to foo... done

## Add a Certificate

Add your certificate, any intermediate certificates, and private key to the endpoint using the `certs:add` command.

    $ drycc certs add example-com server.crt server.key -a foo
    Adding SSL endpoint... done
    www.example.com

{{% alert title="Note" color="info" %}}
The certificate name can only contain lowercase letters (a-z), numbers (0-9), and hyphens.
{{% /alert %}}

The Drycc platform will examine the certificate and extract relevant information such as the Common Name, Subject Alternative Names (SAN), fingerprint, and more.

This allows for wildcard certificates and multiple domains in the SAN without uploading duplicates.

### Add a Certificate Chain

Sometimes certificates (such as self-signed or inexpensive certificates) require additional certificates to establish the chain of trust. Bundle all certificates into one file with your site's certificate first:

    $ cat server.crt server.ca > server.bundle

Then add them to Drycc using the `certs add` command:

    $ drycc certs add example-com server.bundle server.key -a foo
    Adding SSL endpoint... done
    www.example.com

## Attach SSL Certificate to a Domain

Certificates are not automatically connected to domains. You must manually attach a certificate to a domain:

    $ drycc certs attach example-com example.com -a foo

Each certificate can be connected to multiple domains. There is no need to upload duplicates.

To remove an association:

    $ drycc certs detach example-com example.com -a foo

## Certificate Overview

You can verify the details of your domain's SSL configuration with `drycc certs`:

    $ drycc certs
    NAME           COMMON-NAME    EXPIRES        SAN                 DOMAINS
    example-com    example.com    14 Jan 2017    blog.example.com    example.com

Or view detailed information for each certificate:

    $ drycc certs info example-com -a foo

    === bar-com Certificate
    Common Name(s):     example.com
    Expires At:         2017-01-14 23:57:57 +0000 UTC
    Starts At:          2016-01-15 23:57:57 +0000 UTC
    Fingerprint:        7A:CA:B8:50:FF:8D:EB:03:3D:AC:AD:13:4F:EE:03:D5:5D:EB:5E:37:51:8C:E0:98:F8:1B:36:2B:20:83:0D:C0
    Subject Alt Name:   blog.example.com
    Issuer:             /C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=example.com/emailAddress=engineering@drycc.cc
    Subject:            /C=US/ST=CA/L=San Francisco/O=Drycc/OU=Engineering/CN=example.com/emailAddress=engineering@drycc.cc

    Connected Domains:  example.com
    Owner:              admin-user
    Created:            2016-01-28 19:07:41 +0000 UTC
    Updated:            2016-01-30 00:10:02 +0000 UTC

## Testing SSL

Use a command-line utility like `curl` to test that everything is configured correctly for your secure domain.

{{% alert title="Note" color="info" %}}
The `-k` option tells curl to ignore untrusted certificates.
{{% /alert %}}

Pay attention to the output. It should print `SSL certificate verify ok`. If it prints something like `common name: www.example.com (does not match 'www.somedomain.com')`, then something is not configured correctly.

## Enforce SSL at the Router

To enforce that all HTTP requests are redirected to HTTPS, enable TLS enforcement at the router level:

    $ drycc tls force enable -a foo
    Enabling https-only requests for foo... done

Users hitting the HTTP endpoint for the application will now receive a 301 redirect to the HTTPS endpoint.

To disable enforced TLS:

    $ drycc tls force disable -a foo
    Disabling https-only requests for foo... done

## Automated Certificate Management

With Automated Certificate Management (ACM), Drycc automatically manages TLS certificates for applications with Hobby and Professional dynos on the Common Runtime, and for applications in Private Spaces that enable the feature.

Certificates handled by ACM automatically renew one month before they expire, and new certificates are created automatically whenever you add or remove a custom domain. All applications with paid dynos include ACM for free.

Automated Certificate Management uses Let's Encrypt, the free, automated, and open certificate authority for managing your application's TLS certificates. Let's Encrypt is run for the public benefit by the Internet Security Research Group (ISRG).

To enable ACM:

    $ drycc tls auto enable -a foo

To disable ACM:

    $ drycc tls auto disable -a foo

## Remove a Certificate

You can remove a certificate using the `certs:remove` command:

    $ drycc certs remove my-cert -a foo
    Removing www.example.com... Done.

## Swapping Certificates

Over the lifetime of an application, you will need to acquire certificates with new expiration dates and apply them to all relevant applications. The recommended way to swap certificates is:

Be intentional with certificate names, such as `example-com-2017`, where the year signifies the expiry year. This allows for `example-com-2018` when a new certificate is purchased.

Assuming all applications are already using `example-com-2017`, run the following commands (they can be chained together):

    $ drycc certs detach example-com-2017 example.com -a foo
    $ drycc certs attach example-com-2018 example.com -a foo

This handles a single domain, allowing you to verify everything worked as planned and slowly roll it out to other applications using the same method.

## Troubleshooting

Here are some steps you can follow if your SSL endpoint is not working as expected.

### Untrusted Certificate

In some cases when accessing the SSL endpoint, it may list your certificate as untrusted.

If this occurs, it may be because it is not trusted by Mozilla's list of [root CAs][]. If this is the case, your certificate may be considered untrusted for many browsers.

If you have uploaded a certificate that was signed by a root authority but you get the message that it is not trusted, then something is wrong with the certificate. For example, it may be missing [intermediate certificates][]. If so, download the intermediate certificates from your SSL provider, remove the certificate from Drycc, and re-run the `certs add` command.

[RapidSSL]: https://www.rapidssl.com/
[buy an SSL certificate with RapidSSL]: https://www.rapidssl.com/buy-ssl/
[platform-ssl]: https://gateway-api.sigs.k8s.io/guides/tls/
[root CAs]: https://www.mozilla.org/en-US/about/governance/policies/security-group/certs/included/
[intermediate certificates]: http://en.wikipedia.org/wiki/Intermediate_certificate_authorities
