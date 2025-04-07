{{- /* Blueprint for statefulSet objects. */ -}}
{{- define "2f.uchart.blueprints.statefulSet" -}}
  {{- $root := .root -}}
  {{- $statefulSetObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $statefulSetObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $statefulSetObject.id)
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $statefulSetObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ $statefulSetObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
spec:
  revisionHistoryLimit: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $statefulSetObject.revisionHistoryLimit "default" 3) }}
  replicas: {{ $statefulSetObject.replicas }}
  podManagementPolicy: {{ dig "statefulSet" "podManagementPolicy" "OrderedReady" $statefulSetObject }}
  updateStrategy:
    type: {{ $statefulSetObject.strategy }}
    {{- if and (eq $statefulSetObject.strategy "RollingUpdate") (dig "rollingUpdate" "partition" nil $statefulSetObject) }}
    rollingUpdate:
      partition: {{ $statefulSetObject.rollingUpdate.partition }}
    {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/component: {{ $statefulSetObject.id }}
      {{- include "2f.uchart.lib.metadata.selectorLabels" $root | nindent 6 }}
  serviceName: {{ include "2f.uchart.lib.chart.names.fullname" $root }}
  {{- with (dig "statefulSet" "persistentVolumeClaimRetentionPolicy" nil $statefulSetObject) }}
  persistentVolumeClaimRetentionPolicy:  {{ . | toYaml | nindent 4 }}
  {{- end }}
  template:
    metadata:
      {{- with (include "2f.uchart.lib.pod.metadata.annotations" (dict "root" $root "workloadObject" $statefulSetObject)) }}
      annotations: {{ . | nindent 8 }}
      {{- end -}}
      {{- with (include "2f.uchart.lib.pod.metadata.labels" (dict "root" $root "workloadObject" $statefulSetObject)) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "2f.uchart.lib.pod.spec" (dict "root" $root "workloadObject" $statefulSetObject) | nindent 6 }}
  {{- with (include "2f.uchart.lib.statefulSet.volumeclaimtemplates" (dict "root" $root "statefulSetObject" $statefulSetObject)) }}
  volumeClaimTemplates: {{ . | nindent 4 }}
  {{- end }}
{{- end }}
