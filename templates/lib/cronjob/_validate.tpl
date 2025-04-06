{{- /* Validate CronJob values */ -}}
{{- define "2f.uchart.lib.cronjob.validate" -}}
  {{- $root := .root -}}
  {{- $cronjobValues := .object -}}

  {{- if and (ne $cronjobValues.pod.restartPolicy "Never") (ne $cronjobValues.pod.restartPolicy "OnFailure") -}}
    {{- fail (printf "Not a valid restartPolicy type for CronJob. (workload: %s, restartPolicy: %s)" $cronjobValues.id $cronjobValues.pod.restartPolicy) -}}
  {{- end -}}
{{- end -}}
