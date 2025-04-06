{{- /* Return the value or the specified default if the given value is null. */ -}}
{{- define "2f.uchart.lib.utils.defaultKeepNonNullValue" -}}
  {{- $value := .value -}}
  {{- $default := required "default value is required" .default -}}

  {{- if eq nil $value -}}
    {{- $default | toYaml -}}
  {{- else -}}
    {{- $value | toYaml -}}
  {{- end -}}
{{- end -}}
