{{/*
Return the name for this install
*/}}
{{- define "chart.name" -}}
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
Return the name for the service
*/}}
{{- define "service.name" -}}
    {{- if .Values.service.name -}}
        {{- .Values.service.name -}}
    {{- else -}}
        {{- print (include "chart.name" .) "-external-service" -}}
    {{- end -}}
{{- end -}}

