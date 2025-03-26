{{- /* Validate StatefulSet values */ -}}
{{- define "2f.uchart.lib.statefulset.validate" -}}
  {{- $root := .root -}}
  {{- $statefulsetValues := .object -}}

  {{- if and (ne $statefulsetValues.strategy "OnDelete") (ne $statefulsetValues.strategy "RollingUpdate") -}}
    {{- fail (printf "Not a valid strategy type for StatefulSet. (workload: %s, strategy: %s)" $statefulsetValues.id $statefulsetValues.strategy) -}}
  {{- end -}}

  {{- if not (empty (dig "statefulset" "volumeClaimTemplates" "" $statefulsetValues)) -}}
    {{- range $index, $volumeClaimTemplate := $statefulsetValues.statefulset.volumeClaimTemplates -}}
      {{- if empty (get . "size") -}}
        {{- fail (printf "size is required for volumeClaimTemplate. (workload: %s, volumeClaimTemplate: %s)" $statefulsetValues.id $volumeClaimTemplate.name) -}}
      {{- end -}}

      {{- if empty (get . "accessMode") -}}
        {{- fail (printf "accessMode is required for volumeClaimTemplate. (workload: %s, volumeClaimTemplate: %s)" $statefulsetValues.id $volumeClaimTemplate.name) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}