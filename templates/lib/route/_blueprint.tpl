{{- /* Blueprint for route objects. */ -}}
{{- define "2f.uchart.lib.route.blueprint" -}}
  {{- $root := .root -}}
  {{- $routeObject := .object -}}

  {{- $routeKind := $routeObject.kind | default "HTTPRoute" -}}
  {{- $apiVersion := "gateway.networking.k8s.io/v1alpha2" -}}
  {{- if $root.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/v1beta1/%s" $routeKind) }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1beta1" -}}
  {{- end -}}
  {{- if $root.Capabilities.APIVersions.Has (printf "gateway.networking.k8s.io/v1/%s" $routeKind) }}
    {{- $apiVersion = "gateway.networking.k8s.io/v1" -}}
  {{- end -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $routeObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $routeObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: {{ $apiVersion }}
kind: {{ $routeKind }}
metadata:
  name: {{ $routeObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
spec:
  parentRefs:
  {{- range $routeObject.parentRefs }}
    - group: {{ .group | default "gateway.networking.k8s.io" }}
      kind: {{ .kind | default "Gateway" }}
      name: {{ required (printf "parentRef name is required for %v %v" $routeKind $routeObject.name) .name }}
      namespace: {{ required (printf "parentRef namespace is required for %v %v" $routeKind $routeObject.name) .namespace }}
      {{- if .sectionName }}
      sectionName: {{ .sectionName | quote }}
      {{- end }}
  {{- end }}
  {{- if and (ne $routeKind "TCPRoute") (ne $routeKind "UDPRoute") $routeObject.hostnames }}
  hostnames:
    {{- range $routeObject.hostnames }}
    - {{ include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" .) | toString }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $routeObject.rules }}
  - backendRefs:
    {{- range .backendRefs }}
      {{- $service := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.services "id" .name "kind" "service") | fromYaml }}
      {{- $servicePrimaryPort := dict }}
      {{- if $service }}
        {{- $servicePrimaryPort = include "2f.uchart.lib.service..utils.primaryPort" (dict "root" $root "serviceObject" $service) | fromYaml }}
      {{- end }}
    - group: {{ .group | default "" | quote}}
      kind: {{ .kind | default "Service" }}
      name: {{ $service.name | default .name }}
      namespace: {{ .namespace | default $root.Release.Namespace }}
      port: {{ .port | default $servicePrimaryPort.port }}
      weight: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" .weight "default" 1) }}
    {{- end }}
    {{- if or (eq $routeKind "HTTPRoute") (eq $routeKind "GRPCRoute") }}
      {{- with .matches }}
    matches:
        {{- toYaml . | nindent 6 }}
      {{- end }}
        {{- with .filters }}
    filters:
        {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
    {{- if (eq $routeKind "HTTPRoute") }}
      {{- with .timeouts }}
    timeouts:
        {{- toYaml . | nindent 6 }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
