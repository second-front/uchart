{{- /* Convert Deployment values to an object */ -}}
{{- define "2f.uchart.lib.deployment.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- $strategy := default "Recreate" $objectValues.strategy -}}
  {{- $_ := set $objectValues "strategy" $strategy -}}

  {{- /* Return the Deployment object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}