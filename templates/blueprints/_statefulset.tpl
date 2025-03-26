{{- /* Blueprint for statefulset objects. */ -}}
{{- define "2f.uchart.blueprints.statefulset" -}}
  {{- $root := .root -}}
  {{- $statefulsetObject := .object -}}

  {{- $labels := merge
    (dict "app.kubernetes.io/component" $statefulsetObject.id)
    ($statefulsetObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
  {{- $annotations := merge
    ($statefulsetObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ $statefulsetObject.name }}
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
  namespace: {{ $root.Release.Namespace }}
spec:
  revisionHistoryLimit: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $statefulsetObject.revisionHistoryLimit "default" 3) }}
  replicas: {{ $statefulsetObject.replicas }}
  podManagementPolicy: {{ dig "statefulset" "podManagementPolicy" "OrderedReady" $statefulsetObject }}
  updateStrategy:
    type: {{ $statefulsetObject.strategy }}
    {{- if and (eq $statefulsetObject.strategy "RollingUpdate") (dig "rollingUpdate" "partition" nil $statefulsetObject) }}
    rollingUpdate:
      partition: {{ $statefulsetObject.rollingUpdate.partition }}
    {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/component: {{ $statefulsetObject.id }}
      {{- include "2f.uchart.lib.metadata.selectorLabels" $root | nindent 6 }}
  serviceName: {{ include "2f.uchart.lib.chart.names.fullname" $root }}
  {{- with (dig "statefulset" "persistentVolumeClaimRetentionPolicy" nil $statefulsetObject) }}
  persistentVolumeClaimRetentionPolicy:  {{ . | toYaml | nindent 4 }}
  {{- end }}
  template:
    metadata:
      {{- with (include "2f.uchart.lib.pod.metadata.annotations" (dict "root" $root "workloadObject" $statefulsetObject)) }}
      annotations: {{ . | nindent 8 }}
      {{- end -}}
      {{- with (include "2f.uchart.lib.pod.metadata.labels" (dict "root" $root "workloadObject" $statefulsetObject)) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "2f.uchart.lib.pod.spec" (dict "root" $root "workloadObject" $statefulsetObject) | nindent 6 }}
  {{- with (include "2f.uchart.lib.statefulset.volumeclaimtemplates" (dict "root" $root "statefulsetObject" $statefulsetObject)) }}
  volumeClaimTemplates: {{ . | nindent 4 }}
  {{- end }}
{{- end }}
