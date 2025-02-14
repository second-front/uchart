{{- /* Return the enabled containers for a workload. */ -}}
{{- define "2f.uchart.lib.workload.enabledContainers" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}

  {{- $enabledContainers := dict -}}
  {{- range $name, $container := $workloadObject.containers -}}
    {{- if kindIs "map" $container -}}
      {{- /* Enable container by default, but allow override */ -}}
      {{- $containerEnabled := true -}}
      {{- if hasKey $container "enabled" -}}
        {{- $containerEnabled = $container.enabled -}}
      {{- end -}}

      {{- if $containerEnabled -}}
        {{- $_ := set $enabledContainers $name $container -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledContainers | toYaml -}}
{{- end -}}