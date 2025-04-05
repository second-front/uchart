{{- /* Global Labels */ -}}
{{- define "2f.uchart.lib.metadata.globalLabels" -}}
  {{- with .Values.global.labels -}}
    {{- $labels := dict -}}
    {{- range $k, $v := . -}}
      {{ $_ := set $labels $k (tpl $v $ | toString) -}}
    {{- end -}}
    {{- $labels | toYaml -}}
  {{- end -}}
{{- end -}}
