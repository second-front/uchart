{{- /* Renders RBAC Role objects required by the chart. */ -}}
{{- define "2f.uchart.lib.rbac.role.render" -}}
  {{- $root := .root -}}
  {{- $resources := $root.Values.rbac.roles -}}

  {{- /* Generate roles as required */ -}}
  {{- $enabledRoles := (include "2f.uchart.lib.utils.enabledResources" (dict "root" $root "resources" $resources) | fromYaml ) -}}
  {{- range $key, $role := $enabledRoles -}}
    {{- $roleValues := (mustDeepCopy $role) -}}

    {{- /* Create object from the raw role values */ -}}
    {{- $roleObject := (include "2f.uchart.lib.utils.initialize" (dict "root" $root "resources" $resources "id" $key "values" $roleValues "kind" "role" )) | fromYaml -}}

    {{- /* Perform validations on the role before rendering */ -}}
    {{- include "2f.uchart.lib.rbac.role.validate" (dict "root" $root "object" $roleObject) -}}

    {{- /* Include the role blueprint */ -}}
    {{- include "2f.uchart.lib.rbac.role.blueprint" (dict "root" $root "object" $roleObject) | nindent 0 -}}
  {{- end -}}
{{- end -}}