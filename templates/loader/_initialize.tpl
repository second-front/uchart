{{- /* Merge the local chart values and the uchart defaults */ -}}
{{- define "2f.uchart.loader.initialize" -}}
  {{- include "2f.uchart.values.merge" . -}}
  {{- include "2f.uchart.values.setName" . -}}
{{- end -}}