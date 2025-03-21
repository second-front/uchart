{{- /* Convert workload values to an object */ -}}
{{- define "2f.uchart.lib.workload.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Default the workload type to Deployment */ -}}
  {{- if empty (dig "type" nil $objectValues) -}}
    {{- $_ := set $objectValues "type" "deployment" -}}
  {{- end -}}

  {{- $args := (dict "root" $root "resources" $root.Values.workloads "id" $id "values" $objectValues) -}}

  {{- $workloadObject := include "2f.uchart.lib.utils.valuesToObject" $args | fromYaml -}}

  {{- /* Return the workload object */ -}}
  {{- $workloadObject | toYaml -}}
{{- end -}}
