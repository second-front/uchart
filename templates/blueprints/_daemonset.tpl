{{- /* Blueprint for daemonset objects. */ -}}
{{- define "2f.uchart.blueprints.daemonset" -}}
  {{- $root := .root -}}
  {{- $daemonsetObject := .object -}}

  {{- $labels := merge
    (dict "app.kubernetes.io/component" $daemonsetObject.id)
    ($daemonsetObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
  {{- $annotations := merge
    ($daemonsetObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: {{ $daemonsetObject.name }}
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
