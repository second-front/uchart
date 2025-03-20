{{- /* Convert Service values to an object */ -}}
{{- define "2f.uchart.lib.service.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}
  {{- $resources := $root.Values.services}}

  {{- /* Determine and inject the Service name */ -}}
  {{- $objectName := (include "2f.uchart.lib.chart.names.fullname" $root) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $root -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- $enabledServices := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) }}
    {{- if and (not $objectValues.primary) (gt (len $enabledServices) 1) -}}
      {{- if not (eq $objectName $id) -}}
        {{- $objectName = printf "%s-%s" $objectName $id -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "id" $id -}}

  {{- /* Return the Service object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
