{{- /* Validate configMap values */ -}}
{{- define "2f.uchart.lib.configMap.validate" -}}
  {{- $root := .root -}}
  {{- $configMapValues := .object -}}
  {{- $id := .id -}}

  {{- if empty $configMapValues -}}
    {{- fail (printf "There was an error loading ConfigMap: %s." $id) -}}
  {{- end -}}
  {{- if and (empty (get $configMapValues "data")) (empty (get $configMapValues "binaryData")) -}}
    {{- fail (printf "No data or binaryData specified for configMap. (configMap: %s)" $configMapValues.id) -}}
  {{- end -}}
{{- end -}}
