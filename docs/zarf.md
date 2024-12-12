# Zarf

## Disabling Zarf in a Namespace

```
kubectl label namespace <namespace> zarf.dev/agent=ignore 
```

This prevents image pulls from the airgapped registry within the cluster.