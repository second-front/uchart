
{{- /* recursively template string */ -}}
{{- define "2f.uchart.lib.utils.recursiveTemplate" -}}
  {{- $root := .root -}}
  {{- $value := .value -}}
  {{- $count := .count -}}
  {{- $limit := 4 -}}

  {{- if not $count -}}
    {{- $count = 0 -}}
  {{- end -}}

  {{- if lt $count $limit -}}
    {{- $count = add1 $count -}}
    
    {{- if contains "{{" $value -}}
      {{- $value = tpl $value $root -}}
      {{- $value = include "2f.uchart.lib.utils.recursiveTemplate" (dict "root" $root "value" $value "count" $count) -}}
    {{- end -}}
  {{- end -}}
    
  {{- $value -}}
{{- end -}}