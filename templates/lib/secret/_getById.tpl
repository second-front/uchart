{{- /* Return a secret Object by its Id. */ -}}
{{- define "2f.uchart.lib.secret.getById" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}

  {{- $secretValues := dig $id nil $root.Values.secrets -}}
  {{- if not (empty $secretValues) -}}
    {{- include "2f.uchart.lib.utils.valuesToObject" (dict "root" $root "id" $id "values" $secretValues) -}}
  {{- end -}}
{{- end -}}
