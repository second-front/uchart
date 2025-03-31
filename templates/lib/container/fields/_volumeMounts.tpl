{{- /* volumeMounts used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.volumeMounts" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $workloadObject := $ctx.workloadObject -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to empty dict */ -}}
  {{- $volumesToProcess := dict -}}
  {{- $enabledVolumeMounts := list -}}

  {{- $enabledVolumes := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $root.Values.volumes) | fromYaml ) -}}
  {{- range $key, $volume := $enabledVolumes -}}
    {{- $volumeValues := (mustDeepCopy $volume) -}}
      {{- $_ := set $volumesToProcess $key $volumeValues -}}
  {{- end -}}

  {{- /* Collect volumeClaimTemplates */ -}}
  {{- if not (empty (dig "statefulset" "volumeClaimTemplates" nil $workloadObject)) -}}
    {{- $enabledVolumeTemplates := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $workloadObject.statefulset.volumeClaimTemplates) | fromYaml ) -}}
    {{- range $key, $volume := $enabledVolumeTemplates -}}
      {{- $volumeValues := (mustDeepCopy $volume) -}}

      {{- /* add implict workload ID to advanced mounts */ -}}
      {{- if not (empty (dig "advancedMounts" nil $volumeValues)) -}}
        {{- $volumeValues := set $volumeValues "advancedMounts" (dict $workloadObject.id $volumeValues.advancedMounts) -}}
      {{- end -}}

      {{- $_ := set $volumesToProcess $key $volumeValues -}}
    {{- end -}}
  {{- end -}}

  {{- range $id, $volumeValues := $volumesToProcess -}}
    {{- /* Set some default values */ -}}

    {{- /* Set the default mountPath to /<id_of_the_volume> */ -}}
    {{- $mountPath := (printf "/%v" $id) -}}
    {{- if eq "hostPath" (default "pvc" $volumeValues.type) -}}
      {{- $mountPath = $volumeValues.hostPath -}}
    {{- end -}}

    {{- /* Process configured mounts */ -}}
    {{- if or .globalMounts .advancedMounts -}}
      {{- $mounts := list -}}
      {{- if hasKey . "globalMounts" -}}
        {{- $mounts = .globalMounts -}}
      {{- end -}}

      {{- if hasKey . "advancedMounts" -}}
        {{- $advancedMounts := dig $workloadObject.id $containerObject.id list .advancedMounts -}}
        {{- range $advancedMounts -}}
          {{- $mounts = append $mounts . -}}
        {{- end -}}
      {{- end -}}

      {{- range $mounts -}}
        {{- $volumeMount := dict -}}
        {{- $_ := set $volumeMount "name" $id -}}

        {{- /* Use the specified mountPath if provided */ -}}
        {{- with .path -}}
          {{- $mountPath = . -}}
        {{- end -}}
        {{- $_ := set $volumeMount "mountPath" $mountPath -}}

        {{- /* Use the specified subPath if provided */ -}}
        {{- with .subPath -}}
          {{- $subPath := . -}}
          {{- $_ := set $volumeMount "subPath" $subPath -}}
        {{- end -}}

        {{- /* Use the specified readOnly setting if provided */ -}}
        {{- with .readOnly -}}
          {{- $readOnly := . -}}
          {{- $_ := set $volumeMount "readOnly" $readOnly -}}
        {{- end -}}

        {{- /* Use the specified mountPropagation setting if provided */ -}}
        {{- with .mountPropagation -}}
          {{- $mountPropagation := . -}}
          {{- $_ := set $volumeMount "mountPropagation" $mountPropagation -}}
        {{- end -}}

        {{- $enabledVolumeMounts = append $enabledVolumeMounts $volumeMount -}}
      {{- end -}}

    {{- /* Mount to default path if no mounts are configured */ -}}
    {{- else -}}
      {{- $volumeMount := dict -}}
      {{- $_ := set $volumeMount "name" $id -}}
      {{- $_ := set $volumeMount "mountPath" $mountPath -}}
      {{- $enabledVolumeMounts = append $enabledVolumeMounts $volumeMount -}}
    {{- end -}}
  {{- end -}}

  {{- with $enabledVolumeMounts -}}
    {{- . | toYaml -}}
  {{- end -}}
{{- end -}}
