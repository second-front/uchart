{{- /* Convert values to an object */ -}}
{{- define "2f.uchart.lib.utils.initialize" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $resourceValues := .values -}}
  {{- $resources := .resources -}}
  {{- $kind := .kind -}}
  {{- $dynamicNameKinds := list "workload" "service" "horizontalPodAutoscaler" "podDisruptionBudget" "virtualService" -}}

  {{- /* Determine and inject the name */ -}}
  {{- $resourceName := (include "2f.uchart.lib.chart.names.fullname" $root) -}}

  {{- if hasKey $resourceValues "name" -}}
    {{- $resourceName = $resourceValues.name -}}
  {{- else if $resourceValues.nameOverride -}}
    {{- $override := include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" $resourceValues.nameOverride) | toString -}}
    {{- if not (contains $override $resourceName) -}}
      {{- $resourceName = printf "%s-%s" $resourceName $override -}}
    {{- end -}}
  {{- else if has $kind $dynamicNameKinds -}}
    {{- $enabledResources := include "2f.uchart.lib.utils.enabledResources" ( dict "root" $root "resources" $resources) | fromYaml -}}
    {{- if and (not $resourceValues.primary) (gt (len $enabledResources) 1) -}}
      {{- if not (contains $id $resourceName) -}}
        {{- $resourceName = printf "%s-%s" $resourceName $id -}}
      {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- if and (ne $id "default") (ne $kind "serviceAccount") -}}
      {{- if not (eq $resourceName $id) -}}
        {{- $resourceName = printf "%s-%s" $resourceName $id -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $_ := set $resourceValues "name" $resourceName -}}
  {{- $_ := set $resourceValues "id" $id -}}
  
  {{- $kindFunctionList := list "workload" "horizontalPodAutoscaler" "volume" -}}
  {{- if has $kind $kindFunctionList -}}
    {{- 
      $resourceValues = include (printf "2f.uchart.lib.%s.initialize" $kind) (
        dict "root" $root "id" $id "values" $resourceValues
      ) | fromYaml 
    -}}
  {{- end -}}

  {{- /* Return the object */ -}}
  {{- $resourceValues | toYaml -}}
{{- end -}}
