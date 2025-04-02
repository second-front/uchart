{{- /* resource builder for the chart */ -}}
{{- define "2f.uchart.loader.resources" -}}
  {{- /* Run global chart validations */ -}}
  {{- include "2f.uchart.lib.chart.validate" . -}}

  {{- /* Build the templates */ -}}
  {{- include "2f.uchart.render.volumes" . | nindent 0 -}}
  {{- include "2f.uchart.render.configMaps" . | nindent 0 -}}
  {{- include "2f.uchart.render.secrets" . | nindent 0 -}}
  {{- include "2f.uchart.render.workloads" . | nindent 0 -}}
  {{- include "2f.uchart.render.services" . | nindent 0 -}}
  {{- include "2f.uchart.render.virtualServices" . | nindent 0 -}}
{{- end -}}
