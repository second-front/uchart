{{- /* Return the primary port for a given Service object. */ -}}
{{- define "2f.uchart.lib.service.primaryPort" -}}
  {{- $root := .root -}}
  {{- $serviceObject := .serviceObject -}}
  {{- $result := "" -}}

  {{- /* Loop over all enabled ports */ -}}
  {{- $enabledPorts := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $serviceObject.ports) | fromYaml -}}
  {{- range $name, $port := $enabledPorts -}}
    {{- /* Determine the port that has been marked as primary */ -}}
    {{- if and (hasKey $port "primary") $port.primary -}}
      {{- $result = $port -}}
    {{- end -}}
  {{- end -}}

  {{- /* Return the first port (alphabetically) if none has been explicitly marked as primary */ -}}
  {{- if not $result -}}
    {{- $firstPortKey := keys $enabledPorts | sortAlpha | first -}}
    {{- if $firstPortKey -}}
      {{- $result = get $enabledPorts $firstPortKey -}}
    {{- end -}}
  {{- end -}}

  {{- $result | toYaml -}}
{{- end -}}
