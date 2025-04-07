{{- /* Renders the workload objects required by the chart. */ -}}
{{- define "2f.uchart.render.workloads" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.workloads -}}
  {{- $kind := "workload" -}}

  {{- /* Generate named workload objects as required */ -}}
  {{- $enabledWorkloads := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $workload := $enabledWorkloads -}}
    {{- $workloadValues := (mustDeepCopy $workload) -}}

    {{- /* Create object from the raw workload values */ -}}
    {{- $workloadObject := (include "2f.uchart.lib.utils.initialize" (dict "root" $root "id" $key "resources" $resources "values" $workloadValues "kind" $kind)) | fromYaml -}}

    {{- /* Perform validations on the workload before rendering */ -}}
    {{- include "2f.uchart.lib.workload.validate" (dict "root" $root "object" $workloadObject) -}}

    {{- $workloadTypes := list "deployment" "cronJob" "daemonSet" "statefulSet" "job" -}}
    {{- if has $workloadObject.type $workloadTypes -}}
      {{- $args := (dict "root" $root "id" $key "values" $workloadObject) -}}
      {{- $resourceObject := include (printf "2f.uchart.lib.%s.initialize" $workloadObject.type) $args | fromYaml -}}
      {{- include (printf "2f.uchart.lib.%s.validate" $workloadObject.type) (dict "root" $root "object" $resourceObject) -}}
      {{- include (printf "2f.uchart.blueprints.%s" $workloadObject.type) (dict "root" $root "object" $resourceObject) | nindent 0 -}}
    {{- end -}}

    {{- $scalableWorkloadTypes := list "deployment" "statefulSet" -}}
    {{- if has $workloadValues.type $scalableWorkloadTypes -}}
      {{- if dig "autoscaling" "enabled" false $workloadObject -}}
        {{- /* Create object from the raw HPA values */ -}}
        {{- $hpaObject := (include "2f.uchart.lib.utils.initialize" (dict "root" $root "id" $key "values" $workloadObject.autoscaling "kind" "horizontalPodAutoscaler")) | fromYaml -}}

        {{- include "2f.uchart.lib.horizontalPodAutoscaler.validate" (dict "root" $root "object" $hpaObject) -}}
        {{- include "2f.uchart.blueprints.horizontalPodAutoscaler" (dict "root" $root "object" $hpaObject) | nindent 0 -}}
      {{- end -}}

      {{- if dig "pdb" "enabled" false $workloadObject -}}
        {{- /* Create object from the raw pdb values */ -}}
        {{- $pdbObject := (include "2f.uchart.lib.utils.initialize" (dict "root" $root "id" $key "values" $workloadObject.pdb "kind" "podDisruptionBudget")) | fromYaml -}}

        {{- include "2f.uchart.lib.podDisruptionBudget.validate" (dict "root" $root "object" $pdbObject) -}}
        {{- include "2f.uchart.blueprints.podDisruptionBudget" (dict "root" $root "object" $pdbObject) | nindent 0 -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
