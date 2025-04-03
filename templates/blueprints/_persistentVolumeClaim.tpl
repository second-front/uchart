{{- /* Blueprint for persistentVolumeClaim objects. */ -}}
{{- define "2f.uchart.blueprints.persistentVolumeClaim" -}}
  {{- $root := .root -}}
  {{- $pvcObject := .object -}}

  {{- $annotations := merge
    ($pvcObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    ($pvcObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
  {{- if $pvcObject.retain }}
    {{- $annotations = merge
      (dict "helm.sh/resource-policy" "keep")
      $annotations
    -}}
  {{- end -}}

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ $pvcObject.name }}
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
  accessModes:
    - {{ required (printf "accessMode is required for PVC %v" $pvcObject.name) $pvcObject.accessMode | quote }}
  resources:
    requests:
      storage: {{ required (printf "size is required for PVC %v" $pvcObject.name) $pvcObject.size | quote }}
  {{- if $pvcObject.storageClass }}
  storageClassName: {{ if (eq "-" $pvcObject.storageClass) }}""{{- else }}{{ $pvcObject.storageClass | quote }}{{- end }}
  {{- end }}
  {{- if $pvcObject.volumeName }}
  volumeName: {{ $pvcObject.volumeName | quote }}
  {{- end }}
  {{- with $pvcObject.dataSource }}
  dataSource: {{- tpl (toYaml .) $root | nindent 10 }}
  {{- end }}
  {{- with $pvcObject.dataSourceRef }}
  dataSourceRef: {{- tpl (toYaml .) $root | nindent 10 }}
  {{- end }}
{{- end -}}