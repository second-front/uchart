{{- /* Renders the configMap objects required by the chart. */ -}}
{{- define "2f.uchart.render.configMaps" -}}
  {{- $root := $ -}}

  {{- /* Generate named configMaps as required */ -}}
  {{- $enabledConfigMaps := (include "2f.uchart.lib.configMap.enabledConfigMaps" (dict "root" $root) | fromYaml ) -}}
  {{- range $key, $configMap := $enabledConfigMaps -}}
    {{- $configMapValues := (mustDeepCopy $configMap) -}}

    {{- /* Create object from the raw configMap values */ -}}
    {{- $configMapObject := (include "2f.uchart.lib.utils.valuesToObject" (dict "root" $root "id" $key "values" $configMapValues)) | fromYaml -}}
    {{- /* Perform validations on the configMap before rendering */ -}}
    {{- include "2f.uchart.lib.configMap.validate" (dict "root" $root "object" $configMapObject "id" $key) -}}

    {{/* Include the configMap blueprint */}}
    {{- include "2f.uchart.blueprints.configMap" (dict "root" $root "object" $configMapObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
