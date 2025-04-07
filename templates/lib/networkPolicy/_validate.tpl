{{- /* Validate networkPolicy values */ -}}
{{- define "2f.uchart.lib.networkPolicy.validate" -}}
  {{- $root := .root -}}
  {{- $networkPolicyObject := .object -}}

  {{- if and (not (hasKey $networkPolicyObject "podSelector")) (empty (get $networkPolicyObject "workload")) -}}
    {{- fail (printf "workload reference or podSelector is required for NetworkPolicy. (NetworkPolicy %s)" $networkPolicyObject.id) -}}
  {{- end -}}

  {{- if empty (get $networkPolicyObject "policyTypes") -}}
    {{- fail (printf "policyTypes is required for NetworkPolicy. (NetworkPolicy %s)" $networkPolicyObject.id) -}}
  {{- end -}}

  {{- $allowedPolicyTypes := list "Ingress" "Egress" -}}
  {{- range $networkPolicyObject.policyTypes -}}
    {{- if not (has . $allowedPolicyTypes) -}}
      {{- fail (printf "Not a valid policyType for NetworkPolicy. (NetworkPolicy %s, value %s)" $networkPolicyObject.id .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}