{{- define "2f.uchart.legacy.multiContainer.deployment" -}}
{{- if or (.Values.argocd.wrapperAppOff) ( not .Values.subCharts ) }}
{{- range $msvc, $v := .Values.microservices}}
{{- with $ -}}
{{ if not (empty $v) }}
{{- $statefulsetEnabled := (($v.statefulset).enabled) }}
{{- if not $statefulsetEnabled }}
{{- $daemonsetEnabled := (($v.daemonset).enabled) }}
{{- if not $daemonsetEnabled }}
{{- if and  $v.containers (ne $v.enabled false)}}
{{/* Variables */}}
{{- $annotations := $v.annotations | default (dict) }}
{{- $autoscalingEnabled := (($v.autoscaling).enabled) | default .Values.defaults.autoscaling.enabled }}
{{- $labels := $v.labels }}
{{- $namespace := $v.namespace | default .Release.Namespace }}
{{- $replicaCount := $v.replicaCount | default .Values.defaults.replicaCount }}
{{- $selectorLabels := $v.selectorLabels }}
{{- $strategy := $v.strategy | default .Values.defaults.strategy }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $msvc }}
  namespace: {{ $namespace }}
  labels:
    app: {{ $msvc }}
    {{- include "universal-app-chart.labels" . | nindent 4 }}
    {{- include "universal-app-chart.istioLabels" . | nindent 4 }}
    {{- if $labels -}} {{- toYaml $labels | nindent 4 }} {{- end }}
  {{- if $annotations }}
  annotations:
    {{- toYaml $annotations | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: 3
  {{- if not $autoscalingEnabled }}
  replicas: {{ $replicaCount }}
  {{- end }}
  strategy:
    {{- toYaml $strategy | nindent 4 }}
  selector:
    matchLabels:
      app: {{ $msvc }}
      {{- include "universal-app-chart.selectorLabels" . | nindent 6 }}
      {{- include "universal-app-chart.istioLabels" . | nindent 6 }}
      {{- if $selectorLabels -}} {{- toYaml $selectorLabels | nindent 6 }} {{- end }}
  template:
    {{- include "containerTemplate" (dict "msvc" $msvc "image" $v.image "Values" .Values "global" $ "v" $v) | nindent 4 }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
