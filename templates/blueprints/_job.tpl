{{- /* Blueprint for Job objects. */ -}}
{{- define "2f.uchart.blueprints.job" -}}
  {{- $root := .root -}}
  {{- $jobObject := .object -}}

  {{- $annotations := merge
    ($jobObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $jobObject.id)
    ($jobObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}

  {{- $jobSettings := dig "job" dict $jobObject -}}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $jobObject.name }}
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
  suspend: {{ default false $jobSettings.suspend }}
  {{- with $jobSettings.activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ . }}
  {{- end }}
  {{- with $jobSettings.ttlSecondsAfterFinished }}
  ttlSecondsAfterFinished: {{ . }}
  {{- end }}
  {{- with $jobSettings.parallelism }}
  parallelism: {{ . }}
  {{- end }}
  {{- with $jobSettings.completions }}
  completions: {{ . }}
  {{- end }}
  {{- with $jobSettings.completionMode }}
  completionMode: {{ . }}
  {{- end }}
  backoffLimit: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $jobSettings.backoffLimit "default" 6) }}
  template:
    metadata:
      {{- with (include "2f.uchart.lib.pod.metadata.annotations" (dict "root" $root "workloadObject" $jobObject)) }}
      annotations: {{ . | nindent 8 }}
      {{- end -}}
      {{- with (include "2f.uchart.lib.pod.metadata.labels" (dict "root" $root "workloadObject" $jobObject)) }}
      labels: {{ . | nindent 8 }}
      {{- end }}
    spec: {{ include "2f.uchart.lib.pod.spec" (dict "root" $root "workloadObject" $jobObject) | nindent 6 }}
{{- end -}}