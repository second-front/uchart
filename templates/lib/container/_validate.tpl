{{- /* Validate container values */ -}}
{{- define "2f.uchart.lib.container.validate" -}}
  {{- $root := .root -}}
  {{- $workloadObject := .workloadObject -}}
  {{- $containerObject := .containerObject -}}

  {{- if not (kindIs "map" $containerObject.image)  -}}
    {{- fail (printf "Image required to be a dictionary with name and tag fields. (workload %s, container %s)" $workloadObject.id $containerObject.id) }}
  {{- end -}}

  {{- if empty (dig "image" "tag" nil $containerObject) -}}
    {{- fail (printf "No image tag specified for container. (workload %s, container %s)" $workloadObject.id $containerObject.id) }}
  {{- end -}}
{{- end -}}
