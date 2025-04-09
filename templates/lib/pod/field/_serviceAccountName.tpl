{{- /* Returns the value for serviceAccountName */ -}}
{{- define "2f.uchart.lib.pod.field.serviceAccountName" -}}
  {{- $root := .ctx.root -}}
  {{- $workloadObject := .ctx.workloadObject -}}
  {{- $resources := $root.Values.serviceAccounts -}}

  {{- $serviceAccountName := "default" -}}
  
  {{- /* Find serviceAccount key with matching workload */ -}}
  {{- $enabledServiceAccounts := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml -}}
  {{- range $id, $serviceAccount := $enabledServiceAccounts -}}
    {{- with $serviceAccount.workload -}}
      {{- if eq . $workloadObject.id -}}
        {{- $serviceAccountName = get (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $resources "id" $id "kind" "serviceAccount") | fromYaml) "name" -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- with $workloadObject.serviceAccount -}}
    {{- if hasKey . "id" -}}
      {{- $serviceAccountName = get (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $resources "id" .id "kind" "serviceAccount") | fromYaml) "name" -}}
    {{- else if hasKey . "name" -}}
      {{- $serviceAccountName = .name -}}
    {{- end -}}
  {{- end -}}
  {{- $serviceAccountName -}}
{{- end -}}
