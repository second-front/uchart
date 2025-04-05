{{- /* Gamewarden Labels */ -}}
{{- define "2f.uchart.lib.metadata.customerLabels" -}}
  {{- $labels := dict 
    "app.gamewarden.io/customer" (.Values.global.customerName | required ".Values.global.customerName is required")
    "app.gamewarden.io/complianceLevel" (.Values.global.complianceLevel | required ".Values.global.complianceLevel is required")
    "app.gamewarden.io/environment" (.Values.global.environment | required ".Values.global.environment is required")
  -}}
  
  {{- $labels | toYaml -}}
{{- end -}}
