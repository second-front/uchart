{{- /* Return the enabled objects. */ -}}
{{- define "2f.uchart.lib.utils.enabledObjects" -}}
  {{- $root := .root -}}
  {{- $objects := .objects -}}
  {{- $enabledObjects := dict -}}

  {{- range $name, $object := $objects -}}
    {{- if kindIs "map" $object -}}
      {{- /* Enable Secret by default, but allow override */ -}}
      {{- $objectEnabled := true -}}
      {{- if hasKey $object "enabled" -}}
        {{- $objectEnabled = $object.enabled -}}
      {{- end -}}

      {{- if $objectEnabled -}}
        {{- $_ := set $enabledObjects $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledObjects | toYaml -}}
{{- end -}}
