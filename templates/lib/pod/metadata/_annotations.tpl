{{- /* Returns the value for pod annotations */ -}}
{{- define "2f.uchart.lib.pod.metadata.annotations" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}

  {{- /* Default annotations */ -}}
  {{- $annotations := merge
    (dict)
  -}}

  {{- /* Include global annotations */ -}}
  {{- $annotations = merge
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
    $annotations
  -}}

  {{- /* Set default pod annotations */ -}}
  {{- $defaultOption := get (default dict $root.Values.defaultPodOptions) "annotations" -}}
  {{- if not (empty $defaultOption) -}}
    {{- $annotations = merge $defaultOption $annotations -}}
  {{- end -}}

  {{- /* See if a pod-specific override is set */ -}}
  {{- if hasKey $workloadObject "pod" -}}
    {{- $podOption := get $workloadObject.pod "annotations" -}}
    {{- if not (empty $podOption) -}}
      {{- $annotations = merge $podOption $annotations -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $annotations) -}}
    {{- $annotations | toYaml -}}
  {{- end -}}
{{- end -}}
