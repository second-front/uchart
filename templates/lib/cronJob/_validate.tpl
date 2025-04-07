{{- /* Validate CronJob values */ -}}
{{- define "2f.uchart.lib.cronJob.validate" -}}
  {{- $root := .root -}}
  {{- $cronJobValues := .object -}}

  {{- if and (ne $cronJobValues.pod.restartPolicy "Never") (ne $cronJobValues.pod.restartPolicy "OnFailure") -}}
    {{- fail (printf "Not a valid restartPolicy type for CronJob. (workload: %s, restartPolicy: %s)" $cronJobValues.id $cronJobValues.pod.restartPolicy) -}}
  {{- end -}}
{{- end -}}
