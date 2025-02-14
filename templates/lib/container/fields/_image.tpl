{{- /* Image used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.image" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{ $imageRegistry := include "2f.uchart.lib.container.registry" (dict "ctx" $ctx) | trim }}
  {{- $imageRepo := $containerObject.image.repository -}}
  {{- $imageTag := $containerObject.image.tag -}}

  {{- if and $imageRepo $imageTag -}}
    {{- printf "%s/%s:%s" $imageRegistry $imageRepo $imageTag -}}
  {{- end -}}
{{- end -}}
