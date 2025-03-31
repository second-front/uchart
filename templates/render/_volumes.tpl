{{- /* Renders the volume objects required by the chart. */ -}}
{{- define "2f.uchart.render.volumes" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.volumes -}}
  {{- $kind := "volume" -}}

  {{- /* Generate named volume objects as required */ -}}
  {{- $enabledVolumes := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml) -}}
  {{- range $key, $volume := $enabledVolumes -}}
    {{- $volumeValues := (mustDeepCopy $volume) -}}

    {{- /* Create object from the raw volume values */ -}}
    {{- $volumeObject := (include "2f.uchart.lib.utils.valuesToObject" (dict "root" $root "id" $key "resources" $resources "values" $volumeValues "kind" $kind)) | fromYaml -}}

    {{- /* Perform validations on the volume before rendering */ -}}
    {{- include "2f.uchart.lib.volume.validate" (dict "root" $root "object" $volumeObject) -}}

    {{- if eq $volumeObject.type "persistentVolumeClaim" -}}
      {{- if not $volumeObject.existingClaim -}}
        {{- include (printf "2f.uchart.blueprints.%s" $volumeObject.type) (dict "root" $root "object" $volumeObject) | nindent 0 -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
