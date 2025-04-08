{{- /* Validate StatefulSet values */ -}}
{{- define "2f.uchart.lib.workload.statefulSet.validate" -}}
  {{- $root := .root -}}
  {{- $statefulSetValues := .object -}}

  {{- if and (ne $statefulSetValues.strategy "OnDelete") (ne $statefulSetValues.strategy "RollingUpdate") -}}
    {{- fail (printf "Not a valid strategy type for StatefulSet. (workload: %s, strategy: %s)" $statefulSetValues.id $statefulSetValues.strategy) -}}
  {{- end -}}

  {{- if not (empty (dig "statefulSet" "volumeClaimTemplates" "" $statefulSetValues)) -}}
    {{- range $index, $volumeClaimTemplate := $statefulSetValues.statefulSet.volumeClaimTemplates -}}
      {{- if empty (get . "size") -}}
        {{- fail (printf "size is required for volumeClaimTemplate. (workload: %s, volumeClaimTemplate: %s)" $statefulSetValues.id $volumeClaimTemplate.name) -}}
      {{- end -}}

      {{- if empty (get . "accessMode") -}}
        {{- fail (printf "accessMode is required for volumeClaimTemplate. (workload: %s, volumeClaimTemplate: %s)" $statefulSetValues.id $volumeClaimTemplate.name) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}