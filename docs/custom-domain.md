# UDS with a Custom Domain

Relevant UDS Docs:

- [Bundle Overrides](https://uds.defenseunicorns.com/cli/overrides/)
- [Configure Domain Name and TLS for Istio Gateways](https://uds.defenseunicorns.com/cli/overrides/)

## Custom Domain

You can configure a custom domain for your uds core platform by replacing the default *shared domain* (uds.dev) variable value used in [packages throughout uds core](https://github.com/defenseunicorns/uds-core/blob/main/src/istio/zarf.yaml#L8).

To change the domain used by the packages in your bundle, define a `shared.domain` field in your bundle's uds-config.yaml:

```
shared:
  domain: lan.andyg.io 
```

Every pacakge where a *DOMAIN* [variable is defined](https://github.com/defenseunicorns/uds-core/blob/main/src/keycloak/zarf.yaml#L7) will then be able to utilize its value as a [`###ZARF_VAR###`](https://github.com/defenseunicorns/uds-core/blob/main/src/keycloak/chart/values.yaml#L13). 

## TLS Certificates

You'll need to pass in a base64 encoded TLS certificate/key pair for each Istio Gateway to serve. 

The values file used for the ["istio-tenant-gateway"](https://github.com/defenseunicorns/uds-core/blob/main/src/istio/zarf.yaml#L70) component contains the following yaml structure:

```
name: tenant
tls:
  servers:
    keycloak:
      mode: OPTIONAL_MUTUAL
      hosts:
        - "sso"
    tenant:
      mode: SIMPLE
  cert: ...         
  key: ...
```

In order to override the key & cert values, you must target their yaml "paths" appropriately in your bundle's overrides configuration. In this case, the appropriate paths are `tls.cert` & `tls.key`.

### Overrides Configuration

This override applies to one of the charts ([`uds-istio-config`](https://github.com/defenseunicorns/uds-core/blob/main/src/istio/zarf.yaml#L78)) in the `istio-tenant-gateway` component of the `uds-core-istio` package. This package is located part of uds core (`core-slim-dev` in this example)  and can be referenced in a bundle like this:

```
- name: core-slim-dev
    path: ../../src/core-slim-dev
    ref: 0.25.2
    overrides:
      istio-tenant-gateway:
        uds-istio-config:
          variables:
            - name: TENANT_TLS_CERT
              description: "The TLS cert for the tenant gateway (must be base64 encoded)"
              path: tls.cert
            - name: TENANT_TLS_KEY
              description: "The TLS key for the tenant gateway (must be base64 encoded)"
              path: tls.key
```

The overrides are targeting values in the `valuesFiles` of the uds-istio-config chart. The `path` field is able to override default values corresponding to the yaml structure in the values supplied to the chart. 

> Q: If such a path didn't exist in a yaml file, would this varialbe be additive to the values used in the chart?

At this point, you've defined a variable key that you can now override by supplying a corresponding value in your `uds-config.yaml`. This variable to should applied to the relvant package. In the example above that would be `core-slim-dev`. The resulting configuration file would look like this: 

```
variables:
  core-slim-dev:        # Must correspond to the relevant bundle package
    admin_tls_cert:     <base64_cert>
    admin_tls_key:      <base64_key>
    tenant_tls_cert:    <base64_cert>
    tenant_tls_key:     <base64_key>
```

## Verify

```
k get secret gateway-tls -n istio-tenant-gateway -o yaml | yq '.data."tls.crt"' | base64 -d 
```

```
k get gateway -n istio-tenant-gateway tenant-gateway -o yaml | yq '.spec.servers[0].hosts'
```
