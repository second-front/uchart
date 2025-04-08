{{- /* Global Annotations */ -}}
{{- define "2f.uchart.lib.metadata.globalAnnotations" -}}
  {{- with .Values.global.annotations -}}
    {{- $annotations := dict -}}
    {{- range $k, $v := . -}}
      {{- $_ := set $annotations $k (include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $ "value" $v) | toString) -}}
    {{- end -}}

    {{- $annotations | toYaml -}}
  {{- end -}}
{{- end -}}
