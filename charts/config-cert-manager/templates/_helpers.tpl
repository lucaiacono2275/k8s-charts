{{ define "getTypes"}}
{{ range .Values }}{{ print .type " "}}{{ end }}
{{ end }}