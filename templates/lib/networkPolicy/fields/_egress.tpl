{{- /* egress field used by a NetworkPolicy. */ -}}
{{- define "2f.uchart.lib.networkPolicy.fields.egress" -}}
  {{- $root := .root -}}
  {{- $networkPolicyObject := .object -}}

  {{- with $networkPolicyObject.rules.egress -}}
    {{- $egressRules := list -}}

    {{- range $_, $egress := . -}}
      {{- $egressRule := dict -}}

      {{- with $egress.to -}}
        {{- $toRules := list -}}

        {{- range $_, $to := . -}}
          {{- $toRule := dict -}}

          {{- if .workload -}}
            {{- $podSelector := dict "matchLabels" (merge
              (dict "app.kubernetes.io/component" .workload)
              (include "2f.uchart.lib.metadata.selectorLabels" $root | fromYaml)
            ) -}}
            
            {{- $_ := set $toRule "podSelector" $podSelector -}}
          {{- else -}}
            {{- $toRule = include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" ($to | toYaml)) | fromYaml -}}
          {{- end -}}

          {{- $toRules = append $toRules $toRule -}}
        {{- end -}}

        {{- $_ := set $egressRule "to" $toRules -}}
      {{- end -}}
      {{- with $egress.ports -}}
        {{- $_ := set $egressRule "ports" (include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" (. | toYaml))) | fromYaml -}}
      {{- end -}}
      
      {{- $egressRules = append $egressRules $egressRule -}}
    {{- end -}}

    {{- $egressRules | toYaml -}}
  {{- end -}}
{{- end -}}