{{- /* Main entrypoint for the common library chart. It will render all underlying templates based on the provided values. */ -}}
{{- define "2f.uchart.loader.all" -}}
  {{- /* Generate chart and dependency values */ -}}
  {{- include "2f.uchart.loader.init" . -}}

  {{- /* Generate remaining objects */ -}}
  {{- include "2f.uchart.loader.resources" . -}}
{{- end -}}