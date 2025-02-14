{{- /* volumeMounts used by the container. */ -}}
{{- define "2f.uchart.lib.container.field.volumeMounts" -}}
  {{- $ctx := .ctx -}}
  {{- $root := $ctx.root -}}
  {{- $workloadObject := $ctx.workloadObject -}}
  {{- $containerObject := $ctx.containerObject -}}

  {{- /* Default to empty dict */ -}}
  {{- $persistenceItemsToProcess := dict -}}
  {{- $enabledVolumeMounts := list -}}

  {{- /* Collect regular persistence items */ -}}
  {{- range $id, $persistenceValues := $root.Values.persistence -}}
    {{- /* Enable persistence item by default, but allow override */ -}}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- $_ := set $persistenceItemsToProcess $id $persistenceValues -}}
    {{- end -}}
  {{- end -}}

  {{- /* Collect volumeClaimTemplates */ -}}
  {{- if not (empty (dig "statefulset" "volumeClaimTemplates" nil $workloadObject)) -}}
    {{- range $persistenceValues := $workloadObject.statefulset.volumeClaimTemplates -}}
      {{- /* Enable persistence item by default, but allow override */ -}}
      {{- $persistenceEnabled := true -}}
      {{- if hasKey $persistenceValues "enabled" -}}
        {{- $persistenceEnabled = $persistenceValues.enabled -}}
      {{- end -}}

      {{- if $persistenceEnabled -}}
        {{- $mountValues := dict -}}
        {{- if not (empty (dig "globalMounts" nil $persistenceValues)) -}}
          {{- $_ := set $mountValues "globalMounts" $persistenceValues.globalMounts -}}
        {{- end -}}
        {{- if not (empty (dig "advancedMounts" nil $persistenceValues)) -}}
          {{- $_ := set $mountValues "advancedMounts" (dict $workloadObject.id $persistenceValues.advancedMounts) -}}
        {{- end -}}
        {{- $_ := set $persistenceItemsToProcess $persistenceValues.name $mountValues -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- range $id, $persistenceValues := $persistenceItemsToProcess -}}
    {{- /* Set some default values */ -}}

    {{- /* Set the default mountPath to /<name_of_the_peristence_item> */ -}}
    {{- $mountPath := (printf "/%v" $id) -}}
    {{- if eq "hostPath" (default "pvc" $persistenceValues.type) -}}
      {{- $mountPath = $persistenceValues.hostPath -}}
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
