{{- /* Validate virtualService values */ -}}
{{- define "2f.uchart.lib.virtualService.validate" -}}
  {{- $root := .root -}}
  {{- $virtualServiceObject := .object -}}

  {{- range $virtualServiceObject.http -}}
    {{- with .route -}}
      {{- /* ensure all id references resolve */ -}}
      {{- if .id -}}
        {{- $service := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.services "id" .id "kind" "service") |fromYaml -}}
        {{- if empty $service -}}
          {{- fail (printf "No enabled service found with this id. (virtualService: '%s', service: '%s')" $virtualServiceObject.id .id) -}}
        {{- end -}}

        {{- /* ensure all port name references resolve */ -}}
        {{- if and .port (kindIs "string" .port) -}}
          {{- $port := include "2f.uchart.lib.service.getPortNumberByName" (dict "root" $root "id" .id "portName" .port) -}}
          {{- if not $port -}}
            {{- fail (printf "unable to resolve port with this name. (virtualService: '%s', service: '%s', port: '%s')" $virtualServiceObject.id .id .port) -}}
          {{- end -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
