{{- /* Initialize DaemonSet values */ -}}
{{- define "2f.uchart.lib.daemonset.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Return the DaemonSet object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
