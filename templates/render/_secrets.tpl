{{- /* Renders the Secret objects required by the chart. */ -}}
{{- define "2f.uchart.render.secrets" -}}
  {{- $root := $ -}}
  {{- $resources := $root.Values.secrets -}}
  {{- $kind := "secret" -}}

  {{- /* Generate named Secrets as required */ -}}
  {{- $enabledSecrets := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $secret := $enabledSecrets -}}
    {{- $secretValues := (mustDeepCopy $secret) -}}

    {{- /* Create object from the raw Secret values */ -}}
    {{- $args := (dict "root" $root "id" $key "values" $secretValues "resources" $resources "kind" $kind) -}}
    {{- $secretObject := (include "2f.uchart.lib.utils.initialize" $args) | fromYaml -}}

    {{- /* Perform validations on the Secret before rendering */ -}}
    {{- include "2f.uchart.lib.secret.validate" (dict "root" $root "object" $secretObject) -}}

    {{/* Include the Secret blueprint */}}
    {{- include "2f.uchart.blueprints.secret" (dict "root" $root "object" $secretObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
