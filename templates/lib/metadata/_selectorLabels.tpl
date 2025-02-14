{{- /* Selector Labels */ -}}
{{- define "2f.uchart.lib.metadata.selectorLabels" -}}
app.kubernetes.io/name: {{ include "2f.uchart.lib.chart.names.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
