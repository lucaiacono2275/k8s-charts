# addons-argocd

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square)

Helm chart for addon resources of ArgoCD installation

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.hostname | string | `"argocd.example.com"` | Hostname |
| ingress.secretName | string | `"tls-secret"` | Name of the tls secret in the ingressRoute of traefik |
| ingress.traefik | bool | `true` | enable traefik configuration |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
