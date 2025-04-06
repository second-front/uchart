{{- /* Merge the local chart values and the uchart chart defaults */ -}}
{{- define "2f.uchart.loader.initialize" -}}
  {{- include "2f.uchart.values.merge" . -}}
{{- end -}}