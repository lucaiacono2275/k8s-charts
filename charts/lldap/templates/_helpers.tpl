{{/*
Return the proper image name
*/}}
{{- define "lldap.image" -}}
    {{- $registryName := default "docker.io" .Values.image.registry -}}
    {{- $repositoryName := default "lldap/lldap" .Values.image.repository -}}
    {{- $tag := .Values.image.tag | default .Chart.AppVersion  | toString -}}
    {{- if hasPrefix "sha256:" $tag }}
    {{- printf "%s/%s@%s" $registryName $repositoryName $tag -}}
    {{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- end -}}

{{/*
Return the name for this install
*/}}
{{- define "lldap.name" -}}
    {{- if .Values.nameOverride -}}
        {{- .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- $name := default .Chart.Name .Values.nameOverride -}}
        {{- if contains $name .Release.Name -}}
            {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
            {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Return the name for this chart
*/}}
{{- define "lldap.chart" -}}
    {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the app version.
*/}}
{{- define "lldap.version" -}}
    {{ .Values.versionOverride | default .Chart.AppVersion | toString }}
{{- end -}}

{{/*
Returns the name of the forwardAuth Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "lldap.ingress.traefikCRD.middleware.name.forwardAuth" -}}
    {{- if .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
        {{- .Values.ingress.traefikCRD.middlewares.auth.nameOverride -}}
    {{- else -}}
        {{- printf "forwardauth-%s" (include "lldap.name" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if pod is stateful.
*/}}
{{- define "lldap.stateful" -}}
    {{- if .Values.configMap -}}
        {{- if .Values.configMap.enabled -}}
            {{- if .Values.database.local.enabled -}}
                {{- true -}}
            {{- else if and (not .Values.database.mysql.enabled) (not .Values.database.postgres.enabled) -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "lldap.ingress.traefikCRD.middleware.name.chainAuth" -}}
    {{- if .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
        {{- .Values.ingress.traefikCRD.middlewares.chains.auth.nameOverride -}}
    {{- else -}}
        {{- printf "chain-%s-auth" (include "lldap.name" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the name of the chain Middleware for forward auth which gets applied to other IngressRoutes.
*/}}
{{- define "lldap.ingress.traefikCRD.middleware.name.chainIngress" -}}
    {{- printf "chain-%s" (include "authelia.name" .) -}}
{{- end -}}

{{/*
Special Annotations Generator for the Ingress kind.
*/}}
{{- define "lldap.ingress.annotations" -}}
  {{- $annotations := dict -}}
  {{- $annotations = mergeOverwrite $annotations .Values.ingress.annotations -}}
  {{- if .Values.ingress.certManager -}}
  {{- $annotations = set $annotations "kubernetes.io/tls-acme" "true" -}}
  {{- end -}}
  {{- if and .Values.ingress.traefikCRD .Values.ingress.traefikCRD.disableIngressRoute -}}
  {{- if and (gt (len .Values.ingress.traefikCRD.entryPoints) 0) (not (hasKey $annotations "traefik.ingress.kubernetes.io/router.entryPoints")) -}}
  {{- $annotations = set $annotations "traefik.ingress.kubernetes.io/router.entryPoints" (.Values.ingress.traefikCRD.entryPoints | join ",") -}}
  {{- end -}}
  {{- if not (hasKey $annotations "traefik.ingress.kubernetes.io/router.middlewares") }}
  {{- $annotations = set $annotations "traefik.ingress.kubernetes.io/router.middlewares" (printf "%s-%s@kubernetescrd" .Release.Namespace (include "lldap.ingress.traefikCRD.middleware.name.chainIngress" .)) -}}
  {{- end }}
  {{- end -}}
  {{ include "lldap.annotations" (merge (dict "Annotations" $annotations) .) }}
{{- end -}}

{{/*
Returns the common labels
*/}}
{{- define "lldap.labels" -}}
    {{ include "lldap.matchLabels" . }}
app.kubernetes.io/version: {{ include "lldap.version" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ include "lldap.chart" . }}
    {{- if .Values.labels }}
        {{- toYaml .Values.labels | nindent 0 }}
    {{- end }}
    {{- if .Labels }}
        {{- toYaml .Labels | nindent 0 }}
    {{- end }}
{{- end -}}

{{/*
Returns the match labels
*/}}
{{- define "lldap.matchLabels" -}}
app.kubernetes.io/name: {{ .Values.appNameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Returns the common annotations
*/}}
{{- define "lldap.annotations" -}}
    {{- $annotations := dict -}}
    {{- if .Values.annotations -}}
        {{ $annotations = mergeOverwrite $annotations .Values.annotations -}}
    {{- end -}}
    {{- if hasKey . "Annotations" -}}
        {{ $annotations = mergeOverwrite $annotations .Annotations -}}
    {{- end -}}
    {{- if $annotations -}}
        {{- toYaml $annotations | indent 0 -}}
    {{- end -}}
{{- end -}}


{{/*
Returns the kind for the pod.
*/}}
{{- define "lldap.pod.kind" -}}
    {{- if not .Values.pod.kind -}}
        {{- if (include "lldap.stateful" .) -}}
            {{- "StatefulSet" -}}
        {{- else -}}
            {{- "DaemonSet" -}}
        {{- end -}}
    {{- else if eq "daemonset" (.Values.pod.kind | lower) -}}
        {{- "DaemonSet" -}}
    {{- else if eq "statefulset" (.Values.pod.kind | lower) -}}
        {{- "StatefulSet" -}}
    {{- else if eq "deployment" (.Values.pod.kind | lower) -}}
        {{- "Deployment" -}}
    {{- else }}
        {{- if (include "lldap.stateful" .) -}}
            {{- "StatefulSet" -}}
        {{- else -}}
            {{- "DaemonSet" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the deployment strategy
*/}}
{{- define "lldap.deploymentStrategy" -}}
    {{- if .Values.pod.strategy -}}
        {{- if .Values.pod.strategy.type -}}
            {{- if eq "DaemonSet" (include "lldap.pod.kind" .) -}}
                {{- if or (eq .Values.pod.strategy.type "RollingUpdate") (eq .Values.pod.strategy.type "OnDelete") -}}
                    {{- .Values.pod.strategy.type -}}
                {{- else -}}
                    {{- "RollingUpdate" -}}
                {{- end -}}
            {{- else -}}
                {{- if or (eq .Values.pod.strategy.type "RollingUpdate") (eq .Values.pod.strategy.type "Recreate") -}}
                    {{- .Values.pod.strategy.type -}}
                {{- else -}}
                    {{- "RollingUpdate" -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- else -}}
        {{- "RollingUpdate" -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the rollingUpdate spec
*/}}
{{- define "lldap.rollingUpdate" -}}
    {{- $result := dict -}}
    {{- if eq "StatefulSet" (include "lldap.pod.kind" .) -}}
        {{ $result = dict "partition" 0 }}
        {{- if .Values.pod.strategy -}}
            {{- if .Values.pod.strategy.rollingUpdate -}}
                {{- $_ := set $result "partition" (default 0 .Values.pod.strategy.rollingUpdate.partition) -}}
            {{- end -}}
        {{- end -}}
    {{- else if eq "DaemonSet" (include "lldap.pod.kind" .) -}}
        {{ $result = dict "maxUnavailable" "25%" }}
        {{- if .Values.pod.strategy -}}
            {{- if .Values.pod.strategy.rollingUpdate -}}
                {{- $_ := set $result "maxUnavailable" (default "25%" .Values.pod.strategy.rollingUpdate.maxUnavailable) -}}
            {{- end -}}
        {{- end -}}
    {{- else -}}
        {{ $result = dict "maxSurge" "25%" "maxUnavailable" "25%" }}
        {{- if .Values.pod.strategy -}}
            {{- if .Values.pod.strategy.rollingUpdate -}}
                {{- $_ := set $result "maxSurge" (default "25%" .Values.pod.strategy.rollingUpdate.maxSurge) "maxUnavailable" (default "25%" .Values.pod.strategy.rollingUpdate.maxUnavailable) -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
    {{ toYaml $result | indent 0 }}
{{- end -}}

{{/*
Returns the number of replicas
*/}}
{{- define "lldap.replicas" -}}
      {{- if (include "lldap.stateful" .) }}
        {{- 1 -}}
      {{- else -}}
        {{- default 1 .Values.pod.replicas -}}
      {{- end -}}
{{- end -}}

{{/*
Returns the pod management policy
*/}}
{{- define "lldap.podManagementPolicy" -}}
      {{- if (include "lldap.stateful" .) }}
        {{- "Parallel" -}}
      {{- else -}}
        {{- default "Parallel" .Values.pod.managementPolicy -}}
      {{- end -}}
{{- end -}}

{{/*
Returns the ingress hostname with the path
*/}}
{{- define "lldap.ingressHostWithPath" -}}
    {{- printf "%s%s" (include "authelia.ingressHost" .) (include "authelia.path" . | trimSuffix "/") -}}
{{- end -}}


{{/*
Returns true if we should generate a ConfigMap.
*/}}
{{- define "lldap.generate.configMap" -}}
    {{- if include "lldap.enabled.configMap" . -}}
        {{- if not .Values.configMap.existingConfigMap -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a ConfigMap.
*/}}
{{- define "lldap.enabled.configMap" -}}
    {{- if .Values.configMap -}}
        {{- if .Values.configMap.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if we should use a PDB.
*/}}
{{- define "lldap.enabled.podDisruptionBudget" -}}
    {{- if .Values.podDisruptionBudget -}}
        {{- if .Values.podDisruptionBudget.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the secret
*/}}
{{- define "lldap.enabled.secret" -}}
    {{- if .Values.secret -}}
        {{- if not .Values.secret.existingSecret -}}
            {{- true -}}
        {{- else if eq "" .Values.secret.existingSecret -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the NetworkPolicy.
*/}}
{{- define "lldap.enabled.networkPolicy" -}}
    {{- if .Values.networkPolicy -}}
        {{- if .Values.networkPolicy.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the PersistentVolumeClaim.
*/}}
{{- define "lldap.generate.persistentVolumeClaim" -}}
    {{- if include "lldap.enabled.persistentVolumeClaim" . -}}
        {{- if not .Values.persistence.existingClaim -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should generate the PersistentVolumeClaim.
*/}}
{{- define "lldap.enabled.persistentVolumeClaim" -}}
    {{- if .Values.persistence -}}
        {{- if .Values.persistence.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an ingress is enabled.
*/}}
{{- define "lldap.enabled.ingress" -}}
    {{- if .Values.ingress -}}
        {{- if .Values.ingress.enabled -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of the TraefikCRD resources is enabled.
*/}}
{{- define "lldap.enabled.ingress.traefik" -}}
    {{- if (include "lldap.enabled.ingress" .) -}}
        {{- if .Values.ingress.traefikCRD -}}
            {{- if .Values.ingress.traefikCRD.enabled -}}
                {{- true -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an Ingress is enabled.
*/}}
{{- define "lldap.enabled.ingress.ingress" -}}
    {{- if .Values.ingress.enabled -}}
        {{- if or (not (include "lldap.enabled.ingress.traefik" .)) (.Values.ingress.traefikCRD.disableIngressRoute) -}}
            {{- true -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an IngressRoute is enabled.
*/}}
{{- define "lldap.enabled.ingress.ingressRoute" -}}
    {{- if and (include "lldap.enabled.ingress.traefik" .) (not .Values.ingress.traefikCRD.disableIngressRoute) -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Returns if we should use existing TraefikCRD TLSOption
*/}}
{{- define "lldap.enabled.ingress.traefik.tlsOption" -}}
    {{- if .Values.ingress.tls.enabled -}}
        {{- if (include "lldap.enabled.ingress.traefik" .) -}}
            {{- if .Values.ingress.traefikCRD.tls -}}
                {{- if .Values.ingress.traefikCRD.tls.options -}}
                    {{- if not (include "lldap.existing.ingress.traefik.tlsOption" .) -}}
                        {{- true -}}
                    {{- end -}}
                {{- end -}}
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns true if generation of an Ingress is enabled.
*/}}
{{- define "lldap.enabled.ingress.standard" -}}
    {{- if and (include "lldap.enabled.ingress" .) (not (include "lldap.enabled.ingress.traefik" .)) -}}
        {{- true -}}
    {{- end -}}
{{- end -}}

{{/*
Renders a probe
{{ include "lldap.snippets.probe" (dict "Probe" .Values.path.to.the.probe "Method" .Values.path.to.the.method) }}
*/}}
{{- define "lldap.merge.probe" -}}
    {{- if and .Method .Probe .Type -}}
        {{- $probe := dict -}}
        {{- $probe = merge $probe .Method -}}
        {{- $probe = merge $probe .Probe -}}
        {{- if eq "startup" .Type -}}
            {{ toYaml (dict "startupProbe" $probe) }}
        {{- else if eq "liveness" .Type -}}
            {{ toYaml (dict "livenessProbe" $probe) }}
        {{- else if eq "readiness" .Type -}}
            {{ toYaml (dict "readinessProbe" $probe) }}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the service port.
*/}}
{{- define "lldap.service.port" -}}
    {{- if .Values.service -}}
        {{- if .Values.service.port -}}
            {{- .Values.service.port -}}
        {{- else -}}
            {{- 80 -}}
        {{- end -}}
    {{- else -}}
        {{- 80 -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the service ldapPort.
*/}}
{{- define "lldap.service.ldapPort" -}}
    {{- if .Values.service -}}
        {{- if .Values.service.ldapPort -}}
            {{- .Values.service.ldapPort -}}
        {{- else -}}
            {{- 389 -}}
        {{- end -}}
    {{- else -}}
        {{- 389 -}}
    {{- end -}}
{{- end -}}

{{/*
Returns the service ldapsPort.
*/}}
{{- define "lldap.service.ldapsPort" -}}
    {{- if .Values.service -}}
        {{- if .Values.service.ldapsPort -}}
            {{- .Values.service.ldapsPort -}}
        {{- else -}}
            {{- 636 -}}
        {{- end -}}
    {{- else -}}
        {{- 636 -}}
    {{- end -}}
{{- end -}}

{{/*
Wraps something with YAML header/footer
*/}}
{{- define "lldap.wrapYAML" -}}
{{- "---" }}
{{ . }}
{{ "..." }}
{{- end -}}

{{/*
squote a list joined by comma
*/}}
{{- define "lldap.squote.join" -}}
{{- if kindIs "string" . }}{{ . | squote }}
{{- else -}}
{{- range $i, $val := . -}}
{{- if $i -}}
{{- print ", " -}}
{{- end -}}
{{- $val | squote -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
squote a list joined by comma
*/}}
{{- define "lldap.squote.list" -}}
{{- range . }}
- {{ . | squote }}
{{- end }}
{{- end -}}

{{- define "lldap.pod.priorityClassName.enabled" -}}
{{- if and (hasKey .Values.pod "priorityClassName") .Values.pod.priorityClassName (semverCompare ">=1.14-0" (include "capabilities.kubeVersion" .)) }}
{{- true -}}
{{- end }}
{{- end }}


  ##  - "postgres://postgres-user:password@postgres-server/my-database"
  ##  - "mysql://mysql-user:password@mysql-server/my-database"
  ##
  ## This can be overridden with the LLDAP_DATABASE_URL env variable.
  ## database_url = "sqlite:///data/users.db?mode=rwc"

{{/*
return the DB type
*/}}
{{- define "lldap.generate.dbtype" -}}
    {{- with .Values.database -}}
        {{- printf (ternary "postgres" (ternary "mysql" "sqlite" .mysql.enabled) .postgres.enabled) -}}
    {{- end -}}
{{- end -}}

