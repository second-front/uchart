{{- /* Blueprint for Pod DisruptionBudget objects. */ -}}
{{- define "2f.uchart.blueprints.podDisruptionBudget" -}}
  {{- $root := .root -}}
  {{- $pdbObject := .object -}}

  {{- $annotations := merge
    ($pdbObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (dict "app.kubernetes.io/component" $pdbObject.id)
    ($pdbObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: {{ $pdbObject.name }}
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