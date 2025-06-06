# external-secret-instance

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

Helm chart for adding external secrets instances

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| lucaiacono2275 | <luca.iacono@gmail.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| hasPath | bool | `true` | determines if it uses a path for the externalKey |
| refreshInterval | string | `"15s"` | refresh interval |
| secretPath | string | `"secret/data"` | secret path |
| secrets | list | `[{"items":[{"remoteKey":"remoteKey","remoteProperty":"remoteProperty","secretKey":"secretKey"}],"name":"oauth2-proxy","targetTemplate":{}}]` | list of secrets to be instantiated |
| secrets[0] | object | `{"items":[{"remoteKey":"remoteKey","remoteProperty":"remoteProperty","secretKey":"secretKey"}],"name":"oauth2-proxy","targetTemplate":{}}` | name of the secret |
| secrets[0].items | list | `[{"remoteKey":"remoteKey","remoteProperty":"remoteProperty","secretKey":"secretKey"}]` | items in the secret |
| secrets[0].items[0] | object | `{"remoteKey":"remoteKey","remoteProperty":"remoteProperty","secretKey":"secretKey"}` | secret key |
| secrets[0].items[0].remoteKey | string | `"remoteKey"` | remote Key |
| secrets[0].items[0].remoteProperty | string | `"remoteProperty"` | remote property - default: secretKey |
| secrets[0].targetTemplate | object | `{}` | target secret template |
| storeKind | string | `"ClusterSecretStore"` | type of the secret store |
| storeName | string | `"vault-backend"` | name of the secret store |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
