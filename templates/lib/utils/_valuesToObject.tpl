{{- /* Convert values to an object */ -}}
{{- define "2f.uchart.lib.utils.valuesToObject" -}}
  {{- $root := .root -}}
  {{- $id := .id -}}
  {{- $resourceValues := .values -}}
  {{- $resources := .resources -}}
  {{- $kind := .kind -}}

  {{- /* Determine and inject the name */ -}}
  {{- $resourceName := (include "2f.uchart.lib.chart.names.fullname" $root) -}}

  {{- if hasKey $resourceValues "name" -}}
    {{- $resourceName = $resourceValues.name -}}
  {{- else if $resourceValues.nameOverride -}}
    {{- $override := tpl $resourceValues.nameOverride $root -}}
    {{- if not (eq $resourceName $override) -}}
      {{- $resourceName = printf "%s-%s" $resourceName $override -}}
    {{- end -}}
  {{- else -}}
    {{- if and (ne $id "default") (ne $kind "serviceAccount") -}}
      {{- 
        $enabledResources := include "2f.uchart.lib.utils.enabledResources" (
          dict "root" $root "resources" $resources
        ) | fromYaml 
      -}}

      {{- if and (not $resourceValues.primary) (gt (len $enabledResources) 1) -}}
        {{- if not (eq $resourceName $id) -}}
          {{- $resourceName = printf "%s-%s" $resourceName $id -}}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}

  {{- $_ := set $resourceValues "name" $resourceName -}}
  {{- $_ := set $resourceValues "id" $id -}}
  
  {{- $kindFunctionList := list "workload" "hpa" -}}
  {{- if has $kind $kindFunctionList -}}
    {{- 
      $resourceValues = include (printf "2f.uchart.lib.%s.valuesToObject" $kind) (
        dict "root" $root "id" $id "values" $resourceValues
      ) | fromYaml 
    -}}
  {{- end -}}

  {{- /* Return the object */ -}}
  {{- $resourceValues | toYaml -}}
{{- end -}}
