{{- /*
Returns the value for volumes
*/ -}}
{{- define "2f.uchart.lib.pod.field.volumes" -}}
  {{- $root := .ctx.root -}}
  {{- $workloadObject := .ctx.workloadObject -}}

  {{- /* Default to empty list */ -}}
  {{- $volumesToProcess := dict -}}
  {{- $volumes := list -}}

  {{- $enabledVolumes := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $root.Values.volumes) | fromYaml ) -}}
  {{- range $key, $volume := $enabledVolumes -}}
    {{- $volumeValues := (mustDeepCopy $volume) -}}

    {{- if not (empty (dig "globalMounts" list $volumeValues)) -}}
      {{- $_ := set $volumesToProcess $key $volumeValues -}}
    {{- end -}}

    {{- if not (empty (dig "advancedMounts" $workloadObject.id list $volumeValues)) -}}
      {{- $_ := set $volumesToProcess $key $volumeValues -}}
    {{- end -}}
    
    {{- if (and (empty $volumeValues.globalMounts) (empty $volumeValues.advancedMounts)) -}}
      {{- $_ := set $volumesToProcess $key $volumeValues -}}
    {{- end -}}
  {{- end -}}

  {{- /* Loop over volumes */ -}}
  {{- range $id, $volumeValues := $volumesToProcess -}}
    {{- $volume := dict "name" $id -}}

    {{- /* PVC volume type */ -}}
    {{- if eq ($volumeValues.type | default "persistentVolumeClaim") "persistentVolumeClaim" -}}
      {{- /* Create object from the raw volume values */ -}}
      {{- $object := (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $volumesToProcess "id" $id "kind" "volume") | fromYaml ) -}}
      {{- $_ := set $volume "persistentVolumeClaim" (dict "claimName" $object.name) -}}

    {{- /* configMap volume type */ -}}
    {{- else if eq $volumeValues.type "configMap" -}}
      {{- $resources := $root.Values.configMaps -}}
      {{- $objectName := "" -}}
      {{- if $volumeValues.name -}}
        {{- $objectName = tpl $volumeValues.name $root -}}
      {{- else if $volumeValues.id -}}
        {{- $object := (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $resources "id" $volumeValues.id "kind" "configMap") | fromYaml ) -}}
        {{- if not $object -}}
          {{- fail (printf "No configmap found with this id. (volume '%s', id '%s')" $id $volumeValues.id) -}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "configMap" dict -}}
      {{- $_ := set $volume.configMap "name" $objectName -}}
      {{- with $volumeValues.defaultMode -}}
        {{- $_ := set $volume.configMap "defaultMode" . -}}
      {{- end -}}
      {{- with $volumeValues.items -}}
        {{- $_ := set $volume.configMap "items" . -}}
      {{- end -}}

    {{- /* Secret volume type */ -}}
    {{- else if eq $volumeValues.type "secret" -}}
      {{- $resources := $root.Values.secrets -}}
      {{- $objectName := "" -}}
      {{- if $volumeValues.name -}}
        {{- $objectName = tpl $volumeValues.name $root -}}
      {{- else if $volumeValues.id -}}
        {{- $object := (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $resources "id" $volumeValues.id "kind" "secret") | fromYaml ) -}}
        {{- if not $object -}}
          {{- fail (printf "No secret found with this id. (volume '%s', id '%s')" $id $volumeValues.id) -}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "secret" dict -}}
      {{- $_ := set $volume.secret "secretName" $objectName -}}
      {{- with $volumeValues.defaultMode -}}
        {{- $_ := set $volume.secret "defaultMode" . -}}
      {{- end -}}
      {{- with $volumeValues.items -}}
        {{- $_ := set $volume.secret "items" . -}}
      {{- end -}}

    {{- /* emptyDir volume type */ -}}
    {{- else if eq $volumeValues.type "emptyDir" -}}
      {{- $_ := set $volume "emptyDir" dict -}}
      {{- with $volumeValues.medium -}}
        {{- $_ := set $volume.emptyDir "medium" . -}}
      {{- end -}}
      {{- with $volumeValues.sizeLimit -}}
        {{- $_ := set $volume.emptyDir "sizeLimit" . -}}
      {{- end -}}

    {{- /* hostPath volume type */ -}}
    {{- else if eq $volumeValues.type "hostPath" -}}
      {{- $_ := set $volume "hostPath" dict -}}
      {{- $_ := set $volume.hostPath "path" (required "hostPath not set" $volumeValues.hostPath) -}}
      {{- with $volumeValues.hostPathType -}}
        {{- $_ := set $volume.hostPath "type" . -}}
      {{- end -}}

    {{- /* nfs volume type */ -}}
    {{- else if eq $volumeValues.type "nfs" -}}
      {{- $_ := set $volume "nfs" dict -}}
      {{- $_ := set $volume.nfs "server" (required "server not set" $volumeValues.server) -}}
      {{- $_ := set $volume.nfs "path" (required "path not set" $volumeValues.path) -}}

    {{- /* custom volume type */ -}}
    {{- else if eq $volumeValues.type "custom" -}}
      {{- $volume = $volumeValues.spec -}}
      {{- $_ := set $volume "name" $id -}}

    {{- /* Fail otherwise */ -}}
    {{- else -}}
      {{- fail (printf "Not a valid volume.type (%s)" $volumeValues.type) -}}
    {{- end -}}

    {{- $volumes = append $volumes $volume -}}
  {{- end -}}

  {{- if not (empty $volumes) -}}
    {{- $volumes | toYaml -}}
  {{- end -}}
{{- end -}}
