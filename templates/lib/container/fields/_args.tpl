{{- /* Args used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.args" -}}
  {{- $ctx := .ctx -}}
  {{- $containerObject := $ctx.containerObject -}}
  {{- $argValues := get $containerObject "args" -}}

  {{- /* Default to empty list */ -}}
  {{- $args := list -}}

  {{- /* See if an override is desired */ -}}
  {{- if not (empty $argValues) -}}
    {{- if kindIs "string" $argValues -}}
      {{- $args = append $args $argValues -}}
    {{- else -}}
      {{- $args = $argValues -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $args) -}}
    {{- $args | toYaml -}}
  {{- end -}}
{{- end -}}
