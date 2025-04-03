{{- /* Initialize Cronjob values */ -}}
{{- define "2f.uchart.lib.cronjob.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $objectValues := .values -}}

  {{- if not (hasKey $objectValues "pod") -}}
    {{- $_ := set $objectValues "pod" dict -}}
  {{- end -}}

  {{- $restartPolicy := default "Never" $objectValues.pod.restartPolicy -}}
  {{- $_ := set $objectValues.pod "restartPolicy" $restartPolicy -}}

  {{- /* Return the CronJob object */ -}}
  {{- $objectValues | toYaml -}}
{{- end -}}
