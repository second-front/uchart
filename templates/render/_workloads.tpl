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

    {{- $workloadTypes := list "deployment" "cronjob" "daemonset" "statefulset" "job" -}}
    {{- if has $workloadObject.type $workloadTypes -}}
      {{- $args := (dict "root" $root "id" $key "values" $workloadObject) -}}
      {{- $resourceObject := include (printf "2f.uchart.lib.%s.initialize" $workloadObject.type) $args | fromYaml -}}
      {{- include (printf "2f.uchart.lib.%s.validate" $workloadObject.type) (dict "root" $root "object" $resourceObject) -}}
      {{- include (printf "2f.uchart.blueprints.%s" $workloadObject.type) (dict "root" $root "object" $resourceObject) | nindent 0 -}}
    {{- end -}}

    {{- $hpaCompatibleWorkloadTypes := list "deployment" "statefulset" -}}
    {{- if has $workloadValues.type $hpaCompatibleWorkloadTypes -}}
      {{- if dig "autoscaling" "enabled" false $workloadObject -}}
        {{- /* Create object from the raw HPA values */ -}}
        {{- $hpaObject := (include "2f.uchart.lib.utils.initialize" (dict "root" $root "id" $key "values" $workloadObject.autoscaling "kind" "hpa")) | fromYaml -}}

        {{- include "2f.uchart.lib.hpa.validate" (dict "root" $root "object" $hpaObject) -}}
        {{- include "2f.uchart.blueprints.hpa" (dict "root" $root "object" $hpaObject "workloadType" $workloadValues.type) | nindent 0 -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
