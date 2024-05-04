# lldap

![Version: 0.0.8](https://img.shields.io/badge/Version-0.0.8-informational?style=flat-square) ![AppVersion: v0.5.0](https://img.shields.io/badge/AppVersion-v0.5.0-informational?style=flat-square)

Helm chart for deploying LLdap

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| lucaiacono2275 |  |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` |  |
| config | object | `{}` |  |
| configMap.annotations | object | `{}` |  |
| configMap.enabled | bool | `true` | Enable the configMap source for the config. If this is false you need to provide a volumeMount via PV/PVC or other means that mounts to /config. |
| configMap.existingConfigMap | string | `""` |  |
| configMap.labels | object | `{}` |  |
| configMap.mountAsFile | bool | `false` |  |
| database.local.enabled | bool | `false` |  |
| database.local.path | string | `"/data/users.db"` |  |
| database.mysql.database | string | `"lldap"` |  |
| database.mysql.enabled | bool | `false` |  |
| database.mysql.host | string | `"mysql.databases.svc.cluster.local"` |  |
| database.mysql.password | string | `"password"` |  |
| database.mysql.port | int | `3306` |  |
| database.mysql.username | string | `"lldap"` |  |
| database.postgres.database | string | `"lldap"` |  |
| database.postgres.enabled | bool | `false` |  |
| database.postgres.host | string | `"postgres.databases.svc.cluster.local"` |  |
| database.postgres.password | string | `"password"` |  |
| database.postgres.port | int | `5432` |  |
| database.postgres.username | string | `"lldap"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.pullSecrets | list | `[]` |  |
| image.tag | string | `"stable"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hostname | string | `"lldap.example.com"` |  |
| ingress.labels | object | `{}` |  |
| ingress.tls.enabled | bool | `true` |  |
| ingress.tls.secret | string | `"lldap-tls"` |  |
| kubeVersionOverride | string | `""` |  |
| labels | object | `{}` |  |
| ldaps.certPath | string | `"/certs"` |  |
| ldaps.cert_file | string | `"cert.pem"` |  |
| ldaps.enabled | bool | `false` |  |
| ldaps.existingSecret | string | `""` |  |
| ldaps.key_file | string | `"key.pem"` |  |
| ldaps.port | int | `6360` |  |
| networkPolicy.annotations | object | `{}` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.ingress[0].from[0].namespaceSelector.matchLabels.lldap/network-policy | string | `"namespace"` |  |
| networkPolicy.ingress[0].from[1].podSelector.matchLabels.lldap/network-policy | string | `"pod"` |  |
| networkPolicy.ingress[0].ports[0].port | int | `9091` |  |
| networkPolicy.ingress[0].ports[0].protocol | string | `"TCP"` |  |
| networkPolicy.labels | object | `{}` |  |
| networkPolicy.policyTypes[0] | string | `"Ingress"` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `false` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.labels | object | `{}` |  |
| persistence.readOnly | bool | `false` |  |
| persistence.selector | object | `{}` |  |
| persistence.size | string | `"100Mi"` |  |
| persistence.storageClass | string | `""` |  |
| persistence.subPath | string | `""` |  |
| persistence.volumeName | string | `""` |  |
| pod.annotations | object | `{}` |  |
| pod.env | list | `[]` |  |
| pod.extraVolumeMounts | list | `[]` |  |
| pod.extraVolumes | list | `[]` |  |
| pod.kind | string | `"DaemonSet"` |  |
| pod.labels | object | `{}` |  |
| pod.priorityClassName | string | `""` |  |
| pod.probes.liveness.failureThreshold | int | `5` |  |
| pod.probes.liveness.initialDelaySeconds | int | `0` |  |
| pod.probes.liveness.periodSeconds | int | `30` |  |
| pod.probes.liveness.successThreshold | int | `1` |  |
| pod.probes.liveness.timeoutSeconds | int | `5` |  |
| pod.probes.method.httpGet.path | string | `"/"` |  |
| pod.probes.method.httpGet.port | int | `17170` |  |
| pod.probes.readiness.failureThreshold | int | `5` |  |
| pod.probes.readiness.initialDelaySeconds | int | `0` |  |
| pod.probes.readiness.periodSeconds | int | `5` |  |
| pod.probes.readiness.successThreshold | int | `1` |  |
| pod.probes.readiness.timeoutSeconds | int | `5` |  |
| pod.probes.startup.failureThreshold | int | `6` |  |
| pod.probes.startup.initialDelaySeconds | int | `10` |  |
| pod.probes.startup.periodSeconds | int | `5` |  |
| pod.probes.startup.successThreshold | int | `1` |  |
| pod.probes.startup.timeoutSeconds | int | `5` |  |
| pod.replicas | int | `1` |  |
| pod.resources.limits | object | `{}` |  |
| pod.resources.requests | object | `{}` |  |
| pod.revisionHistoryLimit | int | `5` |  |
| pod.securityContext.container | object | `{}` |  |
| pod.securityContext.pod | object | `{}` |  |
| pod.selectors.affinity.nodeAffinity | object | `{}` |  |
| pod.selectors.affinity.podAffinity | object | `{}` |  |
| pod.selectors.affinity.podAntiAffinity | object | `{}` |  |
| pod.selectors.nodeSelector | object | `{}` |  |
| pod.strategy.type | string | `"RollingUpdate"` |  |
| pod.tolerations | list | `[]` |  |
| podDisruptionBudget.annotations | object | `{}` |  |
| podDisruptionBudget.enabled | bool | `false` |  |
| podDisruptionBudget.labels | object | `{}` |  |
| podDisruptionBudget.maxUnavailable | int | `0` |  |
| podDisruptionBudget.minAvailable | int | `0` |  |
| rbac.annotations | object | `{}` |  |
| rbac.enabled | bool | `false` |  |
| rbac.labels | object | `{}` |  |
| rbac.serviceAccountName | string | `"lldap"` |  |
| secret.annotations | object | `{}` |  |
| secret.excludeVolumeAndMounts | bool | `false` |  |
| secret.existingSecret | string | `""` |  |
| secret.labels | object | `{}` |  |
| secret.mountPath | string | `"/data"` |  |
| service.annotations | object | `{}` |  |
| service.clusterIP | object | `{}` |  |
| service.externalIPs | object | `{}` |  |
| service.labels | object | `{}` |  |
| service.ldapPort | int | `389` |  |
| service.ldapsPort | int | `636` |  |
| service.nodePort | int | `30091` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| smtp.enabled | bool | `false` |  |
| smtp.port | int | `587` |  |
| smtp.server | string | `"smtp.mail.svc.cluster.local"` |  |
| versionOverride | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
