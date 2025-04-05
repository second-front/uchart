{{- /* Common Labels */ -}}
{{- define "2f.uchart.lib.metadata.commonLabels" -}}
  {{- $labels := dict 
    "helm.sh/chart" (include "2f.uchart.lib.chart.names.chart" .)
    "app.kubernetes.io/managed-by" .Release.Service
  -}}

  {{- if .Chart.AppVersion }}
    {{- $_ := set $labels "app.kubernetes.io/version" (.Chart.AppVersion | toString) -}}
  {{- end }}
  
  {{- $labels | toYaml -}}
{{- end -}}
