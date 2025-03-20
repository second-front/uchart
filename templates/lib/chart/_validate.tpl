{{- /* Validate global chart values */ -}}
{{- define "2f.uchart.lib.chart.validate" -}}
  {{- $root := . -}}

  {{- /* Validate persistence values */ -}}
  {{- range $persistenceKey, $persistenceValues := .Values.persistence }}
    {{- /* Make sure that any advancedMounts workload references actually resolve */ -}}
    {{- range $key, $advancedMount := $persistenceValues.advancedMounts -}}
        {{- $mountWorkload := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.workloads "id" $key) -}}
        {{- if empty $mountWorkload -}}
          {{- fail (printf "No enabled workload found with this id. (persistence item: '%s', workload: '%s')" $persistenceKey $key) -}}
        {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
