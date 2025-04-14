{{- /* Validate Role values */ -}}
{{- define "2f.uchart.lib.rbac.role.validate" -}}
  {{- $root := .root -}}
  {{- $roleObject := .object -}}
  {{- $type := $roleObject.type | required "The role needs to have an explicitly declared type" -}}
  {{- $typeList := list "Role" "ClusterRole" -}}
  {{- $rules := $roleObject.rules -}}

  {{- if not (mustHas $type $typeList) -}}
    {{- fail (printf "\nYou selected: `%s`. Type must be one of:\n%s\n" $type ($typeList|toYaml)) -}}
  {{- end -}}
  {{- if not $rules -}}
    {{- fail "Rules can't be empty" -}}
  {{- end -}}

{{- end -}}
