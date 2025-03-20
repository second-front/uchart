{{- /* Return the enabled Resources. */ -}}
{{- define "2f.uchart.lib.utils.enabledResources" -}}
  {{- $root := .root -}}
  {{- $resources := .resources -}}
  {{- $enabledResources := dict -}}

  {{- range $name, $resource := $resources -}}
    {{- if kindIs "map" $resource -}}
      {{- /* Enable by default, but allow override */ -}}
      {{- $resourceEnabled := true -}}
      {{- if hasKey $resource "enabled" -}}
        {{- $resourceEnabled = $resource.enabled -}}
      {{- end -}}

      {{- if $resourceEnabled -}}
        {{- $_ := set $enabledResources $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledResources | toYaml -}}
{{- end -}}
