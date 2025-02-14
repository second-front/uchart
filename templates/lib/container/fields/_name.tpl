{{- /* Name used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.name" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to container id */ -}}
  {{- $name := $containerObject.id -}}

  {{- /* See if an override is desired */ -}}
  {{- if hasKey $containerObject "nameOverride" -}}
    {{- $option := get $containerObject "nameOverride" -}}
    {{- if not (empty $option) -}}
      {{- $name = $option -}}
    {{- end -}}
  {{- end -}}

  {{- /* Parse any nested templates */ -}}
  {{- $name = tpl $name $root -}}

  {{- $name | toYaml -}}
{{- end -}}
