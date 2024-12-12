
## Logging into Grafana

When deploying what is now known as `core-identity-authorization` and utilizing the uds-common task library to bootstrap the "doug" user, you will first need to add that user to the Admin child group (UDS Core group) in the Keycloak Admin portal. 

> How does membership to this group provide access to grafana specifically? It's not 1:1 specific to the grafana documentation which indicates the need for specific roles being present on the client itslef (admin, editor, viewer). 

