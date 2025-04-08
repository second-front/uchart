{{- /* Blueprint for extra manifest objects. */ -}}
{{- define "2f.uchart.lib.extraManifest.blueprint" -}}
  {{- $root := .root -}}
  {{- $resourceObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $resourceObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $resourceObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: {{ $resourceObject.apiVersion }}
kind: {{ $resourceObject.kind }}
metadata:
  name: {{ $resourceObject.name }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with (omit $resourceObject "id" "name" "apiVersion" "kind" "labels" "annotations") }}
    {{- include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" (. | toYaml)) | nindent 0 }}
  {{- end }}
{{- end }}
