{{- /* Convert workload values to an object */ -}}
{{- define "2f.uchart.lib.workload.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $workloadValues := .values -}}

  {{- /* Default the workload type to Deployment */ -}}
  {{- if empty (dig "type" nil $workloadValues) -}}
    {{- $_ := set $workloadValues "type" "deployment" -}}
  {{- end -}}

  {{- /* Return the workload object */ -}}
  {{- $workloadValues | toYaml -}}
{{- end -}}
