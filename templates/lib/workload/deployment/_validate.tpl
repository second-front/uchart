{{- /* Validate Deployment values */ -}}
{{- define "2f.uchart.lib.workload.deployment.validate" -}}
  {{- $root := .root -}}
  {{- $deploymentValues := .object -}}

  {{- if and (ne $deploymentValues.strategy "Recreate") (ne $deploymentValues.strategy "RollingUpdate") -}}
    {{- fail (printf "Not a valid strategy type for Deployment. (controller: %s, strategy: %s)" $deploymentValues.id $deploymentValues.strategy) -}}
  {{- end -}}
{{- end -}}