# Package Custom Resource (UDS Operator)

The UDS Operator is installed in the pepr-system namespace as part of the UDS Core bundle. It modifies/creates resources based on the specifications of a "Package" custom resource. It is responsible for the following: 

### Namespace-level Enablement of Istio Sidecar Injection

The namespace where the Package is deployed is labeled with `istio-injection=enabled`.

### Four Network Policies

A minimally configured Package will still deploy 4 "default" network policies. For example, the creation of the following,

```
apiVersion: uds.dev/v1alpha1
kind: Package
metadata:
  name: testing
spec:
  network:
    allow: []
```

will result in the following network policies:

1. deny-<Package.metadata.name>-default

>Contains an empty podSelector and both Ingress & Egress policy types.

2. allow-<Package.metadata.name>-egress-dns-lookup-via-coredns

>Allows traffic from pods within the Package's namespace to perform DNS lookups against CoreDNS on port 53.

3. allow-<Package.metadata.name>-egress-istiod-communication

>Allows traffic from pods in the namespace to the istio pilot on port 15012.

4. allow-<Package.metadata.name>-ingress-sidecar-monitoring

>Allows traffic into the pods on port 15020 within the Package's namespace from Prometheus pods within the `monitoring` namespace. 

## Exposing Traffic via Istio

If you want to expose a web service via istio, define a `spec.network.expose` array where each item maps to an endpoint listed in the package cr specifications. The following, 

```
spec:
  network:
    expose:
      - service: podinfo
        podLabels:
          app: podinfo
        host: podinfo
        gateway: tenant
        port: 9898
```

will result in an Istio Virtual Service with specifications to use an existing gateway (tenant/admin/passthrough) and a downstream service & port. The VS resource will be named according to the values suppled (`podinfo-tenant-podinfo-9898-podinfo`). A corresponding netowork policy to allow ingress traffic to the web app pod will be created by the operator as well. 

## Allowing Additional Network Traffic

The `spec.network.allow` array lets you define additional traffic into and out of the cluster. 

```
spec:
  network:
    allow:
      - direction: Egress
        selector:
          app.kubernetes.io/name: podinfo
        remoteGenerated: Anywhere
        port: 443
```

results in an additional network policy based on the specifications defined in the Package CR manifest. 

