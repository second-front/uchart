{{- /* Blueprint for configMap objects. */ -}}
{{- define "2f.uchart.blueprints.configMap" -}}
  {{- $root := .root -}}
  {{- $configMapObject := .object -}}

  {{- $annotations := merge
    ($configMapObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    ($configMapObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configMapObject.name }}
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
{{- with $configMapObject.data }}
data:
  {{- tpl (toYaml .) $root | nindent 2 }}
{{- end }}
{{- with $configMapObject.binaryData }}
binaryData:
  {{- tpl (toYaml .) $root | nindent 2 }}
{{- end }}
{{- end -}}

