{{- /* Blueprint for cronjobs objects. */ -}}
{{- define "2f.uchart.blueprints.cronjob" -}}
  {{- $root := .root -}}
  {{- $cronjobObject := .object -}}

  {{- $timeZone := "" -}}
  {{- if ge (int $root.Capabilities.KubeVersion.Minor) 27 }}
    {{- $timeZone = dig "cronjob" "timeZone" "" $cronjobObject -}}
  {{- end -}}

  {{- $annotations := merge
    ($cronjobObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $cronjobObject.id)
    ($cronjobObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}

  {{- $cronJobSettings := dig "cronjob" dict $cronjobObject -}}
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ $cronjobObject.name }}
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
  suspend: {{ default false $cronJobSettings.suspend }}
  concurrencyPolicy: {{ default "Forbid" $cronJobSettings.concurrencyPolicy }}
  startingDeadlineSeconds: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $cronJobSettings.startingDeadlineSeconds "default" 30) }}
  {{- with $timeZone }}
  timeZone: {{ . }}
  {{- end }}
  schedule: {{ $cronJobSettings.schedule | quote }}
  successfulJobsHistoryLimit: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $cronJobSettings.successfulJobsHistory "default" 1) }}
  failedJobsHistoryLimit: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $cronJobSettings.failedJobsHistory "default" 1) }}
  jobTemplate:
    spec:
      {{- with $cronJobSettings.activeDeadlineSeconds }}
      activeDeadlineSeconds: {{ . }}
      {{- end }}
      {{- with $cronJobSettings.ttlSecondsAfterFinished }}
      ttlSecondsAfterFinished: {{ . }}
      {{- end }}
      {{- with $cronJobSettings.parallelism }}
      parallelism: {{ . }}
      {{- end }}
      backoffLimit: {{ include "2f.uchart.lib.utils.defaultKeepNonNullValue" (dict "value" $cronJobSettings.backoffLimit "default" 6) }}
      template:
        metadata:
          {{- with (include "2f.uchart.lib.pod.metadata.annotations" (dict "root" $root "workloadObject" $cronjobObject)) }}
          annotations: {{ . | nindent 12 }}
          {{- end -}}
          {{- with (include "2f.uchart.lib.pod.metadata.labels" (dict "root" $root "workloadObject" $cronjobObject)) }}
          labels: {{ . | nindent 12 }}
          {{- end }}
        spec: {{ include "2f.uchart.lib.pod.spec" (dict "root" $root "workloadObject" $cronjobObject) | nindent 10 }}
{{- end -}}
