{{- /* Validate workload values */ -}}
{{- define "2f.uchart.lib.workload.validate" -}}
  {{- $root := .root -}}
  {{- $workloadValues := .object -}}

  {{- $allowedWorkloadTypes := list "deployment" "daemonset" "statefulset" "cronjob" "job" -}}
  {{- if not (has $workloadValues.type $allowedWorkloadTypes) -}}
    {{- fail (printf "Not a valid workload.type (%s)" $workloadValues.type) -}}
  {{- end -}}

  {{- $enabledContainers := include "2f.uchart.lib.workload.enabledContainers" (dict "root" $root "workloadObject" $workloadValues) | fromYaml }}
  {{- /* Validate at least one container is enabled */ -}}
  {{- if not $enabledContainers -}}
    {{- fail (printf "No containers enabled for workload (%s)" $workloadValues) -}}
  {{- end -}}
{{- end -}}