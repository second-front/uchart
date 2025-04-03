{{- /* Convert hpa values to an object */ -}}
{{- define "2f.uchart.lib.hpa.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $hpaValues := .values -}}
  
  {{- $workloadValues := include "2f.uchart.lib.workload.getById" (dict "root" $root "resources" $root.Values.workloads "id" $id "kind" "workload") | fromYaml -}}

  {{- $_ := set $hpaValues "workloadName" ($workloadValues.name | toString) -}}
  {{- $_ := set $hpaValues "workloadType" $workloadValues.type -}}

  {{- /* Return the workload object */ -}}
  {{- $hpaValues | toYaml -}}
{{- end -}}
