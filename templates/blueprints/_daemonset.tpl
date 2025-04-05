{{- /* Blueprint for daemonset objects. */ -}}
{{- define "2f.uchart.blueprints.daemonset" -}}
  {{- $root := .root -}}
  {{- $daemonsetObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $daemonsetObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $daemonsetObject.id)
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $daemonsetObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: {{ $daemonsetObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4}}
  {{- end }}
spec:
  revisionHistoryLimit: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $daemonsetObject.revisionHistoryLimit "default" 3) }}
  selector:
    matchLabels:
      app.kubernetes.io/component: {{ $daemonsetObject.id }}
      {{- include "2f.uchart.lib.metadata.selectorLabels" $root | nindent 6 }}
  template:
    metadata:
      annotations: {{ include "2f.uchart.lib.pod.metadata.annotations" (dict "root" $root "workloadObject" $daemonsetObject) | nindent 8 }}
      labels: {{ include "2f.uchart.lib.pod.metadata.labels" (dict "root" $root "workloadObject" $daemonsetObject) | nindent 8 }}
    spec: {{ include "2f.uchart.lib.pod.spec" (dict "root" $root "workloadObject" $daemonsetObject) | nindent 6 }}
{{- end }}
