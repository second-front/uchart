{{- /* Returns the value for a specified field */ -}}
{{- define "2f.uchart.lib.pod.getOption" -}}
  {{- $root := .ctx.root -}}
  {{- $workloadObject := .ctx.workloadObject -}}
  {{- $option := .option -}}
  {{- $default := .default -}}

  {{- $value := $default -}}

  {{- /* Set to the default if it is set */ -}}
  {{- $defaultOption := dig $option nil (default dict $root.Values.defaultPodOptions) -}}
  {{- if kindIs "bool" $defaultOption -}}
    {{- $value = $defaultOption -}}
  {{- else if not (empty $defaultOption) -}}
    {{- $value = $defaultOption -}}
  {{- end -}}

  {{- /* See if a pod-specific override is needed */ -}}
  {{- $podOption := dig $option nil (default dict $workloadObject.pod) -}}
  {{- if kindIs "bool" $podOption -}}
    {{- $value = $podOption -}}
  {{- else if not (empty $podOption) -}}
    {{- $value = $podOption -}}
  {{- end -}}

  {{- if kindIs "bool" $value -}}
    {{- $value | toYaml -}}
  {{- else if not (empty $value) -}}
    {{- $value | toYaml -}}
  {{- end -}}
{{- end -}}
