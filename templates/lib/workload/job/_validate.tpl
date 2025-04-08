{{- /* Validate job values */ -}}
{{- define "2f.uchart.lib.workload.job.validate" -}}
  {{- $root := .root -}}
  {{- $jobValues := .object -}}

  {{- $allowedRestartPolicy := list "Never" "OnFailure" -}}
  {{- if not (has $jobValues.pod.restartPolicy $allowedRestartPolicy) -}}
    {{- fail (printf "Not a valid restart policy for Job (workload: %s, strategy: %s)" $jobValues.id $jobValues.pod.restartPolicy) -}}
  {{- end -}}
{{- end -}}