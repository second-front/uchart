{{- /* Validate binding values */ -}}
{{- define "2f.uchart.lib.rbac.binding.validate" -}}
  {{- $root := .root -}}
  {{- $bindingObject := .object -}}
  {{- $type := required "The binding needs to have an explicitly declared type" $bindingObject.type -}}
  {{- $typeList := list "RoleBinding" "ClusterRoleBinding" -}}
  {{- $subjects := $bindingObject.subjects -}}
  {{- $roleRef := required "A roleRef is required" $bindingObject.roleRef -}}

  {{- if not (mustHas $type $typeList) -}}
    {{- fail (printf "\nYou selected: `%s`. Type must be one of:\n%s\n" $type ($typeList|toYaml)) -}}
  {{- end -}}

  {{- if not (hasKey $roleRef "id") -}}
    {{- $name := required "If not using id roleRef must have a `name` key" $roleRef.name -}}
    {{- $name := required "If not using id roleRef must have a `kind` key" $roleRef.kind -}}
  {{- end -}}

  {{- range $subject := $subjects -}}
    {{- if not (hasKey . "id") -}}
      {{- if not (hasKey . "name") -}}
        {{- $name := required "If not using id a subject must have a `name` key" .name -}}
      {{- else if not (hasKey . "namespace") -}}
        {{- $namespace := required "If not using id a subject must have a `namespace` key" .namespace -}}
      {{- else if not (hasKey . "kind") -}}
        {{- $kind := required "If not using id a subject must have a `kind` key" .kind -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
