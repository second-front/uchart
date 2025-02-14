{{- /* Return a workload by its id. */ -}}
{{- define "2f.uchart.lib.workload.getById" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}

  {{- $enabledWorkloads := include "2f.uchart.lib.workload.enabledWorkloads" (dict "root" $root) | fromYaml -}}
  {{- $workloadValues := get $enabledWorkloads $id -}}

  {{- if not (empty $workloadValues) -}}
    {{- include "2f.uchart.lib.workload.valuesToObject" (dict "root" $root "id" $id "values" $workloadValues) -}}
  {{- end -}}
{{- end -}}