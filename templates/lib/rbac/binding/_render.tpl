{{- /* Renders RBAC Role objects required by the chart. */ -}}
{{- define "2f.uchart.lib.rbac.binding.render" -}}
  {{- $root := .root -}}
  {{- $resources := $root.Values.rbac.bindings -}}

  {{- /* Generate bindings as required */ -}}
  {{- $enabledBindings := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $binding := $enabledBindings -}}
    {{- $bindingValues := (mustDeepCopy $binding) -}}

    {{- /* Create object from the raw binding values */ -}}
    {{- $bindingObject := (include "2f.uchart.lib.utils.initialize" (dict "root" $root "resources" $resources "id" $key "values" $bindingValues "kind" "binding" )) | fromYaml -}}

    {{- /* Perform validations on the binding before rendering */ -}}
    {{- include "2f.uchart.lib.rbac.binding.validate" (dict "root" $root "object" $bindingObject) -}}

    {{- /* Include the binding blueprint */ -}}
    {{- include "2f.uchart.lib.rbac.binding.blueprint" (dict "root" $root "object" $bindingObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}