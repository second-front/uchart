{{- /* Returns the value for serviceAccountName */ -}}
{{- define "2f.uchart.lib.pod.field.serviceAccountName" -}}
  {{- $root := .ctx.root -}}
  {{- $workloadObject := .ctx.workloadObject -}}

  {{- $serviceAccountName := "default" -}}

  {{- if $root.Values.enforceServiceAccountCreation -}}
    {{- if (get (include "2f.uchart.lib.serviceAccount.getById" (dict "root" $root "id" "default") | fromYaml) "create") -}}
      {{- $serviceAccountName = get (include "2f.uchart.lib.serviceAccount.getById" (dict "root" $root "id" "default") | fromYaml) "name" -}}
    {{- end -}}
  {{- else -}}
      {{- $serviceAccountName = get (include "2f.uchart.lib.serviceAccount.getById" (dict "root" $root "id" "default") | fromYaml) "name" -}}
  {{- end -}}

  {{- with $workloadObject.serviceAccount -}}
    {{- if hasKey . "id" -}}
      {{- $serviceAccountName = get (include "2f.uchart.lib.serviceAccount.getById" (dict "root" $root "id" .id) | fromYaml) "name" -}}
    {{- else if hasKey . "name" -}}
      {{- $serviceAccountName = .name -}}
    {{- end -}}
  {{- end -}}
  {{- $serviceAccountName -}}

{{- end -}}
