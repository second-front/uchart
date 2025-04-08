{{- /* Renders the virtualService objects required by the chart. */ -}}
{{- define "2f.uchart.lib.virtualService.render" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.virtualServices -}}
  {{- $kind := "virtualService" -}}

  {{- /* Generate named virtualServices as required */ -}}
  {{- $enabledVirtualServices := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $vs := $enabledVirtualServices -}}
    {{- $virtualServiceValues := (mustDeepCopy $vs) -}}

    {{- /* Create object from the raw virtualService values */ -}}
    {{- $args := (dict "root" $root "id" $key "values" $virtualServiceValues "resources" $resources "kind" $kind) -}}
    {{- $virtualServiceObject := (include "2f.uchart.lib.utils.initialize" $args) | fromYaml -}}

    {{- /* Perform validations on the virtualService before rendering */ -}}
    {{- include "2f.uchart.lib.virtualService.validate" (dict "root" $root "object" $virtualServiceObject) -}}

    {{- /* Include the virtualService blueprint */ -}}
    {{- include "2f.uchart.lib.virtualService.blueprint" (dict "root" $root "object" $virtualServiceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
