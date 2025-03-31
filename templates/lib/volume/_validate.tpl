{{- /* Validate volume values */ -}}
{{- define "2f.uchart.lib.volume.validate" -}}
  {{- $root := .root -}}
  {{- $volumeValues := .object -}}

  {{- $allowedVolumeTypes := list "persistentVolumeClaim" "hostPath" "configMap" "secret" "nfs" "emptyDir" "custom" -}}
  {{- if not (has $volumeValues.type $allowedVolumeTypes) -}}
    {{- fail (printf "Not a valid volume.type (%s)" $volumeValues.type) -}}
  {{- end -}}
{{- end -}}
