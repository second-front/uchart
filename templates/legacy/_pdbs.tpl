{{- define "2f.uchart.legacy.pdbs" -}}
{{- if or (.Values.argocd.wrapperAppOff) (not .Values.subCharts) }}
{{- range $msvc, $v := .Values.microservices }}
{{- if $v }}
{{/* Variables */}}
{{- $annotations := (and $v.pdb $v.pdb.annotations) | default dict }}
{{- $maxUnavailable := (and $v.pdb $v.pdb.maxUnavailable) | default 0 }}
{{- $minAvailable := (and $v.pdb $v.pdb.minAvailable) }}
{{- if and $v.pdb $v.enabled }}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ $msvc }}-pdb
  namespace: {{ $v.namespace | default $.Release.Namespace }}
  {{- if $annotations }}
  annotations:
{{- range $key, $value := $annotations }}
    {{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
spec:
  {{- if $maxUnavailable }}
  maxUnavailable: {{ $maxUnavailable }}
  {{- end }}
  {{- if $minAvailable }}
  minAvailable: {{ $minAvailable }}
  {{- end }}
  selector:
    matchLabels:
      app: {{ $msvc }}
      app.kubernetes.io/instance: {{ $.Release.Namespace }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
