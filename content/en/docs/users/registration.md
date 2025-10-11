---
title: Users and Registration
linkTitle: Users and Registration
description: Learn how to register users and authenticate with Drycc Workflow
weight: 2
---

Workflow uses the passport component to create and authorize users. It can be configured for LDAP authentication or you can browse the passport website to register users.

## Login to Workflow

If you already have an account, use `drycc login` to authenticate against the Drycc Workflow API.

    $ drycc login http://drycc.example.com
    Opening browser to http://drycc.example.com/v2/login/drycc/?key=4ccc81ee2dce4349ad5261ceffe72c71
    Waiting for login... .o.Logged in as drycc
    Configuration file written to /root/.drycc/client.json

You can also login with username and password:

    $ drycc login http://drycc.example.com --username=demo --password=demo
    Configuration file written to /root/.drycc/client.json

## Logout from Workflow

Logout of an existing controller session using `drycc logout`.

    $ drycc logout
    Logged out as drycc

## Verify Your Session

You can verify your client configuration by running `drycc whoami`.

    $ drycc whoami
    You are drycc at http://drycc.example.com

{{% alert title="Note" color="info" %}}
Session and client configuration is stored in the `~/.drycc/client.json` file.
{{% /alert %}}

[controller]: ../understanding-workflow/components.md#controller
