{{- /* Blueprint for HorizontalPodAutoscaler objects. */ -}}
{{- define "2f.uchart.lib.horizontalPodAutoscaler.blueprint" -}}
  {{- $root := .root -}}
  {{- $hpaObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $hpaObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $hpaObject.id)
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $hpaObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $hpaObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
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
