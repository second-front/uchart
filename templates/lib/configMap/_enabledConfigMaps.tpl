{{- /* Return the enabled configMaps. */ -}}
{{- define "2f.uchart.lib.configMap.enabledConfigMaps" -}}
  {{- $root := .root -}}
  {{- $enabledConfigMaps := dict -}}

  {{- range $name, $configMap := $root.Values.configMaps -}}
    {{- if kindIs "map" $configMap -}}
      {{- /* Enable ConfigMap by default, but allow override */ -}}
      {{- $configMapEnabled := true -}}
      {{- if hasKey $configMap "enabled" -}}
        {{- $configMapEnabled = $configMap.enabled -}}
      {{- end -}}

      {{- if $configMapEnabled -}}
        {{- $_ := set $enabledConfigMaps $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledConfigMaps | toYaml -}}
{{- end -}}
