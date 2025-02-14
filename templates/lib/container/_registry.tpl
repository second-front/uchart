{{- /* Registry used by the container. */ -}}
{{- define "2f.uchart.lib.container.registry" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- $imageRegistry := $containerObject.image.registry | default $root.Values.global.imageRegistry -}}

  {{- $imageRegistry | toYaml -}}
{{- end -}}
