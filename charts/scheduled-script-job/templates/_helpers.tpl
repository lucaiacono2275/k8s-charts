{{/*
Return the release-specific name for this install.
*/}}
{{- define "scheduledScriptJob.name" -}}
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

{{- define "scheduledScriptJob.fullname" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else -}}
        {{- include "scheduledScriptJob.name" . -}}
    {{- end -}}
{{- end -}}

{{- define "scheduledScriptJob.serviceAccountName" -}}
    {{- if .Values.serviceAccount.name -}}
        {{- .Values.serviceAccount.name -}}
    {{- else -}}
        {{- include "scheduledScriptJob.fullname" . -}}
    {{- end -}}
{{- end -}}

{{- define "scheduledScriptJob.scriptConfigMapName" -}}
    {{- if .Values.scriptConfigMap -}}
        {{- .Values.scriptConfigMap -}}
    {{- else -}}
        {{- printf "%s-script" (include "scheduledScriptJob.fullname" .) | trunc 63 | trimSuffix "-" -}}
    {{- end -}}
{{- end -}}
