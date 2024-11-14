# UDS Lab

Modular dev environment for testing/learning purposes. 

The main benefit of using this bundle is that it allows you to decouple the `uds-k3d` and zarf `init` packages from the bundle offerings (standard and slim-dev) from UDS Core. It may be beneficial to build tooling around this process in the future.

## UDS Core

From the root of the [uds-core repository](https://github.com/defenseunicorns/uds-core/tree/main) you can execute the following command with the `UDS_PKG` flag set to target a single package within the core source code. 

```
uds run create-single-package --set UDS_PKG=prometheus-stack
```

You can then copy over the resulting zarf package from the `/build` dir that is created in the uds-core repo for consumption in subsequent tasks. 

> the prometheus-stack package is special in that it is an explicit requirement for the [made for uds badge](https://github.com/defenseunicorns/uds-common/blob/main/docs/uds-package-practices.md) 

