{{- /* Blueprint for HorizontalPodAutoscaler objects. */ -}}
{{- define "2f.uchart.blueprints.horizontalPodAutoscaler" -}}
  {{- $root := .root -}}
  {{- $hpaObject := .object -}}

  {{- $annotations := merge
    ($hpaObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $hpaObject.id)
    ($hpaObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $hpaObject.name }}
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
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ $hpaObject.workloadType }}
    name: {{ $hpaObject.workloadName }}
  minReplicas: {{ $hpaObject.minReplicas | default 1 }}
  maxReplicas: {{ $hpaObject.maxReplicas | default 6 }}
  metrics:
  {{- with $hpaObject.metrics }}
    {{- values . | toYaml | nindent 4 }}
  {{- end }}
  {{- if hasKey $hpaObject "targetMemoryUtilizationPercentage" }}
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: {{ $hpaObject.targetMemoryUtilizationPercentage }}
  {{- end }}
  {{- if hasKey $hpaObject "targetCpuUtilizationPercentage" }}
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ $hpaObject.targetCpuUtilizationPercentage }}
  {{- end }}
{{- end -}}
