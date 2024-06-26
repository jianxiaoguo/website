---
title: Users and Registration
linkTitle: Users and Registration
description: Get started on Drycc today
weight: 2
---

Workflow use the passport component to create and authorize users, it can config options for LDAP authentication or browse passport web site to register users.

## Login to Workflow

If you already have an account, use `drycc login` to authenticate against the Drycc Workflow API.

    $ drycc login http://drycc.example.com
    Opening browser to http://drycc.example.com/v2/login/drycc/?key=4ccc81ee2dce4349ad5261ceffe72c71
    Waiting for login... .o.Logged in as drycc
    Configuration file written to /root/.drycc/client.json

Or you can login with username and password
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

!!! note
    Session and client configuration is stored in the `~/.drycc/client.json` file.

[controller]: ../understanding-workflow/components.md#controller
