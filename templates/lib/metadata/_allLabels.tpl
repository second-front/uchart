{{- /* All Labels */ -}}
{{- define "2f.uchart.lib.metadata.allLabels" -}}
{{ include "2f.uchart.lib.metadata.commonLabels" . }}
{{ include "2f.uchart.lib.metadata.selectorLabels" . }}
{{ include "2f.uchart.lib.metadata.customerLabels" . }}
{{ include "2f.uchart.lib.metadata.argoLabels" . }}
{{ include "2f.uchart.lib.metadata.globalLabels" . }}
{{- end }}
