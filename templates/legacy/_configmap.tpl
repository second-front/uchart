{{- define "2f.uchart.legacy.configMap" -}}
{{- if and (or .Values.argocd.wrapperAppOff (not .Values.subCharts)) .Values.config.enabled -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Values.global.applicationName | default .Values.applicationName }}
  namespace: {{ .Release.Namespace }}
  {{- with .Values.config.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
{{ include "universal-app-chart.labels" . | indent 4 }}
data:
{{ toYaml .Values.config.data | indent 2 }}
{{- end }}
{{- end }}
