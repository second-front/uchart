{{- /* Blueprint for service objects. */ -}}
{{- define "2f.uchart.blueprints.service" -}}
  {{- $root := .root -}}
  {{- $serviceObject := .object -}}

  {{- $svcType := default "ClusterIP" $serviceObject.type -}}
  {{- $enabledPorts := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $serviceObject.ports) | fromYaml -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/service" $serviceObject.name)
    ($serviceObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
  {{- $annotations := merge
    ($serviceObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ $serviceObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $root | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $root | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
spec:
  {{- if (eq $svcType "ClusterIP") }}
  type: ClusterIP
  {{- if $serviceObject.clusterIP }}
  clusterIP: {{ $serviceObject.clusterIP }}
  {{- end }}
  {{- else if eq $svcType "LoadBalancer" }}
  type: {{ $svcType }}
  {{- if $serviceObject.loadBalancerIP }}
  loadBalancerIP: {{ $serviceObject.loadBalancerIP }}
  {{- end }}
  {{- if $serviceObject.loadBalancerClass }}
  loadBalancerClass: {{ $serviceObject.loadBalancerClass }}
  {{- end }}
  {{- else if eq $svcType "ExternalName" }}
  type: {{ $svcType }}
  {{- if $serviceObject.externalName }}
  externalName: {{ $serviceObject.externalName }}
  {{- end }}
  {{- else }}
  type: {{ $svcType }}
  {{- end }}
  {{- if $serviceObject.internalTrafficPolicy }}
  internalTrafficPolicy: {{ $serviceObject.internalTrafficPolicy }}
  {{- end }}
  {{- if $serviceObject.externalTrafficPolicy }}
  externalTrafficPolicy: {{ $serviceObject.externalTrafficPolicy }}
  {{- end }}
  {{- if $serviceObject.sessionAffinity }}
  sessionAffinity: {{ $serviceObject.sessionAffinity }}
  {{- end }}
  {{- with $serviceObject.externalIPs }}
  externalIPs:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  ports:
  {{- range $name, $port := $enabledPorts }}
    - port: {{ $port.port }}
      targetPort: {{ $port.targetPort | default $port.port }}
      {{- if $port.protocol }}
        {{- if or ( eq $port.protocol "HTTP" ) ( eq $port.protocol "HTTPS" ) ( eq $port.protocol "TCP" ) }}
      protocol: TCP
        {{- else }}
      protocol: {{ $port.protocol }}
        {{- end }}
      {{- else }}
      protocol: TCP
      {{- end }}
      name: {{ $name }}
      {{- if (not (empty $port.nodePort)) }}
      nodePort: {{ $port.nodePort }}
      {{- end }}
      {{- if (not (empty $port.appProtocol)) }}
      appProtocol: {{ $port.appProtocol }}
      {{- end }}
    {{- end }}
  {{- with (merge
    ($serviceObject.extraSelectorLabels | default dict)
    (dict "app.kubernetes.io/component" $serviceObject.workload)
    (include "2f.uchart.lib.metadata.selectorLabels" $root | fromYaml)
  ) }}
  selector: {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
