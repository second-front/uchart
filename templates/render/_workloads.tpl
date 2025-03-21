{{- /* Renders the workload objects required by the chart. */ -}}
{{- define "2f.uchart.render.workloads" -}}
  {{- $root := $ -}}

  {{- /* Generate named workload objects as required */ -}}
  {{- $enabledWorkloads := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $root.Values.workloads) | fromYaml ) -}}
  {{- range $key, $workload := $enabledWorkloads -}}
    {{- $workloadValues := (mustDeepCopy $workload) -}}

    {{- /* Create object from the raw workload values */ -}}
    {{- $workloadObject := (include "2f.uchart.lib.workload.valuesToObject" (dict "root" $root "id" $key "values" $workloadValues)) | fromYaml -}}

    {{- /* Perform validations on the workload before rendering */ -}}
    {{- include "2f.uchart.lib.workload.validate" (dict "root" $root "object" $workloadObject) -}}

    {{- if eq $workloadObject.type "deployment" -}}
      {{- $deploymentObject := (include "2f.uchart.lib.deployment.valuesToObject" (dict "root" $root "id" $key "values" $workloadObject)) | fromYaml -}}
      {{- include "2f.uchart.lib.deployment.validate" (dict "root" $root "object" $deploymentObject) -}}
      {{- include "2f.uchart.blueprints.deployment" (dict "root" $root "object" $deploymentObject) | nindent 0 -}}

    {{- else if eq $workloadObject.type "cronjob" -}}
      {{- $cronjobObject := (include "2f.uchart.lib.cronjob.valuesToObject" (dict "root" $root "id" $key "values" $workloadObject)) | fromYaml -}}
      {{- include "2f.uchart.lib.cronjob.validate" (dict "root" $root "object" $cronjobObject) -}}
      {{- include "2f.uchart.blueprints.cronjob" (dict "root" $root "object" $cronjobObject) | nindent 0 -}}

    {{- else if eq $workloadObject.type "daemonset" -}}
      {{- $daemonsetObject := (include "2f.uchart.lib.daemonset.valuesToObject" (dict "root" $root "id" $key "values" $workloadObject)) | fromYaml -}}
      {{- include "2f.uchart.lib.daemonset.validate" (dict "root" $root "object" $daemonsetObject) -}}
      {{- include "2f.uchart.blueprints.daemonset" (dict "root" $root "object" $daemonsetObject) | nindent 0 -}}

    {{- else if eq $workloadObject.type "statefulset"  -}}
      {{- $statefulsetObject := (include "2f.uchart.lib.statefulset.valuesToObject" (dict "root" $root "id" $key "values" $workloadObject)) | fromYaml -}}
      {{- include "2f.uchart.lib.statefulset.validate" (dict "root" $root "object" $statefulsetObject) -}}
      {{- include "2f.uchart.blueprints.statefulset" (dict "root" $root "object" $statefulsetObject) | nindent 0 -}}

    {{- else if eq $workloadObject.type "job"  -}}
      {{- $jobObject := (include "2f.uchart.lib.job.valuesToObject" (dict "root" $root "id" $key "values" $workloadObject)) | fromYaml -}}
      {{- include "2f.uchart.lib.job.validate" (dict "root" $root "object" $jobObject) -}}
      {{- include "2f.uchart.blueprints.job" (dict "root" $root "object" $jobObject) | nindent 0 -}}
    {{- end -}}

    {{- $hpaCompatibleWorkloadTypes := list "deployment" "statefulset" -}}
    {{- if has $workloadValues.type $hpaCompatibleWorkloadTypes -}}
      {{- if dig "autoscaling" "enabled" false $workloadObject -}}
        {{- /* Create object from the raw HPA values */ -}}
        {{- $hpaObject := (include "2f.uchart.lib.hpa.valuesToObject" (dict "root" $root "id" $key "values" $workloadObject.autoscaling)) | fromYaml -}}

        {{- include "2f.uchart.lib.hpa.validate" (dict "root" $root "object" $hpaObject) -}}
        {{- include "2f.uchart.blueprints.hpa" (dict "root" $root "object" $hpaObject "workloadType" $workloadValues.type) | nindent 0 -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
