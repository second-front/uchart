{{/* Convert ServiceAccount values to an object */}}
{{- define "2f.uchart.lib.serviceAccount.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the serviceAccount name */ -}}
  {{- $defaultServiceAccountName := (include "2f.uchart.lib.chart.names.fullname" $root) -}}

  {{- $objectName := $defaultServiceAccountName -}}

  {{- with $objectValues.name -}}
    {{- $objectName = . -}}
  {{- end -}}
  {{- if and (ne $id "default") (not $objectValues.name) -}}
    {{- $objectName = printf "%s-%s" $defaultServiceAccountName $id -}}
  {{- end -}}

  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "id" $id -}}

  {{- $objectValues | toYaml -}}
{{- end -}}
