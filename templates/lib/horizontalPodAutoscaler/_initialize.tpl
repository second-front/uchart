{{- /* Initialize horizontalPodAutoscaler values */ -}}
{{- define "2f.uchart.lib.horizontalPodAutoscaler.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $hpaValues := .values -}}
  
  {{- $workloadValues := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.workloads "id" $id "kind" "workload") | fromYaml -}}

  {{- $_ := set $hpaValues "workloadName" ($workloadValues.name | toString) -}}
  {{- $_ := set $hpaValues "workloadType" $workloadValues.type -}}

  {{- /* Return the horizontalPodAutoscaler object */ -}}
  {{- $hpaValues | toYaml -}}
{{- end -}}
