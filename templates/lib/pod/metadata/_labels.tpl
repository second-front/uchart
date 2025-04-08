{{- /* Returns the value for labels */ -}}
{{- define "2f.uchart.lib.pod.metadata.labels" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}

  {{- $labels := merge
    (dict "app.kubernetes.io/component" $workloadObject.id)
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" (dig "pod" "labels" dict $workloadObject)) | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" (dig "labels" dict $root.Values.defaultPodOptions)) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}

  {{- $labels | toYaml -}}
{{- end -}}
