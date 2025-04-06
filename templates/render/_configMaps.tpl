{{- /* Renders the configMap objects required by the chart. */ -}}
{{- define "2f.uchart.render.configMaps" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.configMaps -}}
  {{- $kind := "configMap" -}}

  {{- /* Generate named configMaps as required */ -}}
  {{- $enabledConfigMaps := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $configMap := $enabledConfigMaps -}}
    {{- $configMapValues := (mustDeepCopy $configMap) -}}

    {{- /* Create object from the raw configMap values */ -}}
    {{- $args := (dict "root" $root "id" $key "values" $configMapValues "resources" $resources "kind" $kind) -}}
    {{- $configMapObject := (include "2f.uchart.lib.utils.initialize" $args) | fromYaml -}}

    {{- /* Perform validations on the configMap before rendering */ -}}
    {{- include "2f.uchart.lib.configMap.validate" (dict "root" $root "object" $configMapObject "id" $key) -}}

    {{- /* Include the configMap blueprint */ -}}
    {{- include "2f.uchart.blueprints.configMap" (dict "root" $root "object" $configMapObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
