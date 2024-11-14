#!/bin/bash/

# kubectl patch networkpolicy -n cert-manager allow-cert-manager-egress-cert-manger-external-connections-dns --type='json' -p='[{"op": "replace", "path": "/spec/egress/0/ports/0/protocol", "value": "UDP"}]'

kubectl create -f issuers/secret-cf-token.yaml
kubectl create -f issuers/letsencrypt-staging.yaml
kubectl create -f certificates/staging/lan-andyg-io.yaml