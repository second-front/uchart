{{- /* Renders Route objects required by the chart. */ -}}
{{- define "2f.uchart.lib.route.render" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.routes -}}
  {{- $kind := "route" -}}

  {{- /* Generate named routes as required */ -}}
  {{- $enabledRoutes := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $route := $enabledRoutes -}}
    {{- $routeValues := (mustDeepCopy $route) -}}

    {{- /* Create object from the raw Route values */ -}}
    {{- $args := (dict "root" $root "id" $key "values" $routeValues "resources" $resources "kind" $kind) -}}
    {{- $routeObject := (include "2f.uchart.lib.utils.initialize" $args) | fromYaml -}}

    {{- /* Perform validations on the Route before rendering */ -}}
    {{- include "2f.uchart.lib.route.validate" (dict "root" $root "object" $routeObject) -}}

    {{- /* Include the Route blueprint */ -}}
    {{- include "2f.uchart.lib.route.blueprint" (dict "root" $root "object" $routeObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
