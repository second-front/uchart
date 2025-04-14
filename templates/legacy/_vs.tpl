{{- define "2f.uchart.legacy.virtualService" -}}
{{- if or (.Values.argocd.wrapperAppOff) ( not .Values.subCharts ) }}
{{- $virtualServiceEnabled := .Values.defaults.virtualService.enabled }}
{{- $multiContainerPodsExist := false }}
{{- range $msvc, $v := .Values.microservices }}
  {{ if not (empty $v) }}
  {{- if hasKey $v "containers" }}
    {{- $multiContainerPodsExist = true }}
    {{- break }}
  {{- end }}
{{- end }}
{{- end }}

{{- if and $virtualServiceEnabled .Values.microservices (not $multiContainerPodsExist) }}
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: {{ .Values.global.applicationName | default .Values.applicationName }}
  namespace: {{ .Release.Namespace }}
spec:
  hosts:
    - {{ .Values.global.applicationName | default .Values.applicationName }}.{{ .Values.defaults.domain }}
  gateways:
    - {{ .Values.gateway | default .Values.global.gateway }}
  http:
    {{- range $msvc, $v := .Values.microservices}}
    {{- with $ -}}
    {{- if $v }}
    {{- $port := (($v.service).port) | default .Values.defaults.service.port}}
    {{- range $match := $v.match}}
    - match:
      - uri:
          prefix: {{ $match.uri.prefix }}
      route:
      - destination:
          {{- if $match.uri.host}}
          host: {{ $match.uri.host }}
          {{- else }}
          host: {{ $msvc }}
          {{- end }}
          port:
            {{- if $match.uri.number }}
            number: {{ $match.uri.number }}
            {{- else }}
            number: {{ $port }}
            {{- end}}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
{{- end }}
{{- end }}
