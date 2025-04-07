{{- /* Blueprint for Network Policy objects. */ -}}
{{- define "2f.uchart.blueprints.networkPolicy" -}}
  {{- $root := .root -}}
  {{- $networkPolicyObject := .object -}}

  {{- $annotations := merge
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $networkPolicyObject.annotations) | fromYaml)
    (include "2f.uchart.lib.metadata.globalAnnotations" $root | fromYaml)
  -}}

  {{- $labels := merge
    (include "2f.uchart.lib.metadata.standardLabels" $root | fromYaml)
    (include "2f.uchart.lib.metadata.localMetadata" (dict "root" $root "values" $networkPolicyObject.labels) | fromYaml)
    (include "2f.uchart.lib.metadata.globalLabels" $root | fromYaml)
  -}}

  {{- $podSelector := dict "matchLabels" (merge
    ($networkPolicyObject.extraSelectorLabels | default dict)
    (dict "app.kubernetes.io/component" $networkPolicyObject.workload)
    (include "2f.uchart.lib.metadata.selectorLabels" $root | fromYaml)
  ) -}}
  {{- if (hasKey $networkPolicyObject "podSelector") -}}
    {{- $podSelector = $networkPolicyObject.podSelector -}}
  {{- end -}}
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: {{ $networkPolicyObject.name }}
  namespace: {{ $root.Release.Namespace }}
  {{- with $annotations }}
  annotations: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with $labels }}
  labels: {{ . | toYaml | nindent 4 }}
  {{- end }}
spec:
  podSelector: {{ $podSelector | toYaml | nindent 4 }}
  {{- with $networkPolicyObject.policyTypes }}
  policyTypes: {{ . | toYaml | nindent 4 }}
  {{- end }}
  {{- with $networkPolicyObject.rules.ingress }}
  ingress: {{- include "2f.uchart.lib.networkPolicy.fields.ingress" (dict "root" $root "object" $networkPolicyObject) | nindent 4 -}}
  {{- end }}
  {{- with $networkPolicyObject.rules.egress }}
  egress: {{- include "2f.uchart.lib.networkPolicy.fields.egress" (dict "root" $root "object" $networkPolicyObject) | nindent 4 -}}
  {{- end }}
{{- end -}}