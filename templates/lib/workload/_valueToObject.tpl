{{/*
Convert workload values to an object
*/}}
{{- define "2f.uchart.lib.workload.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- /* Default the workload type to Deployment */ -}}
  {{- if empty (dig "type" nil $objectValues) -}}
    {{- $_ := set $objectValues "type" "deployment" -}}
  {{- end -}}

  {{- /* Determine and inject the workload name */ -}}
  {{- $objectName := (include "2f.uchart.lib.chart.names.fullname" $root) -}}

  {{- if $objectValues.nameOverride -}}
    {{- $override := tpl $objectValues.nameOverride $root -}}
    {{- if not (eq $objectName $override) -}}
      {{- $objectName = printf "%s-%s" $objectName $override -}}
    {{- end -}}
  {{- else -}}
    {{- $enabledWorkloads := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $root.Values.workloads) | fromYaml ) }}
    {{- if gt (len $enabledWorkloads) 1 -}}
      {{- if not (eq $objectName $id) -}}
        {{- $objectName = printf "%s-%s" $objectName $id -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- $_ := set $objectValues "name" $objectName -}}
  {{- $_ := set $objectValues "id" $id -}}

  {{- /* Return the workload object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
