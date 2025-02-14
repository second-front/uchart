{{- /* Common Labels */ -}}
{{- define "2f.uchart.lib.metadata.commonLabels" -}}
helm.sh/chart: {{ include "2f.uchart.lib.chart.names.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
