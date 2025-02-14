{{- /*
Returns the value for labels
*/ -}}
{{- define "2f.uchart.lib.pod.metadata.labels" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}

  {{- /* Default labels */ -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $workloadObject.id)
  -}}

  {{- /* Include gamewarden labels */ -}}
  {{- $labels = merge
    (include "2f.uchart.lib.metadata.customerLabels" $root | fromYaml)
    $labels
  -}}

  {{- /* Include global labels */ -}}
  {{- $labels = merge
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
    $labels
  -}}

  {{- /* Fetch the Pod selectorLabels */ -}}
  {{- $selectorLabels := include "2f.uchart.lib.metadata.selectorLabels" $root | fromYaml -}}
  {{- if not (empty $selectorLabels) -}}
    {{- $labels = merge $selectorLabels $labels -}}
  {{- end -}}

  {{- /* Set to the default if it is set */ -}}
  {{- $defaultOption := get (default dict $root.Values.defaultPodOptions) "labels" -}}
  {{- if not (empty $defaultOption) -}}
    {{- $labels = merge $defaultOption $labels -}}
  {{- end -}}

  {{- /* See if a pod-specific override is set */ -}}
  {{- if hasKey $workloadObject "pod" -}}
    {{- $podOption := get $workloadObject.pod "labels" -}}
    {{- if not (empty $podOption) -}}
      {{- $labels = merge $podOption $labels -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $labels) -}}
    {{- $labels | toYaml -}}
  {{- end -}}
{{- end -}}
