{{- /* Convert values to an object */ -}}
{{- define "2f.uchart.lib.utils.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Determine and inject the name */ -}}
  {{- $objectName := (include "2f.uchart.lib.chart.names.fullname" $root) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $root -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- if not (eq $objectName $id) -}}
      {{- $objectName = printf "%s-%s" $objectName $id -}}
    {{- end -}}
  {{- end -}}

  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "id" $id -}}
  {{- /* Return the object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
