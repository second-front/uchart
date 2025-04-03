{{- /* Return a configMap Object by its Id. */ -}}
{{- define "2f.uchart.lib.workload.getById" -}}
  {{- $root := .root -}}
  {{- $resources := .resources -}}
  {{- $id := .id -}}

  {{- $enabledResources := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml -}}
  {{- $resourceValues := get $enabledResources $id -}}

  {{- if not (empty $resourceValues) -}}
    {{- include "2f.uchart.lib.workload.initialize" (dict "root" $root "resources" $resources "id" $id "values" $resourceValues) -}}
  {{- end -}}
{{- end -}}
