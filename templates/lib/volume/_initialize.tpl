{{- /* Initialize volume values */ -}}
{{- define "2f.uchart.lib.volume.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $volumeValues := .values -}}

  {{- /* Default the volume type to PersistentVolumeClaim */ -}}
  {{- if empty (dig "type" nil $volumeValues) -}}
    {{- $_ := set $volumeValues "type" "persistentVolumeClaim" -}}
  {{- end -}}
  
  {{- if eq $volumeValues.type "persistentVolumeClaim" -}}
    {{- if hasKey $volumeValues "existingClaim" -}}
      {{- $_ := set $volumeValues "name" $volumeValues.existingClaim -}}
    {{- end -}}
  {{- end -}}

  {{- /* Return the volume object */ -}}
  {{- $volumeValues | toYaml -}}
{{- end -}}
