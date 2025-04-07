{{- /* Blueprint for cronJobs objects. */ -}}
{{- define "2f.uchart.blueprints.cronJob" -}}
  {{- $root := .root -}}
  {{- $cronJobObject := .object -}}

  {{- $timeZone := "" -}}
  {{- if ge (int $root.Capabilities.KubeVersion.Minor) 27 }}
    {{- $timeZone = dig "cronJob" "timeZone" "" $cronJobObject -}}
  {{- end -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $cronJobObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $cronJobObject.id)
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $cronJobObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}

  {{- $cronJobSettings := dig "cronJob" dict $cronJobObject -}}
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ $cronJobObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
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
          {{- with (include "2f.uchart.lib.pod.metadata.annotations" (dict "root" $root "workloadObject" $cronJobObject)) }}
          annotations: {{ . | nindent 12 }}
          {{- end -}}
          {{- with (include "2f.uchart.lib.pod.metadata.labels" (dict "root" $root "workloadObject" $cronJobObject)) }}
          labels: {{ . | nindent 12 }}
          {{- end }}
        spec: {{ include "2f.uchart.lib.pod.spec" (dict "root" $root "workloadObject" $cronJobObject) | nindent 10 }}
{{- end -}}
