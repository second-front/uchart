{{- /* Validate Route values */ -}}
{{- define "2f.uchart.lib.route.validate" -}}
  {{- $root := .root -}}
  {{- $routeObject := .object -}}

  {{- /* Route Types */ -}}
  {{- $routeKind := $routeObject.kind | default "HTTPRoute" -}}
  {{- $routeKinds := list "GRPCRoute" "HTTPRoute" "TCPRoute" "TLSRoute" "UDPRoute" -}}
  {{- if not (has $routeKind $routeKinds) -}}
    {{- fail (printf "Not a valid route kind (%s)" $routeKind) -}}
  {{- end -}}

  {{- /* Route Rules */ -}}

  {{- range $routeObject.rules -}}
  {{- if and (.filters) (.backendRefs) -}}
    {{- range .filters -}}
      {{- if eq .type "RequestRedirect" -}}
        {{- fail (printf "backend refs and request redirect filters cannot co-exist.") -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- end -}}
{{- end -}}
