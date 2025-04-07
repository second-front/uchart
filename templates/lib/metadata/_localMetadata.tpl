{{- /* process local metadata */ -}}
{{- define "2f.uchart.lib.metadata.localMetadata" -}}
  {{- $root := .root -}}
  {{- $values := .values -}}

  {{- with $values -}}
    {{- $metadata := dict -}}
    {{- range $k, $v := . -}}
      {{- $_ := set $metadata $k (include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $ "value" $v) | toString) -}}
    {{- end -}}

    {{- $metadata | toYaml -}}
  {{- end -}}
{{- end -}}