{{- /* http rules used by a virtualService. */ -}}
{{- define "2f.uchart.lib.virtualService.field.http" -}}
  {{- $root := .root -}}
  {{- $virtualServiceObject := .object -}}
  {{- $httpRules := list -}}

  {{- range $_, $http := $virtualServiceObject.http -}}
    {{- $httpRule := dict -}}

    {{- /* process matches */ -}}
    {{- with $http.match -}}
      {{- $_ := set $httpRule "match" . -}}
    {{- end -}}

    {{- /* add rewrite if present */ -}}
    {{- with $http.rewrite -}}
      {{- $_ := set $httpRule "rewrite" . -}}
    {{- end -}}

    {{- /* process route */ -}}
    {{- with $http.route -}}
      {{- $destination := dict -}}
      {{- $host := "" -}}
      {{- $port := 0 -}}

      {{- if .id -}}
        {{- $service := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.services "id" .id "kind" "service") | fromYaml -}}

        {{- $host = (printf "%s.%s.svc.cluster.local" $service.name $root.Release.Namespace) -}}

        {{- if not .port -}}
          {{- $port = (include "2f.uchart.lib.service.primaryPort" (dict "root" $root "serviceObject" $service) | fromYaml).port -}}
        {{- else if kindIs "string" .port -}}
        {{- /* If a port name is given, try to resolve to a number */ -}}
          {{- $port = include "2f.uchart.lib.service.getPortNumberByName" (dict "root" $root "id" .id "portName" .port) | int -}}
        {{- else -}}
          {{- $port = .port -}}
        {{- end -}}

      {{- else if .host -}}
        {{- $host = tpl .host $root | toString -}}
        {{- $port = .port | required "route by host requires explict port defined" -}}
      {{- end }}
      
      {{- $_ := set $destination "host" $host -}}
      {{- $_ := set $destination "port" (dict "number" $port) -}}

      {{- if not (empty $destination) -}}
        {{- $_ := set $httpRule "route" (list (dict "destination" $destination)) -}}
      {{- end -}}
    {{- end -}}

    {{- if not (empty $httpRule) -}}
      {{- $httpRules = append $httpRules $httpRule -}}
    {{- end -}}
  {{- end -}}

  {{- /* Return the http object */ -}}
  {{- $httpRules | toYaml -}}
{{- end -}}