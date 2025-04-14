{{- /* Renders RBAC objects required by the chart. */ -}}
{{- define "2f.uchart.lib.rbac.render" -}}
  {{- $root := . -}}
  {{- include "2f.uchart.lib.rbac.role.render" (dict "root" $root) -}}
  {{- include "2f.uchart.lib.rbac.binding.render" (dict "root" $root) -}}
{{- end -}}