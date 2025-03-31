{{- /* Validate global chart values */ -}}
{{- define "2f.uchart.lib.chart.validate" -}}
  {{- $root := . -}}

  {{- /* Validate volume values */ -}}
  {{- range $volumeKey, $volumeValues := .Values.volumes }}
    {{- /* Make sure that any advancedMounts workload references actually resolve */ -}}
    {{- range $key, $advancedMount := $volumeValues.advancedMounts -}}
        {{- $mountWorkload := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.workloads "id" $key "kind" "workload") -}}
        {{- if empty $mountWorkload -}}
          {{- fail (printf "No enabled workload found with this id. (volume: '%s', workload: '%s')" $volumeKey $key) -}}
        {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
