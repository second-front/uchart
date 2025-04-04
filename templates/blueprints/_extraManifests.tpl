{{- /* Blueprint for extra manifest objects. */ -}}
{{- define "2f.uchart.blueprints.extraManifest" -}}
  {{- $root := .root -}}
  {{- $resourceObject := .object -}}

  {{- $annotations := merge
    ($resourceObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    ($resourceObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}
---
apiVersion: {{ $resourceObject.apiVersion }}
kind: {{ $resourceObject.kind }}
metadata:
  name: {{ $resourceObject.name }}
  {{- with $labels }}
  labels:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $root | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with $annotations }}
  annotations:
    {{- range $key, $value := . }}
    {{- printf "%s: %s" $key (tpl $value $root | toYaml ) | nindent 4 }}
    {{- end }}
  {{- end }}
  {{- with (omit $resourceObject "id" "name" "apiVersion" "kind" "labels" "annotations") }}
    {{- tpl (toYaml .) $root | nindent 0 }}
  {{- end }}
{{- end }}