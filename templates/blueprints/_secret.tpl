{{- /* Blueprint for secret objects. */ -}}
{{- define "2f.uchart.blueprints.secret" -}}
  {{- $root := .root -}}
  {{- $secretObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $secretObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $secretObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
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
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
{{- with $stringData }}
stringData: {{- include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" $stringData) | nindent 2 }}
{{- end }}
{{- end -}}
