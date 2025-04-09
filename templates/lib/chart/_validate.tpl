{{- /* Validate global chart values */ -}}
{{- define "2f.uchart.lib.chart.validate" -}}
  {{- $root := . -}}

  {{- /* Validate volume values */ -}}
  {{- range $volumeKey, $volumeValues := .Values.volumes -}}
    {{- /* Make sure that any advancedMounts workload references actually resolve */ -}}
    {{- range $key, $advancedMount := $volumeValues.advancedMounts -}}
        {{- $mountWorkload := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.workloads "id" $key "kind" "workload") -}}
        {{- if empty $mountWorkload -}}
          {{- fail (printf "No enabled workload found with this id. (volume: '%s', workload: '%s')" $volumeKey $key) -}}
        {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- /* Validate serviceAccount Values */ -}}
  {{- $serviceAccountWorkloads := list -}}
  {{- $enabledServiceAccounts := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" .Values.serviceAccounts) | fromYaml -}}
  {{- range $id, $serviceAccount := $enabledServiceAccounts -}}
    {{- with $serviceAccount.workload -}}
      {{- if mustHas . $serviceAccountWorkloads -}}
        {{- fail (printf "multiple ServiceAccounts enabled with workload id, workloads can only have one serviceAccount. (serviceAccount: '%s', workload: '%s')" $id .) -}}
      {{- else -}}
        {{- $serviceAccountWorkloads := append $serviceAccountWorkloads . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
