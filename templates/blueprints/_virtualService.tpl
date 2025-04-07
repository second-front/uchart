{{- /* Blueprint for virtualService objects. */ -}}
{{- define "2f.uchart.blueprints.virtualService" -}}
  {{- $root := .root -}}
  {{- $virtualServiceObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $virtualServiceObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $virtualServiceObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}

---
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: {{ $virtualServiceObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4}}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
spec:
  hosts:
  {{- if hasKey $virtualServiceObject "hostname" }}
    - {{ include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" $virtualServiceObject.hostname) | toString }}
  {{- else }}
    - {{ printf "%s.%s" $virtualServiceObject.id (include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" $root.Values.global.domain)) }}
  {{- end }}
  gateways:
    - {{ $virtualServiceObject.gateway }}
  {{- with (include "2f.uchart.lib.virtualService.field.http" (dict "root" $root "object" $virtualServiceObject) | trim) }}
  http: {{ . | nindent 4 }}
  {{- end }}
{{- end }}
