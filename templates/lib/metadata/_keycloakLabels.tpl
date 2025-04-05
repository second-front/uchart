{{- /* Istio Auth Labels */ -}}
{{- define "2f.uchart.lib.metadata.authLabels" -}}
  {{- $labels := dict "protect" "keycloak" -}}
  
  {{- $labels | toYaml -}}
{{- end -}}
