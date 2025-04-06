{{- /* VolumeClaimTemplates for StatefulSet */ -}}
{{- define "2f.uchart.lib.statefulset.volumeclaimtemplates" -}}
  {{- $root := .root -}}
  {{- $statefulsetObject := .statefulsetObject -}}

  {{- /* Default to empty list */ -}}
  {{- $volumeClaimTemplates := list -}}

  {{- range $id, $volumeClaimTemplate := (dig "statefulset" "volumeClaimTemplates" dict $statefulsetObject) -}}
    {{- $vct := include "2f.uchart.lib.statefulset.volumeclaimtemplate" (dict "root" $root "id" $id "values" $volumeClaimTemplate) -}}
    {{- $volumeClaimTemplates = append $volumeClaimTemplates ($vct | fromYaml) -}}
  {{- end -}}

  {{- if not (empty $volumeClaimTemplates) -}}
    {{- $volumeClaimTemplates | toYaml -}}
  {{- end -}}
{{- end -}}

{{- /* Single VolumeClaimTemplate template */ -}}
{{- define "2f.uchart.lib.statefulset.volumeclaimtemplate" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $values := .values -}}

metadata:
  name: {{ $id }}
  {{- with ($values.labels | default dict) }}
  labels: {{- toYaml . | nindent 10 }}
  {{- end }}
  {{- with ($values.annotations | default dict) }}
  annotations: {{- toYaml . | nindent 10 }}
  {{- end }}
spec:
  accessModes:
    - {{ $values.accessMode  | quote }}
  resources:
    requests:
      storage: {{ $values.size | quote }}
  {{- if $values.storageClass }}
  storageClassName: {{ if (eq "-" $values.storageClass) }}""{{- else }}{{ $values.storageClass | quote }}{{- end }}
  {{- end }}
  {{- with $values.dataSource }}
  dataSource: {{- tpl (toYaml .) $root | nindent 10 }}
  {{- end }}
  {{- with $values.dataSourceRef }}
  dataSourceRef: {{- tpl (toYaml .) $root | nindent 10 }}
  {{- end }}
{{- end -}}
