{{- /* Convert secret values to an object */ -}}
{{- define "2f.uchart.lib.secret.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}
  

  {{- $secretValues := include "2f.uchart.lib.utils.valuesToObject" (dict "root" $root "id" $id "values" $objectValues "resources" $root.Values.secrets) | fromYaml -}}

  {{- /* Return the secret object */ -}}
  {{- $secretValues | toYaml -}}
{{- end -}}
