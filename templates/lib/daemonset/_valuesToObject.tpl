{{- /* Convert DaemonSet values to an object */ -}}
{{- define "2f.uchart.lib.daemonset.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Return the DaemonSet object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
