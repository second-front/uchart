{{- /* Validate ServiceAccount values */ -}}
{{- define "2f.uchart.lib.serviceAccount.validate" -}}
  {{- $root := .root -}}
  {{- $serviceAccountObject := .object -}}
  
  {{- with $serviceAccountObject.workload -}}
    {{- $serviceAccountWorkload := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.workloads "id" . "kind" "workload") -}}
    {{- if empty $serviceAccountWorkload -}}
      {{- fail (printf "No enabled workload found with this id. (serviceAccount: '%s', workload: '%s')" $serviceAccountObject.id .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
