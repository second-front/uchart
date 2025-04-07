{{- /* ingress field used by a NetworkPolicy. */ -}}
{{- define "2f.uchart.lib.networkPolicy.fields.ingress" -}}
  {{- $root := .root -}}
  {{- $networkPolicyObject := .object -}}

  {{- with $networkPolicyObject.rules.ingress -}}
    {{- $ingressRules := list -}}

    {{- range $_, $ingress := . -}}
      {{- $ingressRule := dict -}}

      {{- with $ingress.from -}}
        {{- $fromRules := list -}}

        {{- range $_, $from := . -}}
          {{- $fromRule := dict -}}

          {{- if .workload -}}
            {{- $podSelector := dict "matchLabels" (merge
              (dict "app.kubernetes.io/component" .workload)
              (include "2f.uchart.lib.metadata.selectorLabels" $root | fromYaml)
            ) -}}
            
            {{- $_ := set $fromRule "podSelector" $podSelector -}}
          {{- else -}}
            {{- $fromRule = tpl ($from | toYaml) $root | fromYaml -}}
          {{- end -}}

          {{- $fromRules = append $fromRules $fromRule -}}
        {{- end -}}

        {{- $_ := set $ingressRule "from" $fromRules -}}
      {{- end -}}
      {{- with $ingress.ports -}}
        {{- $_ := set $ingressRule "ports" (tpl (. | toYaml) $root | fromYaml) -}}
      {{- end -}}
      
      {{- $ingressRules = append $ingressRules $ingressRule -}}
    {{- end -}}

    {{- $ingressRules | toYaml -}}
  {{- end -}}
{{- end -}}