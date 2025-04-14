{{- define "2f.uchart.legacy.msvc.configMaps" -}}
{{- if or (.Values.argocd.wrapperAppOff) ( not .Values.subCharts ) }}

{{- range $msvc, $v := .Values.microservices }}
{{- with $v }}
{{- $annotations := $v.annotations | default (dict) }}
  {{- if $v.config }}
    {{- range $configName, $configData := $v.config }}
{{- if and $v (ne $v.enabled false)}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configName }}
  namespace: {{ $v.namespace | default $.Release.Namespace }}
  annotations:
{{- range $key, $value := $annotations }}
    {{ $key }}: {{ $value | quote }}
{{- end }}
data:
{{- range $key, $value := $configData }}
  {{- if contains "\n" $value }}
  {{ $key }}: |
{{- $value | nindent 4 }}
  {{- else }}
  {{ $key }}: {{ $value | quote }}
  {{- end }}
{{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
