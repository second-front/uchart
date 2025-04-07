{{- /* Renders the networkPolicy objects required by the chart. */ -}}
{{- define "2f.uchart.render.networkPolicies" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.networkPolicies -}}
  {{- $kind := "networkPolicy" -}}

  {{- /* Generate named networkPolicy as required */ -}}
  {{- $enabledNetworkPolicy := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $netpol := $enabledNetworkPolicy -}}
    {{- $networkPolicyValues := (mustDeepCopy $netpol) -}}

    {{- /* Create object from the raw networkPolicy values */ -}}
    {{- $args := (dict "root" $root "id" $key "values" $networkPolicyValues "resources" $resources "kind" $kind) -}}
    {{- $networkPolicyObject := (include "2f.uchart.lib.utils.initialize" $args) | fromYaml -}}

    {{- /* Perform validations on the networkPolicy before rendering */ -}}
    {{- include "2f.uchart.lib.networkPolicy.validate" (dict "root" $root "object" $networkPolicyObject) -}}

    {{- /* Include the networkPolicy blueprint */ -}}
    {{- include "2f.uchart.blueprints.networkPolicy" (dict "root" $root "object" $networkPolicyObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
