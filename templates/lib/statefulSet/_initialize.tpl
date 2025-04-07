{{- /* Initialize StatefulSet values */ -}}
{{- define "2f.uchart.lib.statefulSet.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- $strategy := default "RollingUpdate" $objectValues.strategy -}}
  {{- $_ := set $objectValues "strategy" $strategy -}}

  {{- /* Return the StatefulSet object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}