{{- /* Returns the value for serviceAccountName */ -}}
{{- define "2f.uchart.lib.pod.field.serviceAccountName" -}}
  {{- $root := .ctx.root -}}
  {{- $workloadObject := .ctx.workloadObject -}}
  {{- $resources := $root.Values.serviceAccounts -}}

  {{- $serviceAccountName := "default" -}}
  {{- $defaultServiceAccount := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $resources "id" "default") | fromYaml -}}

  {{- if $root.Values.enforceServiceAccountCreation -}}
    {{- if (get $defaultServiceAccount "create") -}}
      {{- $serviceAccountName = get $defaultServiceAccount "name" -}}
    {{- end -}}
  {{- else -}}
      {{- $serviceAccountName = get $defaultServiceAccount "name" -}}
  {{- end -}}

  {{- with $workloadObject.serviceAccount -}}
    {{- if hasKey . "id" -}}
      {{- $serviceAccountName = get (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $resources "id" .id) | fromYaml) "name" -}}
    {{- else if hasKey . "name" -}}
      {{- $serviceAccountName = .name -}}
    {{- end -}}
  {{- end -}}
  {{- $serviceAccountName -}}

{{- end -}}
