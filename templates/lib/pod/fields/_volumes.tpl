{{- /*
Returns the value for volumes
*/ -}}
{{- define "2f.uchart.lib.pod.field.volumes" -}}
  {{- $root := .ctx.root -}}
  {{- $workloadObject := .ctx.workloadObject -}}

  {{- /* Default to empty list */ -}}
  {{- $persistenceItemsToProcess := dict -}}
  {{- $volumes := list -}}

  {{- /* Loop over persistence values */ -}}
  {{- range $id, $persistenceValues := $root.Values.persistence -}}
    {{- /* Enable persistence item by default, but allow override */ -}}
    {{- $persistenceEnabled := true -}}
    {{- if hasKey $persistenceValues "enabled" -}}
      {{- $persistenceEnabled = $persistenceValues.enabled -}}
    {{- end -}}

    {{- if $persistenceEnabled -}}
      {{- $hasglobalMounts := not (empty $persistenceValues.globalMounts) -}}
      {{- $globalMounts := dig "globalMounts" list $persistenceValues -}}

      {{- $hasAdvancedMounts := not (empty $persistenceValues.advancedMounts) -}}
      {{- $advancedMounts := dig "advancedMounts" $workloadObject.id list $persistenceValues -}}

      {{ if or
        ($hasglobalMounts)
        (and ($hasAdvancedMounts) (not (empty $advancedMounts)))
        (and (not $hasglobalMounts) (not $hasAdvancedMounts))
      -}}
        {{- $_ := set $persistenceItemsToProcess $id $persistenceValues -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- /* Loop over persistence items */ -}}
  {{- range $id, $persistenceValues := $persistenceItemsToProcess -}}
    {{- $volume := dict "name" $id -}}

    {{- /* PVC persistence type */ -}}
    {{- if eq (default "persistentVolumeClaim" $persistenceValues.type) "persistentVolumeClaim" -}}
      {{- $pvcName := (include "2f.uchart.lib.chart.names.fullname" $root) -}}
      {{- if $persistenceValues.existingClaim -}}
        {{- /* Always prefer an existingClaim if that is set */ -}}
        {{- $pvcName = $persistenceValues.existingClaim -}}
      {{- else -}}
        {{- /* Otherwise refer to the PVC name */ -}}
        {{- if $persistenceValues.nameOverride -}}
          {{- if not (eq $persistenceValues.nameOverride "-") -}}
            {{- $pvcName = (printf "%s-%s" (include "2f.uchart.lib.chart.names.fullname" $root) $persistenceValues.nameOverride) -}}
          {{- end -}}
        {{- else -}}
          {{- if not (eq $pvcName $id) -}}
            {{- $pvcName = (printf "%s-%s" (include "2f.uchart.lib.chart.names.fullname" $root) $id) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
      {{- $_ := set $volume "persistentVolumeClaim" (dict "claimName" $pvcName) -}}

    {{- /* configMap persistence type */ -}}
    {{- else if eq $persistenceValues.type "configMap" -}}
      {{- $resources := $root.Values.configMaps -}}
      {{- $objectName := "" -}}
      {{- if $persistenceValues.name -}}
        {{- $objectName = tpl $persistenceValues.name $root -}}
      {{- else if $persistenceValues.id -}}
        {{- $object := (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $resources "id" $persistenceValues.id) | fromYaml ) -}}
        {{- if not $object -}}
          {{fail (printf "No configmap found with this id. (persistence item '%s', id '%s')" $id $persistenceValues.id)}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "configMap" dict -}}
      {{- $_ := set $volume.configMap "name" $objectName -}}
      {{- with $persistenceValues.defaultMode -}}
        {{- $_ := set $volume.configMap "defaultMode" . -}}
      {{- end -}}
      {{- with $persistenceValues.items -}}
        {{- $_ := set $volume.configMap "items" . -}}
      {{- end -}}

    {{- /* Secret persistence type */ -}}
    {{- else if eq $persistenceValues.type "secret" -}}
      {{- $resources := $root.Values.secrets -}}
      {{- $objectName := "" -}}
      {{- if $persistenceValues.name -}}
        {{- $objectName = tpl $persistenceValues.name $root -}}
      {{- else if $persistenceValues.id -}}
        {{- $object := (include "2f.uchart.lib.utisl.getById" (dict "root" $root "resources" $resources "id" $persistenceValues.id) | fromYaml ) -}}
        {{- if not $object -}}
          {{fail (printf "No secret found with this id. (persistence item '%s', id '%s')" $id $persistenceValues.id)}}
        {{- end -}}
        {{- $objectName = $object.name -}}
      {{- end -}}
      {{- $_ := set $volume "secret" dict -}}
      {{- $_ := set $volume.secret "secretName" $objectName -}}
      {{- with $persistenceValues.defaultMode -}}
        {{- $_ := set $volume.secret "defaultMode" . -}}
      {{- end -}}
      {{- with $persistenceValues.items -}}
        {{- $_ := set $volume.secret "items" . -}}
      {{- end -}}

    {{- /* emptyDir persistence type */ -}}
    {{- else if eq $persistenceValues.type "emptyDir" -}}
      {{- $_ := set $volume "emptyDir" dict -}}
      {{- with $persistenceValues.medium -}}
        {{- $_ := set $volume.emptyDir "medium" . -}}
      {{- end -}}
      {{- with $persistenceValues.sizeLimit -}}
        {{- $_ := set $volume.emptyDir "sizeLimit" . -}}
      {{- end -}}

    {{- /* hostPath persistence type */ -}}
    {{- else if eq $persistenceValues.type "hostPath" -}}
      {{- $_ := set $volume "hostPath" dict -}}
      {{- $_ := set $volume.hostPath "path" (required "hostPath not set" $persistenceValues.hostPath) -}}
      {{- with $persistenceValues.hostPathType }}
        {{- $_ := set $volume.hostPath "type" . -}}
      {{- end -}}

    {{- /* nfs persistence type */ -}}
    {{- else if eq $persistenceValues.type "nfs" -}}
      {{- $_ := set $volume "nfs" dict -}}
      {{- $_ := set $volume.nfs "server" (required "server not set" $persistenceValues.server) -}}
      {{- $_ := set $volume.nfs "path" (required "path not set" $persistenceValues.path) -}}

    {{- /* custom persistence type */ -}}
    {{- else if eq $persistenceValues.type "custom" -}}
      {{- $volume = $persistenceValues.volumeSpec -}}
      {{- $_ := set $volume "name" $id -}}

    {{- /* Fail otherwise */ -}}
    {{- else -}}
      {{- fail (printf "Not a valid persistence.type (%s)" $persistenceValues.type) -}}
    {{- end -}}

    {{- $volumes = append $volumes $volume -}}
  {{- end -}}

  {{- if not (empty $volumes) -}}
    {{- $volumes | toYaml -}}
  {{- end -}}
{{- end -}}
