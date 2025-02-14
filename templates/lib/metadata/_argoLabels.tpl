{{- /* Argo Labels */ -}}
{{- define "2f.uchart.lib.metadata.argoLabels" -}}
argocd.argoproj.io/instance: {{ include "2f.uchart.lib.chart.names.name" . }}
{{- end }}
