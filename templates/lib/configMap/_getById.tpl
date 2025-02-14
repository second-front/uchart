{{- /* Return a configMap Object by its Id. */ -}}
{{- define "2f.uchart.lib.configMap.getById" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}

  {{- $configMapValues := dig $id nil $root.Values.configMaps -}}
  {{- if not (empty $configMapValues) -}}
    {{- include "2f.uchart.lib.utils.valuesToObject" (dict "root" $root "id" $id "values" $configMapValues) -}}
  {{- end -}}
{{- end -}}
