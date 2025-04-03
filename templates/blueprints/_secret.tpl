{{- /* Blueprint for secret objects. */ -}}
{{- define "2f.uchart.blueprints.secret" -}}
  {{- $root := .root -}}
  {{- $secretObject := .object -}}

  {{- $annotations := merge
    ($secretObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    ($secretObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}

  {{- $stringData := "" -}}
  {{- with $secretObject.stringData -}}
    {{- $stringData = (toYaml $secretObject.stringData) | trim -}}
  {{- end -}}
---
apiVersion: v1
kind: Secret
{{- with $secretObject.type }}
type: {{ . }}
{{- end }}
metadata:
  name: {{ $secretObject.name }}
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
{{- with $stringData }}
stringData: {{- tpl $stringData $root | nindent 2 }}
{{- end }}
{{- end -}}
