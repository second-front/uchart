{{- /* Renders the Service objects required by the chart. */ -}}
{{- define "2f.uchart.render.services" -}}
  {{- $root := $ -}}

  {{- /* Generate named Services as required */ -}}
  {{- $enabledServices := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $root.Values.services) | fromYaml ) -}}
  {{- range $key, $svc := $enabledServices -}}
    {{- $serviceValues := (mustDeepCopy $svc) -}}

    {{- /* Create object from the raw Service values */ -}}
    {{- $serviceObject := (include "2f.uchart.lib.service.valuesToObject" (dict "root" $root "id" $key "values" $serviceValues)) | fromYaml -}}

    {{- /* Perform validations on the Service before rendering */ -}}
    {{- include "2f.uchart.lib.service.validate" (dict "root" $root "object" $serviceObject) -}}

    {{- /* Include the Service blueprint */ -}}
    {{- include "2f.uchart.blueprints.service" (dict "root" $root "object" $serviceObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
