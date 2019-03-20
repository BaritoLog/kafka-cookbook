# Zookeeper Cookbook

Chef cookbook for provisioning zookeeper cluster.

## Releasing New Version

We need to do these whenever we release a new version:

1. Run
```
bundle exec berks update
bundle exec berks vendor cookbooks
```

2. Commit and updated `cookbooks` directory
3. Tag the commit that we want to release with format `<APP-VERSION>-<REVISION>`

## Version

This cookbook version will follow zookeeper version with extra revision indicator suffixed. For example:

- `3.4.12-1` means that this is a revision 1 cookbook that will provision zookeeper version `3.4.12`

