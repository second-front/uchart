{{- /* Return a service port number by name for a Service object */ -}}
{{- define "2f.uchart.lib.service.getPortNumberByName" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $portName := .portName -}}

  {{- $service := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.services "id" $id "kind" "service") | fromYaml -}}

  {{- if $service -}}
    {{ $servicePort := dig "ports" $portName "port" nil $service -}}
    {{- if $servicePort -}}
      {{- $servicePort -}}
    {{- end -}}
  {{- end -}}
{{- end -}}