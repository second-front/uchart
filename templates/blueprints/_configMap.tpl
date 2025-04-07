{{- /* Blueprint for configMap objects. */ -}}
{{- define "2f.uchart.blueprints.configMap" -}}
  {{- $root := .root -}}
  {{- $configMapObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $configMapObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $configMapObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configMapObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
{{- with $configMapObject.data }}
data:
  {{- include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" (. | toYaml)) | nindent 2 }}
{{- end }}
{{- with $configMapObject.binaryData }}
binaryData:
  {{- include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" (. | toYaml)) | nindent 2 }}
{{- end }}
{{- end -}}

