kubectl get secret lan-andyg-io-production-tls -n default -o jsonpath='{.data.tls\.crt}' | base64 -d > /tmp/tls.crt
kubectl get secret lan-andyg-io-production-tls -n default -o jsonpath='{.data.tls\.key}' | base64 -d > /tmp/tls.key