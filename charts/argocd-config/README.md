# argocd-config

![Version: 0.4.4](https://img.shields.io/badge/Version-0.4.4-informational?style=flat-square)

Helm chart for config resources

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| lucaiacono2275 | <luca.iacono@gmail.com> |  |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| projects | list | `[{"applications":{"name":"dev-applications","path":"environments/dev","repoURL":"https://github.com/lucaiacono2275/k3s-home","server":"https://kubernetes.default.svc","targetRevision":"HEAD","type":"helmfile"},"clusterResourceWhitelist":[{"group":"*","kind":"*"}],"deploy":[{"name":"external-secrets"}],"destinations":[{"namespace":"*","server":"*"}],"name":"dev","skipCreation":false,"sourceRepos":["*"]}]` | list of projects |
| projects[0] | object | `{"applications":{"name":"dev-applications","path":"environments/dev","repoURL":"https://github.com/lucaiacono2275/k3s-home","server":"https://kubernetes.default.svc","targetRevision":"HEAD","type":"helmfile"},"clusterResourceWhitelist":[{"group":"*","kind":"*"}],"deploy":[{"name":"external-secrets"}],"destinations":[{"namespace":"*","server":"*"}],"name":"dev","skipCreation":false,"sourceRepos":["*"]}` | list of projects |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
