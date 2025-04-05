{{- /* Argo Labels */ -}}
{{- define "2f.uchart.lib.metadata.argoLabels" -}}
  {{- $labels := dict
    "argocd.argoproj.io/instance" (include "2f.uchart.lib.chart.names.name" .)
  -}}
  
  {{- $labels | toYaml -}}
{{- end -}}
