{{- /* Renders other manifest objects required by the chart. */ -}}
{{- define "2f.uchart.lib.extraManifest.render" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.extraManifests -}}

  {{- /* Generate extra manifests as required */ -}}
  {{- $enabledManifests := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $manifest := $enabledManifests -}}
    {{- $manifestValues := (mustDeepCopy $manifest) -}}

    {{- /* Create object from the raw manifest values */ -}}
    {{- $manifestObject := (include "2f.uchart.lib.utils.initialize" (dict "root" $root "resources" $resources "id" $key "values" $manifestValues "kind" "extraManifest" )) | fromYaml -}}

    {{- /* Perform validations on the manifest before rendering */ -}}
    {{- include "2f.uchart.lib.extraManifest.validate" (dict "root" $root "object" $manifestObject) -}}

    {{- /* Include the extra manifest blueprint */ -}}
    {{- include "2f.uchart.lib.extraManifest.blueprint" (dict "root" $root "object" $manifestObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}