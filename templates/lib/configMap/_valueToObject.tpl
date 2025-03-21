{{- /* Convert configMap values to an object */ -}}
{{- define "2f.uchart.lib.configMap.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}
  

  {{- $configMapValues := include "2f.uchart.lib.utils.valuesToObject" (dict "root" $root "id" $id "values" $objectValues "resources" $root.Values.configMaps) | fromYaml -}}

  {{- /* Return the configMap object */ -}}
  {{- $configMapValues | toYaml -}}
{{- end -}}
