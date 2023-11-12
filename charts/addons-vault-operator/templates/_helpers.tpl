{{- define "common.variables" -}}
    {{- $saName := .Values.serviceAccountName | default .Release.Name -}}
    {{- $roleName := .Values.roleName | default .Release.Name -}}
    {{- $roleBindingName := .Values.roleBindingName | default .Release.Name -}}
    {{- $crName := .Values.cr.name | default .Release.Name -}}
{{- end }}