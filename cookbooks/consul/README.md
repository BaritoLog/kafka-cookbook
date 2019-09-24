# Consul Cookbook

Chef cookbook for provisioning consul cluster.

## Releasing New Version

We need to do these whenever we release a new version:

1. Run
```
bundle exec berks update
bundle exec berks vendor cookbooks
```

2. Commit and updated `cookbooks` directory
3. Tag the commit that we want to release with format `<APP-VERSION>-<REVISION>`

## Building Image

This repo produces LXC image using Packer, see [this](http://packer.io/intro/getting-started/install.html) on how to start using Packer.

The `packer.json` located in this repo uses LXD builder and Chef Solo provisioner. References:

- https://www.packer.io/docs/builders/lxd.html
- http://packer.io/intro/getting-started/provision.html
- https://www.packer.io/docs/provisioners/chef-solo.html

Afterward we can execute these 2 commands toward `packer.json` to build the image.

```
packer validate packer.json
packer build packer.json
```

## Version

This cookbook version will follow consul version with extra revision indicator suffixed. For example:

- `1.1.0-1` means that this is a revision 1 cookbook that will provision consul version `1.1.0`
