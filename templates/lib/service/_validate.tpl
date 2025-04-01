{{- /* Validate Service values */ -}}
{{- define "2f.uchart.lib.service.validate" -}}
  {{- $root := .root -}}
  {{- $serviceObject := .object -}}

  {{- if empty (get $serviceObject "workload") -}}
    {{- fail (printf "workload field is required for Service. (service: %s)" $serviceObject.id) -}}
  {{- end -}}

  {{- $serviceWorkload := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.workloads "id" $serviceObject.workload "kind" "workload") -}}
  {{- if empty $serviceWorkload -}}
    {{- fail (printf "No enabled workload found with this id. (service: '%s', workload: '%s')" $serviceObject.id $serviceObject.workload) -}}
  {{- end -}}

  {{- /* Validate Service type */ -}}
  {{- $validServiceTypes := (list "ClusterIP" "LoadBalancer" "NodePort" "ExternalName" "ExternalIP") -}}
  {{- if and $serviceObject.type (not (mustHas $serviceObject.type $validServiceTypes)) -}}
    {{- fail (
      printf "invalid service type \"%s\" for Service (service: %s). Allowed values are [%s]"
      $serviceObject.type
      $serviceObject.id
      (join ", " $validServiceTypes)
    ) -}}
  {{- end -}}

  {{- if ne $serviceObject.type "ExternalName" -}}
    {{- $enabledPorts := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $serviceObject.ports) | fromYaml ) }}
    {{- /* Validate at least one port is enabled */ -}}
    {{- if not $enabledPorts -}}
      {{- fail (printf "no ports are enabled for Service (service: %s)" $serviceObject.id) -}}
    {{- end -}}

    {{- range $name, $port := $enabledPorts -}}
      {{- /* Validate a port number is configured */ -}}
      {{- if not $port.port -}}
        {{- fail (printf "no port number is configured for port \"%s\" under Service (service: %s)" $name $serviceObject.id) -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
