# addons-oauth2-proxy

> **:exclamation: This Helm Chart is deprecated!**

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square)

Helm chart for addon resources

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secret.clientId.key | string | `"client-id"` | remote secret key for clientId |
| secret.clientId.property | string | `"client-id"` | remote secret propoerty for clientId |
| secret.clientSecret.key | string | `"client-secret"` | remote secret key for clientSecret |
| secret.clientSecret.property | string | `"client-secret"` | remote secret propoerty for clientSecret |
| secret.cookieSecret.key | string | `"cookie-secret"` | remote secret key for cookieSecret |
| secret.cookieSecret.property | string | `"cookie-secret"` | remote secret propoerty for cookieSecret |
| secret.name | string | `"oauth2-proxy"` | name of the secret |
| secret.remoteSecret.key | string | `"secret/data/oauth2/proxy/secret"` | remote secret key |
| secret.storeKind | string | `"ClusterSecretStore"` | type of the secret store |
| secret.storeName | string | `"vault-backend"` | name of the secret store |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
