{{- /* Image used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.image" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{ $imageRegistry := include "2f.uchart.lib.container.registry" (dict "ctx" $ctx) | trim }}
  {{- $imageName := $containerObject.image.name | default $containerObject.id -}}
  {{- $imageTag := $containerObject.image.tag -}}

  {{- if and $imageName $imageTag -}}
    {{- printf "%s/%s:%s" $imageRegistry $imageName $imageTag -}}
  {{- end -}}
{{- end -}}
