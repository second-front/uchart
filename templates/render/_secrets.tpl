{{- /* Renders the Secret objects required by the chart. */ -}}
{{- define "2f.uchart.render.secrets" -}}
  {{- $root := $ -}}

  {{- /* Generate named Secrets as required */ -}}
  {{- $enabledSecrets := (include "2f.uchart.lib.secret.enabledSecrets" (dict "root" $root) | fromYaml ) -}}
  {{- range $key, $secret := $enabledSecrets -}}
    {{- $secretValues := (mustDeepCopy $secret) -}}

    {{- /* Create object from the raw Secret values */ -}}
    {{- $secretObject := (include "2f.uchart.lib.utils.valuesToObject" (dict "root" $root "id" $key "values" $secretValues)) | fromYaml -}}

    {{- /* Perform validations on the Secret before rendering */ -}}
    {{- include "2f.uchart.lib.secret.validate" (dict "root" $root "object" $secretObject) -}}

    {{/* Include the Secret blueprint */}}
    {{- include "2f.uchart.blueprints.secret" (dict "root" $root "object" $secretObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}
