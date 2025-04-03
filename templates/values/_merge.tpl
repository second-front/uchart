{{- /* Merge the local chart values and the chart defaults */ -}}
{{- define "2f.uchart.values.merge" -}}
  {{- if .Values.uchart -}}
    {{- $defaultValues := deepCopy .Values.uchart -}}
    {{- $userValues := deepCopy (omit .Values "uchart") -}}
    {{- $mergedValues := mustMergeOverwrite $defaultValues $userValues -}}
    {{- $_ := set . "Values" (deepCopy $mergedValues) -}}
  {{- end -}}
{{- end -}}