{{- /* Convert Service values to an object */ -}}
{{- define "2f.uchart.lib.service.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}
  {{- $resources := $root.Values.services}}

  {{- $args := (dict "root" $root "resources" $root.Values.services "id" $id "values" $objectValues) -}}

  {{- $serviceValues := include "2f.uchart.lib.utils.valuesToObject" $args | fromYaml -}}

  {{- /* Return the Service object */ -}}
  {{- $serviceValues | toYaml -}}
{{- end -}}
