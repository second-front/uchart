{{- /* Return the primary service object for a workload */ -}}
{{- define "2f.uchart.lib.service.primaryForWorkload" -}}
  {{- $root := .root -}}
  {{- $workloadId := .workloadId -}}
  {{- $serviceResources := $root.Values.services -}}

  {{- $id := "" -}}
  {{- $result := dict -}}

  {{- /* Loop over all enabled services */ -}}
  {{- $enabledServices := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $serviceResources) | fromYaml -}}
  {{- /* We are only interested in services for the specified workload */ -}}
  {{- $enabledServicesForWorkload := dict -}}
  {{- range $name, $service := $enabledServices -}}
    {{- if eq $service.workload $workloadId -}}
      {{- $_ := set $enabledServicesForWorkload $name $service -}}
    {{- end -}}
  {{- end -}}

  {{- if not (empty $enabledServicesForWorkload) -}}
    {{- range $name, $service := $enabledServicesForWorkload -}}
      {{- /* Determine the Service that has been marked as primary */ -}}
      {{- if $service.primary -}}
        {{- $id = $name -}}
        {{- $result = $service -}}
      {{- end -}}
    {{- end -}}

    {{- /* Return the first Service (alphabetically) if none has been explicitly marked as primary */ -}}
    {{- if not $result -}}
      {{- $firstServiceKey := keys $enabledServicesForWorkload | sortAlpha | first -}}
      {{- $result = get $enabledServicesForWorkload $firstServiceKey -}}
      {{- $id = $firstServiceKey -}}
    {{- end -}}

    {{- include "2f.uchart.lib.utils.initialize" (dict "root" $root "id" $id "values" $result "resources" $serviceResources "kind" "service") -}}
  {{- end -}}
{{- end -}}
