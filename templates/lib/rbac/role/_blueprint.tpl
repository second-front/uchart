{{- /* Blueprint for role objects. */ -}}
{{- define "2f.uchart.lib.rbac.role.blueprint" -}}
  {{- $root := .root -}}
  {{- $roleObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $roleObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $roleObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: {{ $roleObject.type | default "Role" }}
metadata:
  name: {{ $roleObject.name }}
  {{- if eq $roleObject.type "Role" }}
  namespace: {{ $root.Release.Namespace }}
  {{- end }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with $roleObject.rules }}
rules: {{- include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" (. | toYaml | trim)) | nindent 2 -}}
  {{- end -}}
{{- end -}}