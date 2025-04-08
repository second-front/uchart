{{- /* Blueprint for service objects. */ -}}
{{- define "2f.uchart.lib.service.blueprint" -}}
  {{- $root := .root -}}
  {{- $serviceObject := .object -}}

  {{- $svcType := default "ClusterIP" $serviceObject.type -}}
  {{- $enabledPorts := include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $serviceObject.ports) | fromYaml -}}
  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $serviceObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/service" $serviceObject.name)
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $serviceObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ $serviceObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
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
  selector: {{ toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
