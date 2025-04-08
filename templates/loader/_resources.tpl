{{- /* Resource builder for the chart */ -}}
{{- define "2f.uchart.loader.resources" -}}
  {{- /* Run global chart validations */ -}}
  {{- include "2f.uchart.lib.chart.validate" . -}}

  {{- /* Build the templates */ -}}
  {{- include "2f.uchart.lib.volume.render" . | nindent 0 -}}
  {{- include "2f.uchart.lib.configMap.render" . | nindent 0 -}}
  {{- include "2f.uchart.lib.secret.render" . | nindent 0 -}}
  {{- include "2f.uchart.lib.workload.render" . | nindent 0 -}}
  {{- include "2f.uchart.lib.service.render" . | nindent 0 -}}
  {{- include "2f.uchart.lib.virtualService.render" . | nindent 0 -}}
  {{- include "2f.uchart.lib.networkPolicy.render" . | nindent 0 -}}
  {{- include "2f.uchart.lib.extraManifest.render" . | nindent 0 -}}
{{- end -}}
