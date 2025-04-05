{{- /* Returns the value for pod annotations */ -}}
{{- define "2f.uchart.lib.pod.metadata.annotations" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}

  {{- /* Default annotations */ -}}
  {{- $annotations := merge
    dict
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" (dig "pod" "annotations" dict $workloadObject)) | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" (dig "annotations" dict $root.Values.defaultPodOptions)) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}

  {{- with $annotations -}}
    {{- . | toYaml -}}
  {{- end -}}
{{- end -}}
