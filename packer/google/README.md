# Packer templates for Google Cloud

This project contains [Packer][] templates to help you deploy [jarvis][] on [Google cloud][/].

## Prerequisites

* A Google Cloud account
* A Google Compute Engine project
* A Google Compute Engine account file
* A Google Compute Engine Password-less SSH Key

## Configure

The available variables that can be configured are:

* **account_file**: Path to the JSON file used to describe your account credentials, downloaded from Google Cloud Console
* **project_id**: The name of the project to apply any resources to
* **ssh_user**: SSH user
* **region**: The region to operate under (default us-central1)
* **zone**: The zone that the machines should be created in (default us-central1-a)
* **source_image**: The name of the image to base the launched instances (default `debian-9-stretch-v20170619`)
* **machine_type**: The machine type to use for the Hyperion instance (default `n1-standard-1`)

Edit *settings.json* and setup your data.

## Deploy

Build the image

    $ packer build -var-file=settings.json jarvis.json


[Packer]: https://www.packer.io/
[Google cloud]: https://cloud.google.com

[jarvis]: http://github.com/zeiot/jarvis
