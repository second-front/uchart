{{- /* Blueprint for roleBinding objects. */ -}}
{{- define "2f.uchart.lib.rbac.binding.blueprint" -}}
  {{- $root := .root -}}
  {{- $bindingObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $bindingObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}
  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $bindingObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}

  {{- $subjects := list -}}
  {{- with $bindingObject.subjects -}}
    {{- range $subject := . -}}
      {{- if hasKey . "id" -}}
        {{- $subject := include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.serviceAccounts "id" .id "kind" "serviceAccount") | fromYaml -}}
        {{- $subject = pick $subject "name" -}}
        {{- $_ := set $subject "kind" "ServiceAccount" -}}
        {{- $_ := set $subject "namespace" $root.Release.Namespace -}}
        {{- $subjects = mustAppend $subjects $subject -}}
      {{- else -}}
        {{- $subject := dict "name" .name "kind" .kind "namespace" .namespace -}}
        {{- $subjects = mustAppend $subjects $subject -}}
      {{- end -}}
    {{- end -}}
    {{- $subjects = $subjects | uniq | toYaml -}}
  {{- end -}}

  {{- $role := dict -}}
  {{- with  $bindingObject.roleRef -}}
    {{- if hasKey . "id" -}}
      {{- $role = include "2f.uchart.lib.utils.getById" (dict "root" $root "resources" $root.Values.rbac.roles "id" .id "kind" "role") | fromYaml -}}
    {{- else -}}
      {{- $_ := set $role "name" .name -}}
      {{- $_ := set $role "type" .kind -}}
    {{- end -}}
  {{- end -}}
---
apiVersion: rbac.authorization.k8s.io/v1
  {{- with $bindingObject.type }}
kind: {{ . }}
  {{- end }}
metadata:
  name: {{ $bindingObject.name }}
  {{- if eq $bindingObject.type "RoleBinding" }}
  namespace: {{ $root.Release.Namespace }}
  {{- end }}
  {{- with $labels }}
  labels: {{ toYaml . | nindent 4 -}}
  {{- end }}
  {{- with $annotations }}
  annotations: {{ toYaml . | nindent 4 -}}
  {{- end }}
roleRef:
  kind: {{ $role.type }}
  name: {{ $role.name }}
  apiGroup: rbac.authorization.k8s.io
  {{- with $subjects }}
subjects: {{ include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" .) | nindent 2 }}
  {{- end }}
{{- end -}}
