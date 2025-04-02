{{- /* Blueprint for virtualService objects. */ -}}
{{- define "2f.uchart.blueprints.virtualService" -}}
  {{- $root := .root -}}
  {{- $virtualServiceObject := .object -}}

  {{- $annotations := merge
    ($virtualServiceObject.annotations | default dict)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    ($virtualServiceObject.labels | default dict)
    (include "2f.uchart.lib.metadata.allLabels" $root | fromYaml)
  -}}

---
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: {{ $virtualServiceObject.name }}
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
  hosts:
  {{- if hasKey $virtualServiceObject "hostname" }}
    - {{ tpl $virtualServiceObject.hostname $root | quote }}
  {{- else }}
    - {{ printf "%s.%s" $virtualServiceObject.id (tpl $root.Values.global.domain $root) }}
  {{- end }}
  gateways:
    - {{ $virtualServiceObject.gateway }}
  {{- with (include "2f.uchart.lib.virtualService.field.http" (dict "root" $root "object" $virtualServiceObject) | trim) }}
  http: {{ . | nindent 4 }}
  {{- end }}
{{- end }}
