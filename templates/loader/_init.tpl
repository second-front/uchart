{{- /* Merge the local chart values and the uchart chart defaults */ -}}
{{- define "2f.uchart.loader.init" -}}
  {{- include "2f.uchart.values.init" . }}
{{- end -}}