{{- /* Blueprint for Deployment objects. */ -}}
{{- define "2f.uchart.blueprints.deployment" -}}
  {{- $root := .root -}}
  {{- $deploymentObject := .object -}}
  {{- $autoScalingEnabled := dig "autoscaling" "enabled" false $deploymentObject }}

  {{- $annotations := merge
    ($deploymentObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $deploymentObject.id)
    ($deploymentObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $deploymentObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
      {{- printf "%s: %s" $key (tpl $value $root | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
      {{- printf "%s: %s" $key (tpl $value $root | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
spec:
  revisionHistoryLimit: 3
  {{- if not $autoScalingEnabled }}
    {{- if hasKey $deploymentObject "replicas" }}
      {{- if not (eq $deploymentObject.replicas nil) }}
  replicas: {{ $deploymentObject.replicas }}
      {{- end }}
    {{- else }}
  replicas: 1
    {{- end }}
  {{- end }}
  strategy:
    type: {{ $deploymentObject.strategy }}
    {{- if eq $deploymentObject.strategy "RollingUpdate" }}
      {{- with $deploymentObject.rollingUpdate }}
    rollingUpdate:
        {{- with .maxUnavailable }}
      maxUnavailable: {{ . }}
        {{- end }}
        {{- with .maxSurge }}
      maxSurge: {{ . }}
        {{- end }}
      {{- end }}
    {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/component: {{ $deploymentObject.id }}
      {{- include "2f.uchart.lib.metadata.selectorLabels" $root | nindent 6 }}
      {{- with $deploymentObject.selectorLabels }}
        {{- toYaml . | nindent 6 }}
      {{- end }}
  template:
    metadata:
      {{- with (include "2f.uchart.lib.pod.metadata.annotations" (dict "root" $root "workloadObject" $deploymentObject )) }}
      annotations: {{ . | nindent 8 }}
      {{- end }}
      {{- with (include "2f.uchart.lib.pod.metadata.labels" (dict "root" $root "workloadObject" $deploymentObject )) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "2f.uchart.lib.pod.spec" (dict "root" $root "workloadObject" $deploymentObject) | nindent 6 }}
{{- end }}

