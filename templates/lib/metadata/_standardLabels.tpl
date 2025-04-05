{{- /* All Labels */ -}}
{{- define "2f.uchart.lib.metadata.standardLabels" -}}
  {{- $labels := mustMerge dict
    (include "2f.uchart.lib.metadata.commonLabels" . | fromYaml)
    (include "2f.uchart.lib.metadata.selectorLabels" . | fromYaml)
    (include "2f.uchart.lib.metadata.customerLabels" . | fromYaml)
    (include "2f.uchart.lib.metadata.argoLabels" . | fromYaml)
  -}}
  
  {{- $labels | toYaml -}}
{{- end }}
