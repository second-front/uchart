{{- /* Blueprint for Pod DisruptionBudget objects. */ -}}
{{- define "2f.uchart.blueprints.podDisruptionBudget" -}}
  {{- $root := .root -}}
  {{- $pdbObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $pdbObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $pdbObject.id)
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $pdbObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ $pdbObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
spec:
  {{- with $pdbObject.unhealthyPodEvictionPolicy }}
  unhealthyPodEvictionPolicy: {{ . }}
  {{- end }}
  {{- with $pdbObject.maxUnavailable }}
  maxUnavailable: {{ . }}
  {{- end }}
  {{- with $pdbObject.minAvailable }}
  minAvailable: {{ . }}
  {{- end }}
  selector:
    matchLabels:
      app.kubernetes.io/component: {{ $pdbObject.id }}
      {{- include "2f.uchart.lib.metadata.selectorLabels" $root | nindent 6 }}
{{- end }}