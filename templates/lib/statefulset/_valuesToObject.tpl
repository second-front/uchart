{{- /* Convert StatefulSet values to an object */ -}}
{{- define "2f.uchart.lib.statefulset.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- $strategy := default "RollingUpdate" $objectValues.strategy -}}
  {{- $_ := set $objectValues "strategy" $strategy -}}

  {{- /* Return the StatefulSet object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}