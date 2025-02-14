{{- /* Gamewarden Labels */ -}}
{{- define "2f.uchart.lib.metadata.customerLabels" -}}
app.gamewarden.io/customer: {{ required ".Values.global.customer is required" .Values.global.customer }}
app.gamewarden.io/complianceLevel: {{ required ".Values.global.complianceLevel is required" .Values.global.complianceLevel }}
app.gamewarden.io/environment: {{ required ".Values.global.environment is required" .Values.global.environment }}
{{- end }}
