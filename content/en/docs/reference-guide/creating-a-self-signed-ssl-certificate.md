---
title: Creating a Self-Signed SSL Certificate
linkTitle: Creating a Self-Signed SSL Certificate
description: A self-signed TLS/SSL certificate is not signed by a publicly trusted certificate authority (CA) but instead by the developer or company that is responsible for the website.
weight: 1
---


When [using the app SSL feature][app ssl] for non-production applications or when [installing SSL for the platform][platform ssl], you can avoid the costs associated with SSL certificates by using a self-signed SSL certificate. Although the certificate provides full encryption, visitors to your site will see a browser warning indicating that the certificate should not be trusted.

## Prerequisites

The OpenSSL library is required to generate your own certificate. Run the following command in your local environment to check if OpenSSL is already installed:

    $ which openssl
    /usr/bin/openssl

If the `which` command does not return a path, you will need to install OpenSSL:

| Operating System | Installation Command |
|------------------|---------------------|
| Mac OS X | Homebrew: `brew install openssl` |
| Windows | Download complete package .exe installer |
| Ubuntu Linux | `apt-get install openssl` |

## Generate Private Key and Certificate Signing Request

A private key and certificate signing request are required to create an SSL certificate. Generate these with the following commands. When the `openssl req` command asks for a "challenge password", just press return, leaving the password empty.

    $ openssl genrsa -des3 -passout pass:x -out server.pass.key 2048
    ...
    $ openssl rsa -passin pass:x -in server.pass.key -out server.key
    writing RSA key
    $ rm server.pass.key
    $ openssl req -new -key server.key -out server.csr
    ...
    Country Name (2 letter code) [AU]:US
    State or Province Name (full name) [Some-State]:California
    ...
    A challenge password []:
    ...

## Generate SSL Certificate

Generate the self-signed SSL certificate from the `server.key` private key and `server.csr` files:

    $ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

The `server.crt` file is your site certificate, suitable for use with [Drycc's SSL endpoint][app ssl] along with the `server.key` private key.

[app ssl]: ../applications/ssl-certificates.md
[platform ssl]: https://gateway-api.sigs.k8s.io/guides/tls/