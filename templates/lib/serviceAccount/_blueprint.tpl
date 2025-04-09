{{- /* Blueprint for serviceAccount objects. */ -}}
{{- define "2f.uchart.lib.serviceAccount.blueprint" -}}
  {{- $root := .root -}}
  {{- $serviceAccountObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $serviceAccountObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $serviceAccountObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ $serviceAccountObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- if $serviceAccountObject.createSecret }}
secrets:
  - name: {{ get (include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.secrets "id" (printf "%s-sa-token" $serviceAccountObject.id) ) | fromYaml) "name"}}
  {{- end }}
{{- end -}}
