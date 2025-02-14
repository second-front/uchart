{{- /* Return the enabled workloads. */ -}}
{{- define "2f.uchart.lib.workload.enabledWorkloads" -}}
  {{- $root := .root -}}
  {{- $enabledWorkloads := dict -}}

  {{- range $name, $workload := $root.Values.workloads -}}
    {{- if kindIs "map" $workload -}}
      {{- /* Enable by default, but allow override */ -}}
      {{- $workloadEnabled := true -}}
      {{- if hasKey $workload "enabled" -}}
        {{- $workloadEnabled = $workload.enabled -}}
      {{- end -}}

      {{- if $workloadEnabled -}}
        {{- $_ := set $enabledWorkloads $name . -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $enabledWorkloads | toYaml -}}
{{- end -}}