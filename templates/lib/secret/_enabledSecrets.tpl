{{- /* Return the enabled secrets. */ -}}
{{- define "2f.uchart.lib.secret.enabledSecrets" -}}
  {{- $root := .root -}}
  {{- $enabledSecrets := dict -}}

  {{- range $name, $secret := $root.Values.secrets -}}
    {{- if kindIs "map" $secret -}}
      {{- /* Enable Secret by default, but allow override */ -}}
      {{- $secretEnabled := true -}}
      {{- if hasKey $secret "enabled" -}}
        {{- $secretEnabled = $secret.enabled -}}
      {{- end -}}

      {{- if $secretEnabled -}}
        {{- $_ := set $enabledSecrets $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledSecrets | toYaml -}}
{{- end -}}
